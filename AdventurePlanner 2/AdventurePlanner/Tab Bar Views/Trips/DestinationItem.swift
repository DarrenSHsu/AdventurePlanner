//
//  DestinationItem.swift
//  AdventurePlanner
//
//  Created by Darren Hsu and Osman Balci on 4/25/24.
//  Copyright © 2024 Darren Hsu. All rights reserved.
//

import SwiftUI

struct DestinationItem: View {
    // Input Parameter
    let dest: Destination

    var body: some View {
        HStack {
            if !dest.destPhotos!.isEmpty {
                getImageFromDocumentDirectory(filename: dest.destPhotos![0].photoFullFilename.components(separatedBy: ".")[0],
                                              fileExtension: dest.destPhotos![0].photoFullFilename.components(separatedBy: ".")[1],
                                              defaultFilename: "ImageUnavailable")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100.0, height: 75.0)
            }
            else {
                // This function is given in UtilityFunctions.swift
                getImageFromUrl(url: "https://flagcdn.com/w320//\(dest.countryCode.lowercased()).png", defaultFilename: "ImageUnavailable")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100.0, height: 75.0)
            }
            VStack(alignment: .leading) {
                Text(dest.name)
                    .fixedSize(horizontal: true, vertical: false)
                if (dest.region != ""){
                    Text("\(dest.region), \(dest.countryCode)")
                        .fixedSize(horizontal: true, vertical: false)
                }
                else {
                    Text(dest.countryCode)
                        .fixedSize(horizontal: true, vertical: false)
                }
                PopulationIcons(population: Double(dest.population)/1000000)
            }
            // Set font and size for the whole VStack content
            .font(.system(size: 14))
        }
    }
}
