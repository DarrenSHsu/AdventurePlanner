//
//  ChooseDestinationList.swift
//  AdventurePlanner
//
//  Created by Nicholas Emig on 4/30/24.
//  Copyright © 2024 Nicholas Emig. All rights reserved.
//

import SwiftUI
import SwiftData

struct ChooseDestinationList: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<Destination>(sortBy: [SortDescriptor(\Destination.name, order: .forward)])) private var listOfAllDestinationsInDatabase: [Destination]
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(listOfAllDestinationsInDatabase) { aDest in
                    HStack {
                        DestinationItem(dest: aDest)
                            .onTapGesture {
                                currDest.append(aDest)
                                dismiss()
                            }
                    }
                }
            }
            .font(.system(size: 14))
            .navigationTitle("Choose a Destination")
            .toolbarTitleDisplayMode(.inline)
        }
    }
}
