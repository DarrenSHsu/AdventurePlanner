//
//  TripsOnMap.swift
//  AdventurePlanner
//
//  Created by Nicholas Luke Emig on 4/29/24.
//  Copyright © 2024 Nicholas Emig. All rights reserved.
//  Reused and modified code snippets from original creator Osman Balci
//

import SwiftUI
import SwiftData
import CoreLocation
import MapKit

struct MapDestination: Identifiable {
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
    var dest: Destination
}
    
struct TripsOnMap: View {
    @Query(FetchDescriptor<Destination>(sortBy: [SortDescriptor(\Destination.name, order: .forward)])) private var listOfDestinationsInDatabase: [Destination]
    @State private var mapPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            // Blacksburg, Virignia is the center point of the map
            center: CLLocationCoordinate2D(
                latitude: 37.2296,
                longitude: -80.4139
            ),
            // Delta is in degrees. 1 degree = 69 miles (111 kilometers)
            span: MKCoordinateSpan(
                latitudeDelta: 100,
                longitudeDelta: 100
            )
        )
    )
    var body: some View {
        NavigationStack{
            destAnnotations
                .navigationTitle("Destinations on Map")
                .toolbarTitleDisplayMode(.inline)
        }
    }
    var destAnnotations: some View {

        // Initialize the list of MapDestination annotations
        var annotations = [MapDestination]()
        
        // Build the list of MapDestination annotations
        for aDest in listOfDestinationsInDatabase {
            annotations.append(MapDestination(coordinate: CLLocationCoordinate2D(latitude: aDest.latitude, longitude: aDest.longitude), dest: aDest))
        }
        
        // Return the map showing the list of MapDestination annotations
        return AnyView(
            Map(position: $mapPosition) {
                ForEach(annotations) { aDest in
                    Annotation(aDest.dest.name, coordinate: aDest.coordinate) {
                        AnnotationView(dest: aDest.dest)
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
struct AnnotationView: View {
    
    // Input variables
    let dest: Destination
    
    @State private var showDestinationTitle = false
    var body: some View {
        VStack(spacing: 0) {
            if showDestinationTitle {
                NavigationLink(destination: DestinationDetails(dest: dest)) {
                    Text(dest.name)
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
                        showDestinationTitle.toggle()
                    }
                }
        }
    }
}
