//
//  FoundCityDetails.swift
//  AdventurePlanner
//
//  Created by Darren Hsu on 4/27/24.
//  Copyright © 2024 Darren Hsu. All rights reserved.
//

import SwiftUI
import MapKit
import SwiftData

fileprivate var cityLocationCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)

struct FoundCityDetails: View {
    
    @State private var showAlertMessage = false
    
    // Enable this view to be dismissed to go back to the previous view
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var destList: [Destination]
    
    // Input Parameter
    let city: CityStruct
    
    //---------
    // Map View
    //---------
    var mapStyles = ["Standard", "Satellite", "Hybrid", "Globe"]
    @State private var selectedMapStyleIndex = 0
    
    var body: some View {
        
        cityLocationCoordinate = CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude)
        
        return AnyView(
            Form {
                Section(header: Text("Add This City to Trips List")) {
                    Button(action: {
                        var alreadyInDatabase = false
                        for aDest in destList {
                            if aDest.name == city.name {
                                alreadyInDatabase = true
                                break
                            }
                        }
                        
                        if alreadyInDatabase {
                            alertTitle = "City in Database"
                            alertMessage = "This city already exists in your trips list."
                            showAlertMessage = true
                        } else {
                            // Instantiate a new Dest object and dress it up
                            let newDest = Destination(id: city.id, wikiDataId: city.wikiDataId, city: city.city, name: city.name, country: city.country, countryCode: city.countryCode, region: city.region, regionCode: city.regionCode, latitude: city.latitude, longitude: city.longitude, population: city.population, destPhotos: [DestPhoto](), destPlaces: [DestPlace](), covidData: DestCovid(checkTime: "", activeCases: "", country: "", lastUpdate: "", newCases: "", newDeaths: "", totalCases: "", totalDeaths: "", totalRecovered: ""))
                            
                            // Insert the new Destination object into the database
                            modelContext.insert(newDest)
                            
                            alertTitle = "Destination Added"
                            alertMessage = "This place is added to your Trips List."
                            showAlertMessage = true
                        }
                    }) {
                        HStack {
                            Image(systemName: "plus")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                                .foregroundColor(.blue)
                            Text("Add Destination to Trip List")
                                .font(.system(size: 16))
                        }
                    }
                }
                if (city.name != city.city) {
                    Section(header: Text("Location Name")) {
                        Text(city.name)
                    }
                }
                Section(header: Text("City Name")) {
                    Text(city.city)
                }
                if (city.region != "") {
                    Section(header: Text("Region")) {
                        Text(city.region)
                    }
                }
                Section(header: Text("Country")) {
                    Text(city.country)
                }
                Section(header: Text("Country Flag Image"), footer: Text("Official Flag of the Country").italic()) {
                    
                    getImageFromUrl(url: "https://flagcdn.com/w320/\(city.countryCode.lowercased()).png", defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                        // Flag image is obtained from the API with width of 320
                        .frame(minWidth: 300, maxWidth: 320, alignment: .center)
                        .contextMenu {
                            Button(action: {        // Context Menu Item
                                // Copy the flag image to universal clipboard for pasting elsewhere
                                UIPasteboard.general.image = getUIImageFromUrl(url: "https://flagcdn.com/w320/\(city.countryCode.lowercased()).png", defaultFilename: "ImageUnavailable")
                                
                                showAlertMessage = true
                                alertTitle = "Flag Image is Copied to Clipboard"
                                alertMessage = "You can paste it on your iPhone, iPad, Mac laptop or Mac desktop each running under your Apple ID"
                            }) {
                                Image(systemName: "doc.on.doc")
                                Text("Copy")
                            }
                        }
                }
                Section(header: Text("Population")) {
                    Text("About \(city.population) People")
                }
                Section(header: Text("Select Map Style")) {
                    Picker("Select Map Style", selection: $selectedMapStyleIndex) {
                        ForEach(0 ..< mapStyles.count, id: \.self) { index in
                            Text(mapStyles[index]).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    NavigationLink(destination: CityLocationOnMap(city: city, mapStyleIndex: selectedMapStyleIndex)) {
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            Text("Show Trip Location on Map")
                                .font(.system(size: 16))
                        }
                        .foregroundColor(.blue)
                    }
                }
            }   // End of Form
                .font(.system(size: 14))
                .navigationTitle("Destination Details")
                .toolbarTitleDisplayMode(.inline)
                .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                    Button("OK") {
                        dismiss()
                    }
                }, message: {
                    Text(alertMessage)
                })
            
        )   // End of AnyView
    }   // End of body var
    struct CityLocationOnMap: View {
        
        // Input Parameters
        let city: CityStruct
        let mapStyleIndex: Int
        
        @State private var mapCameraPosition: MapCameraPosition = .region(
            MKCoordinateRegion(
                center: cityLocationCoordinate,
                // 1 degree = 69 miles. 10 degrees = 690 miles
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
        )
        
        var body: some View {
            
            var mapStyle: MapStyle = .standard
            
            switch mapStyleIndex {
            case 0:
                mapStyle = MapStyle.standard
            case 1:
                mapStyle = MapStyle.imagery     // Satellite
            case 2:
                mapStyle = MapStyle.hybrid
            case 3:
                mapStyle = MapStyle.hybrid(elevation: .realistic)   // Globe
            default:
                print("Map style is out of range!")
            }
            
            return AnyView(
                Map(position: $mapCameraPosition) {
                    Marker(city.city, coordinate: cityLocationCoordinate)
                }
                .mapStyle(mapStyle)
                .navigationTitle("\(city.city), \(city.region), \(city.countryCode)")
                .toolbarTitleDisplayMode(.inline)
            )
        }   // End of body var
    }
}

