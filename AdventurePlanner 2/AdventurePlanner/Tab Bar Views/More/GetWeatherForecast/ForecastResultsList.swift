//
//  ForecastResultsList.swift
//  AdventurePlanner
//
//  Created by Keming Liang on 4/26/24.
//  Copyright © 2024 Keming Liang. All rights reserved.
//

import SwiftUI

struct ForecastResultsList: View {
    var body: some View {
        Text("Weather Forecast Every 3 Hours")
            .font(.custom("Times New Roman Bold Italic", size: 18))
            .padding(15)
        List {
            ForEach(newForecastList, id:\.dt_txt) { aForecast in
                NavigationLink(destination: ForecastResultDetails(forecast: aForecast)) {
                    ForecastResultItem(forecast: aForecast)
                }
            }
        }
        .font(.system(size: 14))
        .navigationTitle("\(weatherItem.name), \(weatherItem.country)")
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    ForecastResultsList()
}
