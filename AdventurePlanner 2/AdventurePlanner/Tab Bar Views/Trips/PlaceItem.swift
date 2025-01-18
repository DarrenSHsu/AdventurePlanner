//
//  PlaceItem.swift
//  AdventurePlanner
//
//  Created by Darren Hsu on 4/26/24.
//  Copyright © 2024 Darren Hsu. All rights reserved.
//

import SwiftUI

struct PlaceItem: View {
    let place: DestPlace
    
    var body: some View {
        HStack {
            getImageFromUrl(url: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=500&photo_reference=\(place.photo_reference)&key=\(myGooglePlacesApiKey)", defaultFilename: "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0)
            
            
            VStack(alignment: .leading) {
                HStack {
                    getImageFromUrl(url: place.icon, defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16)
                    if (place.name.count > 20) {
                        Text("Name: " + place.name.dropLast(place.name.count - 20) + "...")
                            .fixedSize(horizontal: true, vertical: true)
                    }
                    else {
                        Text("Name: " + place.name)
                            .fixedSize(horizontal: true, vertical: true)
                    }
                }
                HStack {
                    RatingStars(rating: place.rating)
                    Text("with \(place.user_ratings_total) reviews")
                        .fixedSize(horizontal: true, vertical: false)
                }
                Text("\(place.vicinity)")
                    .fixedSize(horizontal: true, vertical: false)
            }
            .font(.system(size: 14))
        }
    }
}
