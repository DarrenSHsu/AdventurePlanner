//
//  FoundCityItem.swift
//  AdventurePlanner
//
//  Created by Darren Hsu on 4/27/24.
//  Copyright © 2024 Darren Hsu. All rights reserved.
//

import SwiftUI

struct FoundCityItem: View {
    // Input Parameter
    let city: CityStruct
    
    var body: some View {
        HStack {
            getImageFromUrl(url: "https://flagcdn.com/w320/\(city.countryCode.lowercased()).png", defaultFilename: "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
            
            VStack(alignment: .leading) {
                Text("\(city.name)")
                    .fixedSize(horizontal: true, vertical: false)
                if (city.region != ""){
                    Text("\(city.region), \(city.countryCode)")
                        .fixedSize(horizontal: true, vertical: false)
                }
                else {
                    Text("\(city.countryCode)")
                        .fixedSize(horizontal: true, vertical: false)
                }
                PopulationIcons(population: Double(city.population)/1000000)
            }
            .font(.system(size: 14))
        }
    }
}
