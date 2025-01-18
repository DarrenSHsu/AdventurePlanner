//
//  SearchPlace.swift
//  AdventurePlanner
//
//  Created by Darren Hsu on 4/26/24.
//  Copyright © 2024 Darren Hsu. All rights reserved.
//

import SwiftUI

struct Choice {
    var title: String
    var isSelected: Bool
}

struct SearchPlace: View {
    
    // Input Parameter
    let dest: Destination
    @State private var selectedIndex = 0
    
    @State private var searchCompleted = false
    @State private var showProgressView = false
    
    //General categories
    let optionsChoices = ["Shopping Options", "Food Options", "General Activities", "Transport Options", "Miscellaneous Options"]
    
    //Individual types per category
    @State var miscellaneousOptions = [
        Choice(title: "Atm", isSelected: false),
        Choice(title: "Hospital", isSelected: false),
        Choice(title: "Laundry", isSelected: false),
        Choice(title: "Lodging", isSelected: false)
    ]
      
    @State var foodOptions = [
        Choice(title: "Bakery", isSelected: false),
        Choice(title: "Cafe", isSelected: false),
        Choice(title: "Bar", isSelected: false),
        Choice(title: "Restaurant", isSelected: false),
    ]

    @State var generalActivities = [
        Choice(title: "Tourist Attraction", isSelected: false),
        Choice(title: "Zoo", isSelected: false),
        Choice(title: "Spa", isSelected: false),
        Choice(title: "Park", isSelected: false),
        Choice(title: "Night Club", isSelected: false),
        Choice(title: "Museum", isSelected: false),
        Choice(title: "Library", isSelected: false),
        Choice(title: "Amusement Park", isSelected: false),
        Choice(title: "Aquarium", isSelected: false),
        Choice(title: "Art Gallery", isSelected: false),
        Choice(title: "Beauty Salon", isSelected: false),
        Choice(title: "Casino", isSelected: false),
    ]
    
    @State var shoppingOptions = [
        Choice(title: "Supermarket", isSelected: false),
        Choice(title: "Shopping Mall", isSelected: false),
        Choice(title: "Liquor Store", isSelected: false),
        Choice(title: "Convenience Store", isSelected: false),
        Choice(title: "Clothing Store", isSelected: false),
        Choice(title: "Department Store", isSelected: false),
        Choice(title: "Drugstore", isSelected: false),
        Choice(title: "Store", isSelected: false),
        Choice(title: "Pharmacy", isSelected: false),
    ]
    
    @State var transportOptions = [
        Choice(title: "Train Station", isSelected: false),
        Choice(title: "Transit Station", isSelected: false),
        Choice(title: "Subway Station", isSelected: false),
        Choice(title: "Bus Station", isSelected: false),
        Choice(title: "Airport", isSelected: false),
        Choice(title: "Car Rental", isSelected: false),
        Choice(title: "Taxi Stand", isSelected: false),
    ]
    
