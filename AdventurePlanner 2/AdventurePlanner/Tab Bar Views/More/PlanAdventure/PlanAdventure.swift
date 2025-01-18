//
//  PlanAdventure.swift
//  AdventurePlanner
//
//  Created by Nicholas Luke Emig on 4/30/24.
//  Copyright © 2024 Nicholas Emig. All rights reserved.
//  Modified and resued code snippets from origina creator Osman Balci
//

import SwiftUI
import SwiftData

// Global variable to hold the current selected destination
var currDest = [Destination]()

var currPlaces = [DestPlace]()

var currNotes = [Note]()

struct PlanAdventure: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var name = ""
    @State private var id = 0
    @State private var destArray = [Destination]()
    @State private var placeArray = [DestPlace]()
    @State private var infoArray = [AdventureInfo]()
    
    @State private var showAlertMessage = false
    
    var body: some View {
        return AnyView(
        Form {
            Section(header: Text("Adventure Title")) {
                TextField("Enter Adventure Title", text: $name)
            }
            
            Section() {
                if !infoArray.isEmpty {
                    ForEach(infoArray) { anInfo in
                        Section(header: Text("Destination #\(anInfo.id+1):")) {
                            HStack {
                                getImageFromUrl(url: "https://flagcdn.com/w320//\(anInfo.destinations[0].countryCode.lowercased()).png", defaultFilename: "ImageUnavailable")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100.0, height: 75.0)
                                
                                VStack(alignment: .leading) {
                                    Text(anInfo.destinations[0].name)
                                        .fixedSize(horizontal: true, vertical: false)
                                    if (anInfo.destinations[0].region != ""){
                                        Text("\(anInfo.destinations[0].region), \(anInfo.destinations[0].countryCode)")
                                            .fixedSize(horizontal: true, vertical: false)
                                    }
                                    else {
                                        Text(anInfo.destinations[0].countryCode)
                                            .fixedSize(horizontal: true, vertical: false)
                                    }
                                }
                                .font(.system(size: 14))
                            }
                            if !anInfo.places.isEmpty {
                                Text("Places:")
                                ForEach(anInfo.places, id:\.self) { aPlace in
                                    HStack {
                                        getImageFromUrl(url: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=500&photo_reference=\(aPlace.photo_reference)&key=\(myGooglePlacesApiKey)", defaultFilename: "ImageUnavailable")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 80.0)
                                        
                                        VStack(alignment: .leading) {
                                            if (aPlace.name.count > 20) {
                                                Text("Name: " + aPlace.name.dropLast(aPlace.name.count - 20) + "...")
                                                    .fixedSize(horizontal: true, vertical: true)
                                            }
                                            else {
                                                Text("Name: " + aPlace.name)
                                                    .fixedSize(horizontal: true, vertical: true)
                                            }
                                            Text("\(aPlace.vicinity)")
                                                .fixedSize(horizontal: true, vertical: false)
                                        }
                                        .font(.system(size: 14))
                                    }
                                } 
                            }
                        }
                        HStack {
                            Spacer()
                            Image(systemName: "arrowshape.down")
                                .foregroundColor(.blue)
                                .imageScale(.large)
                            Spacer()
                        }
                    }
                }
            }
            
            if !destArray.isEmpty {
                Section() {
                    VStack {
                        Text("Destination:")
                        DestinationItem(dest: destArray[0])
                        Spacer()
                        
                        Text("Places:")
                        ForEach(placeArray) { aPlace in
                            PlaceItem(place: aPlace)
                        }
                    }
                }
                Section() {
                    NavigationLink(destination: ChoosePlacesList(dest: destArray[0])) {
                        HStack {
                            Image(systemName: "plus")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            Text("Select Places to Add")
                                .font(.system(size: 16))
                        }
                        .foregroundColor(.blue)
                    }
                }
                
                HStack {
                    Spacer()
                    Button("Clear") {
                        clear()
                    }
                    .tint(.blue)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    
                    Spacer()
                    
                    Button("Save") {
                        saveSelections()
                        clear()
                    }
                    .tint(.blue)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    Spacer()
                    
                }
            }
            Section(header: Text("Add Destination")) {
                HStack {
                    Section(header: Text("")) {
                        NavigationLink(destination: ChooseDestinationList()) {
                            HStack {
                                Image(systemName: "plus")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                Text("Select Destination")
                                    .font(.system(size: 16))
                            }
                            .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
            .navigationTitle("Create Adventure")
            .toolbarTitleDisplayMode(.inline)
            .onAppear(perform: {
            updateArrays()
        })
        .toolbar {
            // Place the Save button on right side of the toolbar
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    if inputDataValidated() {
                        saveNewAdventure()
                        showAlertMessage = true
                        alertTitle = "New Adventure Saved!"
                        alertMessage = "Your new Adventure is successfully saved in the database!"
                    } else {
                        showAlertMessage = true
                        alertTitle = "Missing Required Information!"
                        alertMessage = "Choose a name and at least one location to create an adventure!"
                    }
                }
            }
        }
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                Button("OK") {
                    if alertTitle == "New Trip Saved!" {
                        // Dismiss this view and go back to the previous view
                        dismiss()
                    }
                }
            }, message: {
                Text(alertMessage)
            })
        )
    }
    
    // Function to update Arrays when a new destination or place is selected
    func updateArrays() {
        if !currDest.isEmpty {
            destArray.append(currDest[0])
            currDest = [Destination]()
        }
        if !currPlaces.isEmpty {
            for aPlace in currPlaces {
                placeArray.append(aPlace)
            }
            currPlaces = [DestPlace]()
        }
    }
    
    // Function to clear current selections
    func clear() {
        currDest = [Destination]()
        currPlaces = [DestPlace]()
        placeArray = [DestPlace]()
        destArray = [Destination]()
    }
    
    // Function to save current selections as a new Adventure object in the databse
    func saveSelections() {
        let newDest = AdvDestStruct(id: destArray[0].id, wikiDataId: destArray[0].wikiDataId, city: destArray[0].city, name: destArray[0].name, country: destArray[0].country, countryCode: destArray[0].countryCode, region: destArray[0].region, regionCode: destArray[0].regionCode, latitude: destArray[0].latitude, longitude: destArray[0].longitude, population: destArray[0].population)
        var newDestArray = [AdvDestStruct]()
        newDestArray.append(newDest)
        
        var newPlaceArray = [AdvPlaceStruct]()
        for aPlace in placeArray {
            let newPlace = AdvPlaceStruct(business_status: aPlace.business_status, lat: aPlace.lat, lng: aPlace.lng, icon: aPlace.icon, name: aPlace.name, photo_reference: aPlace.photo_reference, price_level: aPlace.price_level, rating: aPlace.rating, user_ratings_total: aPlace.user_ratings_total, vicinity: aPlace.vicinity)
            newPlaceArray.append(newPlace)
        }
        
        let newInfo = AdventureInfo(id: infoArray.count, destinations: newDestArray, places: newPlaceArray)
        infoArray.append(newInfo)
        //let newAdv = Adventure(name: name, id: id, info: infoArray)
        
    }
    
    // Function to validate input
    func inputDataValidated() -> Bool {
        if infoArray.isEmpty || name.isEmpty {
            return false
        }
        return true
    }
    
    // Function to sve adventure to database
    func saveNewAdventure() {
        let newAdventure = Adventure(name: name, id: id, info: infoArray)
        modelContext.insert(newAdventure)
    }
}
