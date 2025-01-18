//
//  More.swift
//  AdventurePlanner
//
//  Created by Darren Hsu on 4/24/24.
//  Copyright © 2024 Darren Hsu. All rights reserved.
//

import SwiftUI

struct More: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: AdventureList()) {
                    HStack {
                        Image(systemName: "airplane.circle")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                            .foregroundColor(.blue)
                            .frame(width: 40)
                        Text("Adventures")
                            .font(.system(size: 16))
                    }
                }
                NavigationLink(destination: TripGrid()) {
                    HStack {
                        Image(systemName: "square.grid.3x3")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                            .foregroundColor(.blue)
                            .frame(width: 40)
                        Text("Trip Photo Grid")
                            .font(.system(size: 16))
                    }
                }
                NavigationLink(destination: TripsOnMap()) {
                    HStack {
                        Image(systemName: "map.circle")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                            .foregroundColor(.blue)
                            .frame(width: 40)
                        Text("Map of All Trips")
                            .font(.system(size: 16))
                    }
                }
                NavigationLink(destination: GetWeatherForecast()) {
                    HStack {
                        Image(systemName: "cloud.sun.rain")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                            .foregroundColor(.blue)
                            .frame(width: 40)
                        Text("Get Weather Forecast")
                            .font(.system(size: 16))
                    }
                }
                NavigationLink(destination: SearchTrips()) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                            .foregroundColor(.blue)
                            .frame(width: 40)
                        Text("Search Trips Database")
                            .font(.system(size: 16))
                    }
                }
                NavigationLink(destination: About()) {
                    HStack {
                        Image(systemName: "info.circle")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                            .foregroundColor(.blue)
                            .frame(width: 40)
                        Text("About")
                            .font(.system(size: 16))
                    }
                }
                NavigationLink(destination: SettingsList()) {
                    HStack {
                        Image(systemName: "gear")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                            .foregroundColor(.blue)
                            .frame(width: 40)
                        Text("Settings")
                            .font(.system(size: 16))
                    }
                }
            }   // End of List
            .navigationTitle("More")
            .toolbarTitleDisplayMode(.inline)
            
        }   // End of NavigationStack
    }   // End of body var
}
    