    //--------------
    // Alert Message
    //--------------
    @State private var showAlertMessage = false
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Image("GooglePlacesApiLogo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 50)
                        Spacer()
                    }
                }
                //Pick main category
                Section(header: Text("Select Search Category")) {
                    Picker("", selection: $selectedIndex) {
                        ForEach(0 ..< optionsChoices.count, id: \.self) {
                            Text(optionsChoices[$0])
                        }
                    }
                }
                //Show the appropriate category of types
                switch selectedIndex {
                    
                case 0:
                    Section(header: Text("Select Search Options")) {
                        VStack(alignment: .leading, spacing: 5) {
                                    ForEach(0..<shoppingOptions.count, id:\.self) { index in
                                        HStack {
                                            Image(systemName: shoppingOptions[index].isSelected ? "checkmark.square" : "square")
                                                .imageScale(.medium)
                                                .font(Font.title.weight(.regular))
                                                .foregroundColor(.blue)
                                                .onTapGesture {
                                                    shoppingOptions[index].isSelected.toggle()
                                                }
                                          
                                            Text(shoppingOptions[index].title)
                                        }
                                    }   // End of ForEach
                                }   // End of VStack
                    }
                case 1:
                    Section(header: Text("Select Search Options")) {
                        VStack(alignment: .leading, spacing: 5) {
                                    ForEach(0..<foodOptions.count, id:\.self) { index in
                                        HStack {
                                            Image(systemName: foodOptions[index].isSelected ? "checkmark.square" : "square")
                                                .imageScale(.medium)
                                                .font(Font.title.weight(.regular))
                                                .foregroundColor(.blue)
                                                .onTapGesture {
                                                    foodOptions[index].isSelected.toggle()
                                                }
                                          
                                            Text(foodOptions[index].title)
                                        }
                                    }   // End of ForEach
                                }   // End of VStack
                    }
                    
                case 2:
                    Section(header: Text("Select Search Options")) {
                        VStack(alignment: .leading, spacing: 5) {
                                    ForEach(0..<generalActivities.count, id:\.self) { index in
                                        HStack {
                                            Image(systemName: generalActivities[index].isSelected ? "checkmark.square" : "square")
                                                .imageScale(.medium)
                                                .font(Font.title.weight(.regular))
                                                .foregroundColor(.blue)
                                                .onTapGesture {
                                                    generalActivities[index].isSelected.toggle()
                                                }
                                          
                                            Text(generalActivities[index].title)
                                        }
                                    }   // End of ForEach
                                }   // End of VStack
                    }
                    
                case 3:
                    Section(header: Text("Select Search Options")) {
                        VStack(alignment: .leading, spacing: 5) {
                                    ForEach(0..<transportOptions.count, id:\.self) { index in
                                        HStack {
                                            Image(systemName: transportOptions[index].isSelected ? "checkmark.square" : "square")
                                                .imageScale(.medium)
                                                .font(Font.title.weight(.regular))
                                                .foregroundColor(.blue)
                                                .onTapGesture {
                                                    transportOptions[index].isSelected.toggle()
                                                }
                                          
                                            Text(transportOptions[index].title)
                                        }
                                    }   // End of ForEach
                                }   // End of VStack
                    }
                default:
                    Section(header: Text("Select Search Options")) {
                        VStack(alignment: .leading, spacing: 5) {
                                    ForEach(0..<miscellaneousOptions.count, id:\.self) { index in
                                        HStack {
                                            Image(systemName: miscellaneousOptions[index].isSelected ? "checkmark.square" : "square")
                                                .imageScale(.medium)
                                                .font(Font.title.weight(.regular))
                                                .foregroundColor(.blue)
                                                .onTapGesture {
                                                    miscellaneousOptions[index].isSelected.toggle()
                                                }
                                          
                                            Text(miscellaneousOptions[index].title)
                                        }
                                    }   // End of ForEach
                                }   // End of VStack
                    }
                }
                 
                Section(header: Text("Search Nearby")) {
                    HStack {
                        Spacer()
                        Button(searchCompleted ? "Search Completed" : "Search") {
                            if (inputDataValidated()) {
                                showProgressView = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    /*
                                     Execute the following code after 0.1 second of delay
                                     so that they are not executed during the view update.
                                     */
                                    searchApi()
                                    
                                    // API search is completed
                                    showProgressView = false
                                    searchCompleted = true
                                }
                            }
                            else {
                                showAlertMessage = true
                                alertTitle = "Missing Input Data!"
                                alertMessage = "Please enter a database search query!"
                            }
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        
                        Spacer()
                    }
                }
                
                if searchCompleted {
                    Section(header: Text("List Places Found")) {
                        NavigationLink(destination: showSearchResults) {
                            HStack {
                                Image(systemName: "list.bullet")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                Text("List Places Found")
                                    .font(.system(size: 16))
                            }
                            .foregroundColor(.blue)
                        }
                    }
                }   // End of if
                
            }   // End of Form
            .navigationTitle("Search Nearby Places")
            .toolbarTitleDisplayMode(.inline)
            .onAppear() {
                searchCompleted = false
            }
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                Button("OK") {}
            }, message: {
                Text(alertMessage)
            })
        }   // End of NavigationStack
    }
    
    /*
     ------------------
     MARK: Search API
     ------------------
     */
    func searchApi() {
        let selectedSearchOptionsArray = createSearchQueryArray()
        getNearbyApiData(searchArray: selectedSearchOptionsArray)
    }
    
    /*
     -------------------------
     MARK: Show Search Results
     -------------------------
     */
    var showSearchResults: some View {
        if placesList.isEmpty {
            return AnyView(
                NotFound(message: "No Place Found!\n\nThe API did not return any location near this location!")
            )
        }
        
        return AnyView(
            FoundPlaceList(dest: dest, searchArray: createSearchQueryArray())
                .navigationTitle("City Place Search Results")
                .toolbarTitleDisplayMode(.inline)
        )
    }
    /*
     ---------------------------
     MARK: Input Data Validation
     ---------------------------
     */
    func inputDataValidated() -> Bool {
        switch selectedIndex {
        case 0:
            for thing in shoppingOptions {
                if thing.isSelected {
                    return true
                }
            }
            
        case 1:
            for thing in foodOptions {
                if thing.isSelected {
                    return true
                }
            }
            
        case 2:
            for thing in generalActivities {
                if thing.isSelected {
                    return true
                }
            }
            
        case 3:
            for thing in transportOptions {
                if thing.isSelected {
                    return true
                }
            }
            
        default:
            for thing in miscellaneousOptions {
                if thing.isSelected {
                    return true
                }
            }
        }
        return false
    }
    /*
     ------------------
     MARK: Create Search Query Array
     ------------------
     */
    //creates an array of strings, the first two being latitude and longitude, and the rest being apiurls
    func createSearchQueryArray() -> [String] {
        var selectedSearchOptionsArray = [String]()
        selectedSearchOptionsArray.append("\(dest.latitude)")
        selectedSearchOptionsArray.append("\(dest.longitude)")
        
        switch selectedIndex {
        case 0:
            for thing in shoppingOptions {
                if thing.isSelected {
                    selectedSearchOptionsArray.append(thing.title)
                }
            }
            
        case 1:
            for thing in foodOptions {
                if thing.isSelected {
                    selectedSearchOptionsArray.append(thing.title)
                }
            }
            
        case 2:
            for thing in generalActivities {
                if thing.isSelected {
                    selectedSearchOptionsArray.append(thing.title)
                }
            }
            
        case 3:
            for thing in transportOptions {
                if thing.isSelected {
                    selectedSearchOptionsArray.append(thing.title)
                }
            }
            
        default:
            for thing in miscellaneousOptions {
                if thing.isSelected {
                    selectedSearchOptionsArray.append(thing.title)
                }
            }
        }
        return selectedSearchOptionsArray
    }
}

