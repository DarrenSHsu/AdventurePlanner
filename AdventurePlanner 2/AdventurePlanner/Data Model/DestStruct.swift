//
//  DestStruct.swift
//  AdventurePlanner
//
//  Created by Darren Hsu on 4/26/24.
//  Copyright © 2024 Darren Hsu. All rights reserved.
//

import Foundation

struct DestStruct: Decodable, Encodable{
    
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
    
    var covid: CovidData
    
    var destPhotoStructs = [DestPhotoStruct]()
    var places = [DestPlaceStruct]()

}

struct CovidData: Decodable, Encodable, Hashable {
    var checkTime: String
    var activeCases: String
    var country: String
    var lastUpdate: String
    var newCases: String
    var newDeaths: String
    var totalCases: String
    var totalDeaths: String
    var totalRecovered: String
}

struct DestPhotoStruct: Decodable, Encodable {
    var photoFullFilename: String
    var dateTime: String
}

struct DestPlaceStruct: Decodable, Encodable {
    var business_status: String
    var location: LocationStuct
    var icon: String
    var name: String
    var photo_reference: String
    var price_level: Int
    var rating: Double
    var user_ratings_total: Int
    var vicinity: String
}

struct LocationStuct: Decodable, Encodable {
    var lat: Double
    var lng: Double
}
