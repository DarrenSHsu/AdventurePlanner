//
//  AdventureStruct.swift
//  AdventurePlanner
//
//  Created by Nicholas Emig on 4/30/24.
//  Copyright © 2024 Nicholas Emig. All rights reserved.
//

import SwiftUI
import Foundation

struct AdventureStruct: Decodable, Encodable {
    var name: String
    var id: Int
    
    var adventureInfo = [AdventureInfo]()
}

struct AdventureInfo: Decodable, Encodable, Identifiable {
    var id = 0
    var destinations = [AdvDestStruct]()
    var places = [AdvPlaceStruct]()
}

struct AdvDestStruct: Decodable, Encodable {
    var id: Int
    var wikiDataId: String
    var city: String
    var name: String
    var country: String
    var countryCode: String
    var region: String
    var regionCode: String
    var latitude: Double
    var longitude: Double
    var population: Int
}

struct AdvPlaceStruct: Decodable, Encodable, Hashable {
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

