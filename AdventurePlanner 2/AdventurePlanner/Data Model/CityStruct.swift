//
//  CityStruct.swift
//  AdventurePlanner
//
//  Created by Darren Hsu on 4/27/24.
//  Copyright © 2024 Darren Hsu. All rights reserved.
//

import Foundation

//-----------------------------------------------------------
// CityStruct is used only for the API search results
//-----------------------------------------------------------

struct CityStruct: Hashable {

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
    var next: String
    
}

/*
 "id": 2983191,
 "wikiDataId": "Q18094",
 "city": "Honolulu",
 "name": "Honolulu",
 "country": "United States of America",
 "countryCode": "US",
 "region": "Hawaii",
 "regionCode": "HI",
 "latitude": 21.304694444,
 "longitude": -157.857194444,
 "population": 350964,
 */
