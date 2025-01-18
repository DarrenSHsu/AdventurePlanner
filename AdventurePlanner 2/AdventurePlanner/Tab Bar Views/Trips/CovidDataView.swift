//
//  CovidDataView.swift
//  AdventurePlanner
//
//  Created by Darren Hsu on 4/25/24.
//  Copyright © 2024 Darren Hsu. All rights reserved.
//

import SwiftUI

struct CovidDataView: View {
    let covid: DestCovid
    
    var body: some View {
        Section(header: Text("Covid Information")) {
            if (covid.checkTime == "") {
                Text("Please click the update button above to initialize Covid Information")
            }
            else {
                HStack {
                    Text("Last Refresh Date:")
                        .font(Font.subheadline.weight(.regular))
                        Spacer()
                    Text(covid.checkTime)
                }
                HStack {
                    Image(systemName: "calendar")
                        .imageScale(.small)
                        .font(Font.title.weight(.thin))
                    Text("Last Poll Date:")
                        .font(Font.subheadline.weight(.regular))
                    Spacer()
                    Text(covid.lastUpdate.replacingOccurrences(of: " ", with: " at "))

                }
                HStack {
                    Image(systemName: "person.wave.2.fill")
                        .imageScale(.small)
                        .font(Font.title.weight(.thin))
                    Text("Active Cases:")
                        .font(Font.subheadline.weight(.regular))
                    Spacer()
                    Text(covid.activeCases)

                }
                HStack {
                    Image(systemName: "person.fill.badge.plus")
                        .imageScale(.small)
                        .font(Font.title.weight(.thin))
                    Text("Change in Case Count:")
                        .font(Font.subheadline.weight(.regular))
                    Spacer()
                    Text(covid.newCases)

                }
                HStack {
                    Image(systemName: "person.badge.plus")
                        .imageScale(.small)
                        .font(Font.title.weight(.thin))
                    Text("Change in Death Count:")
                        .font(Font.subheadline.weight(.regular))
                    Spacer()
                    Text(covid.newDeaths)

                }
                HStack {
                    Image(systemName: "person.3.sequence.fill")
                        .imageScale(.small)
                        .font(Font.title.weight(.thin))
                    Text("Total Case Count:")
                        .font(Font.subheadline.weight(.regular))
                    Spacer()
                    Text(covid.totalCases)

                }
                HStack {
                    Image(systemName: "person.2.slash")
                        .imageScale(.small)
                        .font(Font.title.weight(.thin))
                    Text("Total Death Count:")
                        .font(Font.subheadline.weight(.regular))
                    Spacer()
                    Text(covid.totalDeaths)

                }
                HStack {
                    Image(systemName: "figure.walk")
                        .imageScale(.small)
                        .font(Font.title.weight(.thin))
                    Text("Total Recovered Count:")
                        .font(Font.subheadline.weight(.regular))
                    Spacer()
                    Text(covid.totalRecovered)

                }
            }
        }
    }
}

