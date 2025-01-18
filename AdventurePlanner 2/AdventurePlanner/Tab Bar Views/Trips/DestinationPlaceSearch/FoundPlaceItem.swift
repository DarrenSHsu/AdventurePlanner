//
//  FoundPlaceItem.swift
//  AdventurePlanner
//
//  Created by Darren Hsu on 4/26/24.
//  Copyright © 2024 Darren Hsu. All rights reserved.
//

import SwiftUI

struct FoundPlaceItem: View {
    // Input Parameter
    let place: PlaceStruct
    
    var body: some View {
        HStack {
            getImageFromUrl(url: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=500&photo_reference=\(place.photo_reference)&key=\(myGooglePlacesApiKey)", defaultFilename: "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0)
            
            VStack(alignment: .leading) {
                Text(place.name)
                RatingStars(rating: place.rating)
                Text("\(place.user_ratings_total) Reviews")
            }
                // Set font and size for the whole VStack content
                .font(.system(size: 14))
        }
    }
}
