//
//  RatingStars.swift
//  AdventurePlanner
//
//  Created by Osman Balci on 3/25/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//
 
import SwiftUI
 
struct RatingStars: View {
   
    // Input Parameter
    let rating: Double
   
    var body: some View {
        if rating >= 1.0 && rating <= 5.0  {
            return AnyView(
                HStack(spacing: 0) {
                    ForEach(1...Int(rating), id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .imageScale(.small)
                            .foregroundColor(.gray)
                    }
                    if rating > Double(Int(rating)) {
                        Image(systemName: "star.leadinghalf.filled")
                            .imageScale(.small)
                            .foregroundColor(.gray)
                    }
                }
            )
        } else {
            return AnyView(
                Text("Rating value must be between 1.0 and 5.0")
            )
        }
    }
}
