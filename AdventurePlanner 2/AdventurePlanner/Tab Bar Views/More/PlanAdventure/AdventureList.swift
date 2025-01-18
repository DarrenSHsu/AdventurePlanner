//
//  AdventureList.swift
//  AdventurePlanner
//
//  Created by Nicholas Emig on 4/30/24.
//  Copyright © 2024 Nicholas Emig. All rights reserved.
//  Reused and modified code snippets from original creator Osman Balci
//

import SwiftUI
import SwiftData

struct AdventureList: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<Adventure>(sortBy: [SortDescriptor(\Adventure.name, order: .forward)])) private var listOfAllAdventuresInDatabase: [Adventure]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("")) {
                    NavigationLink(destination: PlanAdventure()) {
                        HStack {
                            Image(systemName: "plus.square")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            Text("Create New Adventure")
                                .font(.system(size: 16))
                        }
                        .foregroundColor(.blue)
                    }
                }
                if !listOfAllAdventuresInDatabase.isEmpty {
                    
                    Section(header: Text("Saved Adventures:")) {
                        List {
                            ForEach(listOfAllAdventuresInDatabase, id:\.self) { anAdventure in
                                NavigationLink(destination: AdventureDetails(adv: anAdventure)) {
                                    AdventureItem(adv: anAdventure)
                                }
                            } // End of ForEach
                        }
                    }
                }
            }
        }
        .navigationTitle("Adventure List")
        .toolbarTitleDisplayMode(.inline)
    }
}
