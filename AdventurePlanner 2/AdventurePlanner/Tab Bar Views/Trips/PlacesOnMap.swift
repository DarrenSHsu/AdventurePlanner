//
//  PlacesOnMap.swift
//  AdventurePlanner
//
//  Created by Nicholas Luke Emig on 4/30/24.
//  Copyright © 2024 Nicholas Emig. All rights reserved.
//  Reused and modified code snippets from original creator Osman Balci
//

import SwiftUI
import SwiftData
import CoreLocation
import MapKit

fileprivate var destLocationCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)

struct PlaceDestination: Identifiable {
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
    var place: DestPlace
}

struct PlacesOnMap: View {
    let dest: Destination
    
    @State private var mapPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            // Placeholder, location gets updated to Trip location using onAppear
            center: CLLocationCoordinate2D(
                latitude: 0.0,
                longitude: 0.0
            ),
            // Delta is in degrees. 1 degree = 69 miles (111 kilometers)
            span: MKCoordinateSpan(
                latitudeDelta: 50,
                longitudeDelta: 50
            )
        )
    )

    var body: some View {
        var changedLocation = false
        NavigationStack{
            placeAnnotations
                .navigationTitle("Places on Map")
                .toolbarTitleDisplayMode(.inline)
        }
        .onAppear(perform: {
            if !changedLocation {
                mapPosition = .region(
                        MKCoordinateRegion(
                            // Sets the Trip as the center point of the map
                            center: CLLocationCoordinate2D(
                                latitude: dest.latitude,
                                longitude: dest.longitude
                            ),
                            // Delta is in degrees. 1 degree = 69 miles (111 kilometers)
                            span: MKCoordinateSpan(
                                latitudeDelta: 0.5,
                                longitudeDelta: 0.5
                            )
                        )
                    )
                changedLocation = true
            }
        })
    }
    
    var placeAnnotations: some View {
        
        // Initialize the list of PlaceDestination annotations
        var annotations = [PlaceDestination]()
        
        // Build the list of PlaceDestination annotations
        for aPlace in dest.destPlaces! {
            annotations.append(PlaceDestination(coordinate: CLLocationCoordinate2D(latitude: aPlace.lat, longitude: aPlace.lng), place: aPlace))
        }
        
        // Return the map showing the list of PlaceDestination annotations
        return AnyView(
            Map(position: $mapPosition) {
                Annotation(dest.name, coordinate: CLLocationCoordinate2D(latitude: dest.latitude, longitude: dest.longitude))
                {
                    VStack(spacing: 0) {
                        Image(systemName: "mappin.and.ellipse.circle.fill")
                        Text(dest.name)
                            .font(.system(size: 10))
                            .fixedSize(horizontal: true, vertical: false)                    }
                }
                ForEach(annotations) { aPlace in
                    Annotation(aPlace.place.name, coordinate: aPlace.coordinate) {
                        PlaceAnnotationView(place: aPlace.place)
                    }
                }
            }
            .mapStyle(.standard)
        )
    }
}

/*
 ============================
 MARK: Custom Annotation View
 ============================
 */
struct PlaceAnnotationView: View {
    
    // Input variables
    let place: DestPlace
    
    @State private var showPlaceTitle = false
    var body: some View {
        VStack(spacing: 0) {
            if showPlaceTitle {
                NavigationLink(destination: PlaceDetails(place: place)) {
                    Text(place.name)
                        .font(.caption)
                        .padding(5)
                        .background(Color.white)
                        .foregroundColor(Color.blue)
                        .cornerRadius(10)
                        // Prevent title truncation
                        .fixedSize(horizontal: true, vertical: false)
                }
            }
            Image(systemName: "mappin")
                .imageScale(.large)
                .font(Font.title.weight(.regular))
                .foregroundColor(.red)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        showPlaceTitle.toggle()
                    }
                }
        }
    }
}
