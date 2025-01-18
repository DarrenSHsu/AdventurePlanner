//
//  DestinationList.swift
//  AdventurePlanner
//
//  Created by Darren Hsu and Osman Balci on 4/24/24.
//  Copyright © 2024 Darren Hsu. All rights reserved.
//

import SwiftUI
import SwiftData

struct DestinationList: View {
    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<Destination>(sortBy: [SortDescriptor(\Destination.name, order: .forward)])) private var listOfAllDestsInDatabase: [Destination]
    
    @State private var toBeDeleted: IndexSet?
    @State private var showConfirmation = false
    @State private var showAlertMessage = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(listOfAllDestsInDatabase) { aDest in
                    NavigationLink(destination: DestinationDetails(dest: aDest)) {
                        DestinationItem(dest: aDest)
                            .alert(isPresented: $showConfirmation) {
                                Alert(title: Text("Delete Confirmation"),
                                      message: Text("Are you sure to permanently delete the Destination? It cannot be undone."),
                                      primaryButton: .destructive(Text("Delete")) {
                                    /*
                                    'toBeDeleted (IndexSet).first' is an unsafe pointer to the index number of the array
                                     element to be deleted. It is nil if the array is empty. Process it as an optional.
                                    */
                                    if let index = toBeDeleted?.first {
                                        let destToDelete = listOfAllDestsInDatabase[index]
                                        
                                        // ❎ Delete selected Trip object from the database
                                        modelContext.delete(destToDelete)
                                    }
                                    toBeDeleted = nil
                                }, secondaryButton: .cancel() {
                                    toBeDeleted = nil
                                }
                            )
                        }   // End of alert
                    }
                }
                .onDelete(perform: delete)
                
            }   // End of List
            .font(.system(size: 14))
            .navigationTitle("List of Trips")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                // Place the Edit button on left side of the toolbar
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showAlertMessage = true
                        alertTitle = "Add New Destination"
                        alertMessage = "Please navigate to the City Search tab to add new destination."
                    }) {
                        Image(systemName: "plus")
                            .imageScale(.small)
                            .font(Font.title.weight(.light))
                    }
                }
            }   // End of toolbar
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                  Button("OK") {}
                }, message: {
                  Text(alertMessage)
                })
            
        }   // End of NavigationStack
    }   // End of body var
    
    /*
     --------------------------------
     MARK: Delete Selected Trip
     --------------------------------
     */
    func delete(at offsets: IndexSet) {
        
         toBeDeleted = offsets
         showConfirmation = true
     }
    
}
