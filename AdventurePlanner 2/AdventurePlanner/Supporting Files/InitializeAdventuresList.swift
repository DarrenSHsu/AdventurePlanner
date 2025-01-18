//
//  InitializeAdventuresList.swift
//  AdventurePlanner
//
//  Created by Darren Hsu on 5/1/24.
//  Copyright © 2024 Darren Hsu. All rights reserved.
//

import SwiftUI
import SwiftData

/*
***********************************************
MARK: Take the 10 destinations in database and form adventures
***********************************************
*/
public func initializeAdventuresList() {
    /*
     ------------------------------------------------
     |   Create Model Container and Model Context   |
     ------------------------------------------------
     */
    var modelContainer: ModelContainer
    
    do {
        // Create a database container to manage the Destination, DestPhoto, DestAudio, DestCovid, Note, and Adventure objects
        modelContainer = try ModelContainer(for: Destination.self, DestPhoto.self, DestCovid.self, Note.self, Adventure.self)
    } catch {
        fatalError("Unable to create ModelContainer")
    }
    
    // Create the context (workspace) where database objects will be managed
    let modelContext = ModelContext(modelContainer)
    
    /*
     --------------------------------------------------------------------
     |   Check to see if the database has already been created or not   |
     --------------------------------------------------------------------
     */
    let adventureFetchDescriptor = FetchDescriptor<Adventure>()
    let destinationFetchDescriptor = FetchDescriptor<Destination>()
    
    var listOfAllAdvInDatabase = [Adventure]()
    var listOfAllDestsInDatabase = [Destination]()
    
    do {
        // Obtain all of the Adventure objects from the database
        listOfAllAdvInDatabase = try modelContext.fetch(adventureFetchDescriptor)
        listOfAllDestsInDatabase = try modelContext.fetch(destinationFetchDescriptor)
    } catch {
        fatalError("Unable to fetch Adventure objects from the database")
    }
    
    if !listOfAllAdvInDatabase.isEmpty {
        print("Adventure database has already been created!")
        return
    }
    
    print("Adventure database will be created!")
    
    var infoArray = [AdventureInfo]()
    var count = 0;
    for dest in listOfAllDestsInDatabase {
        var advDestStructList = [AdvDestStruct]()
        var advPlaceStructList = [AdvPlaceStruct]()
        
        let newAdvDest = AdvDestStruct(id: dest.id, wikiDataId: dest.wikiDataId, city: dest.city, name: dest.name, country: dest.country, countryCode: dest.countryCode, region: dest.region, regionCode: dest.regionCode, latitude: dest.latitude, longitude: dest.longitude, population: dest.population)
        advDestStructList.append(newAdvDest)
        
        let destOne = dest.destPlaces![0]
        let destTwo = dest.destPlaces![1]
        let newAdvPlaceOne = AdvPlaceStruct(business_status: destOne.business_status, lat: destOne.lat, lng: destOne.lng, icon: destOne.icon, name: destOne.name, photo_reference: destOne.photo_reference, price_level: destOne.price_level, rating: destOne.rating, user_ratings_total: destOne.user_ratings_total, vicinity: destOne.vicinity)
        let newAdvPlaceTwo = AdvPlaceStruct(business_status: destTwo.business_status, lat: destTwo.lat, lng: destTwo.lng, icon: destTwo.icon, name: destTwo.name, photo_reference: destTwo.photo_reference, price_level: destTwo.price_level, rating: destTwo.rating, user_ratings_total: destTwo.user_ratings_total, vicinity: destTwo.vicinity)
        advPlaceStructList.append(newAdvPlaceOne)
        advPlaceStructList.append(newAdvPlaceTwo)
        
        let newInfo = AdventureInfo(id: count, destinations: advDestStructList, places: advPlaceStructList)
        infoArray.append(newInfo)
        count += 1;
        count = count % 2
    }
    
    for i in 0...4 {
        var newInfoArray = [AdventureInfo]()
        newInfoArray.append(infoArray[i])
        newInfoArray.append(infoArray[i + 5])
        let newAdventure = Adventure(name: "Adventure #\(i + 1)", id: i, info: newInfoArray)
        modelContext.insert(newAdventure)
    }
    
    do {
        try modelContext.save()
    } catch {
        fatalError("Unable to save database changes")
    }
}
    
