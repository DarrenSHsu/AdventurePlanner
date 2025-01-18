//
//  AdventureDetails.swift
//  AdventurePlanner
//
//  Created by Nicholas Emig on 4/30/24.
//  Copyright © 2024 Nicholas Emig. All rights reserved.
//

import SwiftUI

struct AdventureDetails: View {
    
    let adv: Adventure
    
    @State private var end = false
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Section(header: Text("Adventure Title:")) {
                Text(adv.name)
            }
            
            ForEach(adv.info!) { anInfo in
                if anInfo.id != 0 {
                    HStack {
                        Spacer()
                        Image(systemName: "arrowshape.down")
                            .foregroundColor(.blue)
                            .imageScale(.large)
                        Spacer()
                    }
                }
                Section() {
                    Section(header: Text("Destination #\(anInfo.id+1):")) {
                        HStack {
                            getImageFromUrl(url: "https://flagcdn.com/w320//\(anInfo.destinations[0].countryCode.lowercased()).png", defaultFilename: "ImageUnavailable")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100.0, height: 75.0)
                            
                            VStack(alignment: .leading) {
                                Text(anInfo.destinations[0].name)
                                    .fixedSize(horizontal: true, vertical: false)
                                if (anInfo.destinations[0].region != ""){
                                    Text("\(anInfo.destinations[0].region), \(anInfo.destinations[0].countryCode)")
                                        .fixedSize(horizontal: true, vertical: false)
                                }
                                else {
                                    Text(anInfo.destinations[0].countryCode)
                                        .fixedSize(horizontal: true, vertical: false)
                                }
                            }
                            .font(.system(size: 14))
                        }
                        if !anInfo.places.isEmpty {
                            Text("Places:")
                            ForEach(anInfo.places, id:\.self) { aPlace in
                                HStack {
                                    getImageFromUrl(url: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=500&photo_reference=\(aPlace.photo_reference)&key=\(myGooglePlacesApiKey)", defaultFilename: "ImageUnavailable")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80.0)
                                    
                                    VStack(alignment: .leading) {
                                        if (aPlace.name.count > 20) {
                                            Text(aPlace.name.dropLast(aPlace.name.count - 20) + "...")
                                                .fixedSize(horizontal: true, vertical: true)
                                        }
                                        else {
                                            Text("\(aPlace.name)")
                                                .fixedSize(horizontal: true, vertical: true)
                                        }
                                        Text("\(aPlace.vicinity)")
                                            .fixedSize(horizontal: true, vertical: false)
                                    }
                                    .font(.system(size: 14))
                                }
                            }
                        }
                    }
                }
            } // End of ForEach
            
            Section(header: Text("")) {
                HStack{
                    Spacer()
                    Button("Delete") {
                        modelContext.delete(adv)
                        dismiss()
                    }
                    Spacer()
                }
            }
            .font(.system(size: 14))
            .navigationTitle("\(adv.name) details")
            .toolbarTitleDisplayMode(.inline)
        }
    }
}
