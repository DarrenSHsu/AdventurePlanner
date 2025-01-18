//
//  DBSearchResultsList.swift
//  AdventurePlanner
//
//  Created by Nicholas Luke Emig on 4/26/24.
//  Copyright © 2024 Nicholas Emig All rights reserved.
//

import SwiftUI

struct DBSearchResultsList: View {
    var body: some View {
        List {
            ForEach(databaseSearchResults) { aDestination in
                NavigationLink(destination: DestinationDetails(dest: aDestination)) {
                    DestinationItem(dest: aDestination)
                }
            }
        }
        .navigationTitle("Database Search Results")
        .toolbarTitleDisplayMode(.inline)

    }
}
