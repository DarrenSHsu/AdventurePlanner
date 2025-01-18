//
//  FoundPlaceDetails.swift
//  AdventurePlanner
//
//  Created by Darren Hsu on 4/26/24.
//  Copyright © 2024 Darren Hsu. All rights reserved.
//

import SwiftUI
import SwiftData
import MapKit

fileprivate var placeLocationCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)

struct FoundPlaceDetails: View {
    // Input Parameter
    let place: PlaceStruct
    let dest: Destination
    
    // Enable this view to be dismissed to go back to the previous view
    @Environment(\.dismiss) private var dismiss
    
    var mapStyles = ["Standard", "Satellite", "Hybrid", "Globe"]
    @State private var selectedMapStyleIndex = 0
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var showAlertMessage = false
    
    var body: some View {
        
        placeLocationCoordinate = CLLocationCoordinate2D(latitude: place.lat, longitude: place.lng)
        
        return AnyView(
            Form {
                //Add to main list and database
                Section(header: Text("Add this place to destination")) {
                    Button(action: {
                        // Instantiate a new Place object and dress it up
                        let newPlace = DestPlace(business_status: place.business_status, lat: place.lat, lng: place.lng, icon: place.icon, name: place.name, photo_reference: place.photo_reference, price_level: place.price_level, rating: place.rating, user_ratings_total: place.user_ratings_total, vicinity: place.vicinity)
                        
                        
                        // Insert the new Place object into the database
                        modelContext.insert(newPlace)
                        
                        dest.destPlaces?.append(newPlace)
                        
                        alertTitle = "Place Added"
                        alertMessage = "This place is added to your trip's place list."
                        showAlertMessage = true
                    }) {
                        HStack {
                            Image(systemName: "plus")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                                .foregroundColor(.blue)
                            Text("Add Place to Trip")
                                .font(.system(size: 16))
                        }
                    }
                }
                Section(header: Text("Place Name")) {
                    Text(place.name)
                }
                Section(header: Text("Business Status")) {
                    if (place.business_status == "CLOSED_TEMPORARILY") {
                        Text("Temporarily Closed")
                    }
                    else if (place.business_status == "OPERATIONAL") {
                        Text("Open To The Public")
                    }
                    else {
                        Text("Permanently Closed")
                    }
                }
                Section(header: Text("Place Photo")) {
                    getImageFromUrl(url: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=500&photo_reference=\(place.photo_reference)&key=\(myGooglePlacesApiKey)", defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                }
                Section(header: Text("Place Rating")) {
                    HStack {
                        RatingStars(rating: place.rating)
                        Text("out of \(place.user_ratings_total) reviews")
                    }
                }
                if (place.price_level != -1) {
                    Section(header: Text("Price Level")) {
                        HStack(spacing: 0) {
                            ForEach(1...(place.price_level), id: \.self) { _ in
                                Image(systemName: "person.3.fill")
                                    .imageScale(.small)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                if (place.vicinity != "") {
                    Section(header: Text("Nearby Address")) {
                        Text(place.name)
                    }
                }
                Section(header: Text("Place Latitude and Longtitude"), footer: Text("Press and hold to copy.").italic()) {
                    Text("\(place.lat), \(place.lng)")
                                    // Long press the photo image to display the context menu
                                    .contextMenu {
                                        // Context Menu Item
                                        Button(action: {
                                            // Copy the location to universal clipboard for pasting elsewhere
                                            UIPasteboard.general.string = "\(place.lat), \(place.lng)"
                                           
                                            showAlertMessage = true
                                            alertTitle = "Latitude and Longtitude are Copied to Clipboard"
                                            alertMessage = "You can paste it on your iPhone, iPad, Mac laptop or Mac desktop each running under your Apple ID"
                                        }) {
                                            Image(systemName: "doc.on.doc")
                                            Text("Copy Latitude/Longtitude")
                                        }
                                    }
                            }
                
                Section(header: Text("Select Map Style")) {
                    Picker("Select Map Style", selection: $selectedMapStyleIndex) {
                        ForEach(0 ..< mapStyles.count, id: \.self) { index in
                            Text(mapStyles[index]).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    NavigationLink(destination: PlaceLocationOnMap(place: place, mapStyleIndex: selectedMapStyleIndex)) {
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            Text("Show Place Location on Map")
                                .font(.system(size: 16))
                        }
                        .foregroundColor(.blue)
                    }
                }
                
            }   // End of Form
            .font(.system(size: 14))
            .navigationTitle("Place Details")
            .toolbarTitleDisplayMode(.inline)
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                Button("OK") {
                    // Dismiss this view and go back to the previous view
                    dismiss()
                }
            }, message: {
                Text(alertMessage)
            })
            
        )   // End of AnyView
    }   // End of body var
    
    
    struct PlaceLocationOnMap: View {
        
        // Input Parameters
        let place: PlaceStruct
        let mapStyleIndex: Int
        
        @State private var mapCameraPosition: MapCameraPosition = .region(
            MKCoordinateRegion(
                // placeLocationCoordinate is a fileprivate var
                center: placeLocationCoordinate,
                // 1 degree = 69 miles
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
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
                    Marker(place.name, coordinate: placeLocationCoordinate)
                }
                    .mapStyle(mapStyle)
                    .navigationTitle(place.name)
                    .toolbarTitleDisplayMode(.inline)
            )
        }   // End of body var
    }
    
}
