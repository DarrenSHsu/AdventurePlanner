//
//  CovidItem.swift
//  AdventurePlanner
//
//  Created by Darren Hsu on 4/27/24.
//  Copyright © 2024 Darren Hsu. All rights reserved.
//

import SwiftUI

struct CovidItem: View {
    // Input Parameter
    let aCovidData: CovidData
    
    var body: some View {
        HStack {
            if (aCovidData.totalCases != "" && aCovidData.totalCases != "N/A") {
                //Determine what color the country is depending on number of cases
                if (Int(aCovidData.totalCases.replacingOccurrences(of: ",", with: ""))! > 30000000) {
                    Image("redColor")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80.0)
                }
                else if (Int(aCovidData.totalCases.replacingOccurrences(of: ",", with: ""))! > 10000000) {
                    Image("yellowColor")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80.0)
                }
                else {
                    Image("greenColor")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80.0)
                }
            }
            else {
                getImageFromDocumentDirectory(filename: "redColor",
                                              fileExtension: "png",
                                              defaultFilename: "ImageUnavailable")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80.0)
            }
            VStack(alignment: .leading) {
                Text(aCovidData.country)
                Text(aCovidData.lastUpdate)
                if (aCovidData.newCases != "" && aCovidData.newCases != "N/A") {
                    HStack {
                        Image(systemName: "person.fill.badge.plus")
                            .imageScale(.small)
                            .font(Font.title.weight(.thin))
                        Text("Change in Case Count:")
                            .font(Font.subheadline.weight(.regular))
                        Spacer()
                        Text(aCovidData.newCases)

                    }
                }
                else if (aCovidData.activeCases != "" && aCovidData.activeCases != "N/A") {
                    HStack {
                        Image(systemName: "person.wave.2.fill")
                            .imageScale(.small)
                            .font(Font.title.weight(.thin))
                        Text("Active Cases:")
                            .font(Font.subheadline.weight(.regular))
                        Spacer()
                        Text(aCovidData.activeCases)

                    }
                }
                else {
                    HStack {
                        Image(systemName: "person.3.sequence.fill")
                            .imageScale(.small)
                            .font(Font.title.weight(.thin))
                        Text("Total Cases:")
                            .font(Font.subheadline.weight(.regular))
                        Spacer()
                        Text(aCovidData.totalCases)

                    }
                }
            }
                // Set font and size for the whole VStack content
                .font(.system(size: 14))
        }
    }
}
