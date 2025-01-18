//
//  ChoosePlacesList.swift
//  AdventurePlanner
//
//  Created by Nicholas Emig on 4/30/24.
//  Copyright © 2024 Nicholas Emig. All rights reserved.
//

import SwiftUI

struct ChoosePlacesList: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let dest: Destination
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(dest.destPlaces!) { aPlace in
                    PlaceItem(place: aPlace)
                        .onTapGesture {
                            currPlaces.append(aPlace)
                            dismiss()
                        }
                }
            }
        }
    }
}

