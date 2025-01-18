//
//  DatabaseSearch.swift
//  AdventurePlanner
//
//  Created by Nicholas Luke Emig on 4/26/24.
//  Copyright © 2024 Nicholas Emig. All rights reserved.
//  Code snippets modified and reused with permission from original creator Osman Balci
//

import SwiftUI
import SwiftData

var databaseSearchResults = [Destination]()

public func conductDatabaseSearch() {
    
    /*
     ------------------------------------------------
     |   Create Model Container and Model Context   |
     ------------------------------------------------
     */
    var modelContainer: ModelContainer
    
    do {
        // Create a database container to manage Destination objects
        modelContainer = try ModelContainer(for: Destination.self)
    } catch {
        fatalError("Unable to create ModelContainer")
    }
    
    // Create the context (workspace) where database objects will be managed
    let modelContext = ModelContext(modelContainer)
    
    // Initialize the global variable to hold the database search results
    databaseSearchResults = [Destination]()
    
    // Declare searchPredicate as a local variable
    var searchPredicate: Predicate<Destination>?
    
    //-------------------------------------------
    // 1️⃣ Define the Search Criterion (Predicate)
    //-------------------------------------------
    
    switch searchCategory {
    case "City Name":
        searchPredicate = #Predicate<Destination> {
            $0.city.localizedStandardContains(searchQuery)
        }
    case "Country":
        searchPredicate = #Predicate<Destination> {
            $0.country.localizedStandardContains(searchQuery)
        }
    case "Population":
        searchPredicate = #Predicate<Destination> {
            $0.population <= maxPopulation
        }
    case "Region":
        searchPredicate = #Predicate<Destination> {
            $0.region.localizedStandardContains(searchQuery)
        }
    default:
        fatalError("Search category is out of range!")
    }
    
    //-------------------------------
    // 2️⃣ Define the Fetch Descriptor
    //-------------------------------
    
    let fetchDescriptor = FetchDescriptor<Destination>(
        predicate: searchPredicate,
        sortBy: [SortDescriptor(\Destination.name, order: .forward)]
    )
    
    //-----------------------------
    // 3️⃣ Execute the Fetch Request
    //-----------------------------
    
    do {
        databaseSearchResults = try modelContext.fetch(fetchDescriptor)
    } catch {
        fatalError("Unable to fetch data from the database!")
    }
    
    //-------------------------------
    // Reset Global Search Parameters
    //-------------------------------
    searchCategory = ""
    searchQuery = ""
    maxPopulation = 0
}
