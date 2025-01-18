//
//  ForecastResultItem.swift
//  AdventurePlanner
//
//  Created by Keming Liang on 4/26/24.
//  Copyright © 2024 Keming Liang. All rights reserved.
//

import SwiftUI

struct ForecastResultItem: View {
    let forecast: WeatherListStruct
    
    var body: some View {
        HStack {
            getImageFromUrl(url: "https://openweathermap.org/img/wn/\(forecast.weather.icon)@2x.png", defaultFilename: "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80)
            
            VStack(alignment: .leading) {
                Text(forecast.dt_txt)
                Text(forecast.weather.description)
                Text("Humidity: \(forecast.humidity)%")
            }
            .font(.system(size: 14))
        }
    }
}
