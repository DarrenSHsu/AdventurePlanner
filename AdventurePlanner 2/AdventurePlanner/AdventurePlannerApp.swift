//
//  AdventurePlannerApp.swift
//  AdventurePlanner
//
//  Created by Darren Hsu on 4/20/24.
//  Copyright © 2024 Darren Hsu. All rights reserved.
//

import SwiftUI
import SwiftData

@main
struct AdventurePlannerApp: App {
    init() {
        // Create the Database upon App Launch IF the app is being launched for the first time.
        createDatabase()                    // In DatabaseCreation.swift
        
        // Get latest Covid-19 Data
        getCovidData()      // In GetCovidData.swift
        
        // Create sample list of adventures in database
        initializeAdventuresList()
        
    }
    
    @AppStorage("darkMode") private var darkMode = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                // Change the color mode of the entire app to Dark or Light
                .preferredColorScheme(darkMode ? .dark : .light)
            
                // Database container will manage the Photo and Video objects
                .modelContainer(for: [Destination.self, DestPhoto.self, DestPlace.self, DestCovid.self, Note.self, Adventure.self], isUndoEnabled: true)
        }
    }
}
