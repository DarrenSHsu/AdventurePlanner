//
//  ForecastStruct.swift
//  AdventurePlanner
//
//  Created by Keming Liang on 4/15/24.
//  Copyright © 2024 Keming Liang. All rights reserved.
//

import SwiftUI

struct ForecastStruct: Hashable {
    var weatherList: [WeatherListStruct]
    var name: String
    var latitude: Double
    var longitude: Double
    var country: String
}

struct WeatherListStruct: Hashable {
    var temp_min: Double
    var temp_max: Double
    var humidity: Int
    var weather: WeatherStruct
    var dt_txt: String
}

struct WeatherStruct: Hashable {
    var description: String
    var icon: String
}

