//
//  FoundCitiesList.swift
//  AdventurePlanner
//
//  Created by Darren Hsu on 4/27/24.
//  Copyright © 2024 Darren Hsu. All rights reserved.
//

import SwiftUI

struct FoundCitiesList: View {
    
    @State private var searchCompleted = false
    @State private var showAlertMessage = false
    @State var thisCitiesList = citiesList
    
    var body: some View {
        List {
            ForEach(thisCitiesList, id: \.self) { aCity in
                NavigationLink(destination: FoundCityDetails(city: aCity)) {
                    FoundCityItem(city: aCity)
                }
            }
            Section(header: Text("Load More")) {
                HStack {
                    Spacer()
                    Button("Load More") {
                        if citiesList[citiesList.count - 1].next != "" {
                            searchCompleted = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                /*
                                 Execute the following code after 0.1 second of delay
                                 so that they are not executed during the view update.
                                 */
                                searchCityApi(apiUrl: citiesList[citiesList.count - 1].next)
                                searchCompleted = false
                                thisCitiesList = citiesList
                            }
                        } else {
                            showAlertMessage = true
                            alertTitle = "No More Cities"
                            alertMessage = "Please enter a new search query!"
                        }
                    }
                    .tint(.blue)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    
                    Spacer()
                }   // End of HStack
            }
            
        }
        .navigationTitle("Geo Cities API Search Results")
        .toolbarTitleDisplayMode(.inline)
        .alert(alertTitle, isPresented: $showAlertMessage, actions: {
            Button("OK") {}
        }, message: {
            Text(alertMessage)
        })
    }
}


