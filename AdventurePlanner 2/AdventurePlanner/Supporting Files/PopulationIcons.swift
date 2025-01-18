//
//  PopulationIcons.swift
//  AdventurePlanner
//
//  Created by Darren Hsu on 4/25/24.
//  Copyright © 2024 Darren Hsu. All rights reserved.
//

import SwiftUI

struct PopulationIcons: View {
    // Input Parameter
    let population: Double
   
    var body: some View {
        HStack(spacing: 0) {
            //Add a 3 Person icon for every 3 million people
            if (Int(population) / 3 >= 1) {
                ForEach(0...(Int(population) / 3 - 1), id: \.self) { _ in
                    Image(systemName: "person.3.fill")
                        .imageScale(.small)
                        .foregroundColor(.gray)
                }
            }
            //Add a full person for every million people after all sets of 3 are taken out
            if (Int(population) % 3 >= 1) {
                ForEach(0...(Int(population) % 3) - 1, id: \.self) { _ in
                    Image(systemName: "person.fill")
                        .imageScale(.small)
                        .foregroundColor(.gray)
                }
            }
            //Add a hollow person if there is greater than half a million people remaining
            if (population - Double(Int(population)) >= 0.5) {
                Image(systemName: "person")
                    .imageScale(.small)
                    .foregroundColor(.gray)
            }
            //If not, add a person in a circle
            else
            {
                Image(systemName: "person.crop.circle")
                    .imageScale(.small)
                    .foregroundColor(.gray)
            }
        }
    }
}
