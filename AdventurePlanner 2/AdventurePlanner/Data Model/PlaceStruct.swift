//
//  PlaceStruct.swift
//  AdventurePlanner
//
//  Created by Darren Hsu on 4/26/24.
//  Copyright © 2024 Darren Hsu. All rights reserved.
//

import Foundation

//-----------------------------------------------------------
// PlaceStruct is used only for the API search results
//-----------------------------------------------------------

struct PlaceStruct: Hashable {

    var business_status: String
    var lat: Double
    var lng: Double
    var icon: String
    var name: String
    var photo_reference: String
    var price_level: Int
    var rating: Double
    var user_ratings_total: Int
    var vicinity: String
}
