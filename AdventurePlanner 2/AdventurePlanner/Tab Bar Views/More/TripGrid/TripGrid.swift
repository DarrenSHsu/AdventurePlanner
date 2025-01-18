//
//  TripGrid.swift
//  AdventurePlanner
//
//  Created by Keming liang and Osman Balci on 4/28/24.
//  Copyright © 2024 Keming Liang and Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData

struct TripGrid: View {
    
    @State private var showAlertMessage = false
    @Query(FetchDescriptor<Destination>(sortBy: [SortDescriptor(\Destination.name, order: .forward)])) private var listOfAllDestsInDatabase: [Destination]
    
    let columns = [ GridItem(.adaptive(minimum: 100), spacing: 3) ]
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Tap trip photo to get its information.")
                    .font(.system(size: 18, weight: .light, design: .serif))
                    .italic()
                    .multilineTextAlignment(.center)
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 3) {
                        ForEach(listOfAllDestsInDatabase) { aDest in
                            ForEach(aDest.destPhotos!.sorted(by: { $0.dateTime < $1.dateTime })) { aPhoto in
                                VStack {
                                    getImageFromDocumentDirectory(filename: aPhoto.photoFullFilename.components(separatedBy: ".")[0],
                                                                  fileExtension: aPhoto.photoFullFilename.components(separatedBy: ".")[1],
                                                                  defaultFilename: "ImageUnavailable")
                                    .resizable()
                                    .scaledToFit()
                                    .onTapGesture {
                                        alertTitle = "\(aDest.name), \(aDest.countryCode)"
                                        alertMessage = "There are about \(aDest.population) people in this city, and the total number of covid cases as of \(aDest.covidData!.lastUpdate) is \(aDest.covidData!.totalCases)."
                                        showAlertMessage = true
                                    }
                                    .overlay(
                                        PopulationView(population: Double(aDest.population)/1000000)
                                    )
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Trip Photo Grid")
            .toolbarTitleDisplayMode(.inline)
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                Button("OK") {}
            }, message: {
                Text(alertMessage)
            })
        }
    }
}
//Create a number of people based on population
struct PopulationView: View {
    //Input variable
    let population: Double
    
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 0) {
                if (Int(population) / 3 >= 1) {
                    ForEach(0...(Int(population) / 3 - 1), id: \.self) { _ in
                        Image(systemName: "person.3.fill")
                            .font(.system(size: 10, weight: .regular))
                            .foregroundColor(.yellow)
                            .background(Color.white)
                    }
                }
                if (Int(population) % 3 >= 1) {
                    ForEach(0...(Int(population) % 3) - 1, id: \.self) { _ in
                        Image(systemName: "person.fill")
                            .font(.system(size: 10, weight: .regular))
                            .foregroundColor(.yellow)
                            .background(Color.white)
                    }
                }
                if (population - Double(Int(population)) >= 0.5) {
                    Image(systemName: "person")
                        .font(.system(size: 10, weight: .regular))
                        .foregroundColor(.yellow)
                        .background(Color.white)
                }
                else
                {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 10, weight: .regular))
                        .foregroundColor(.yellow)
                        .background(Color.white)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    TripGrid()
}
