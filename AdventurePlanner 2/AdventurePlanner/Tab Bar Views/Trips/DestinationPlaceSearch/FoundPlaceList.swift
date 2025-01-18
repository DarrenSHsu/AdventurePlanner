//
//  FoundPlaceList.swift
//  AdventurePlanner
//
//  Created by Darren Hsu on 4/26/24.
//  Copyright © 2024 Darren Hsu. All rights reserved.
//

import SwiftUI

struct FoundPlaceList: View {
    let dest: Destination
    let searchArray: [String]
    var body: some View {
        List {
            ForEach(2...(searchArray.count - 1), id: \.self) { i in
                Section(header: Text("Search Option")) {
                    Text(searchArray[i])
                    ForEach(placesList[i - 2], id: \.self) { aPlace in
                        NavigationLink(destination: FoundPlaceDetails(place: aPlace, dest: dest)) {
                            FoundPlaceItem(place: aPlace)
                        }
                    }
                }
            }
        }
        .navigationTitle("Search Results")
        .toolbarTitleDisplayMode(.inline)
    }
}
