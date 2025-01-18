//
//  DestinationPhotoList.swift
//  AdventurePlanner
//
//  Created by Darren Hsu on 4/25/24.
//  Copyright © 2024 Darren Hsu. All rights reserved.
//

import SwiftUI
import SwiftData

struct DestinationPhotoList: View {
    // Input Parameter
    let dest: Destination
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var toBeDeleted: IndexSet?
    @State private var showConfirmation = false
    
    var body: some View {
        VStack {
            Text("\(dest.city), \(dest.region), \(dest.countryCode)")
                .font(.headline)
            List {
                // List dest photos sorted w.r.t. dateTime attribute
                ForEach(dest.destPhotos!.sorted(by: { $0.dateTime < $1.dateTime })) { aPhoto in
                    VStack {
                        getImageFromDocumentDirectory(filename: aPhoto.photoFullFilename.components(separatedBy: ".")[0],
                                                      fileExtension: aPhoto.photoFullFilename.components(separatedBy: ".")[1],
                                                      defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                        
                        Text(aPhoto.dateTime)
                            .font(.subheadline)
                    }
                    .alert(isPresented: $showConfirmation) {
                        Alert(title: Text("Delete Confirmation"),
                              message: Text("Are you sure to permanently delete the photo? It cannot be undone."),
                              primaryButton: .destructive(Text("Delete")) {
                            /*
                             'toBeDeleted (IndexSet).first' is an unsafe pointer to the index number of the array
                             element to be deleted. It is nil if the array is empty. Process it as an optional.
                             */
                            if let index = toBeDeleted?.first {
                                
                                let destPhotoToDelete = dest.destPhotos![index]
                                
                                // ❎ Delete selected destPhotoToDelete object from the database
                                modelContext.delete(destPhotoToDelete)
                                
                                // Delete it from the list of destPhotos
                                dest.destPhotos!.remove(at: index)
                                
                                // Delete the photo file in document directory
                                do {
                                    let urlOfFileToDelete = documentDirectory.appendingPathComponent(destPhotoToDelete.photoFullFilename)
                                    try FileManager.default.removeItem(at: urlOfFileToDelete)
                                } catch {
                                    print("Unable to delete photo file in document directory")
                                }
                            }
                            toBeDeleted = nil
                            
                        }, secondaryButton: .cancel() {
                            toBeDeleted = nil
                        }
                        )   // End of Alert
                    }   // End of .alert
                }   // End of ForEach
                .onDelete(perform: delete)
                
            }   // End of List
            .font(.system(size: 14))
            .navigationTitle("Trip Photos")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                // Place the Edit button on left side of the toolbar
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                // Place the Add button on right side of the toolbar
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: AddDestinationPhoto(dest: dest)) {
                        Image(systemName: "photo.badge.plus")
                    }
                }
            }   // End of toolbar
            
        }   // End of VStack
    }   // End of body var
    
    
    func delete(at offsets: IndexSet) {
        
         toBeDeleted = offsets
         showConfirmation = true
     }

}


