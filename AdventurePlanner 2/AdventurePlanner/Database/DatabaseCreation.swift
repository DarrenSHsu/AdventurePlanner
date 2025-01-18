//
//  DatabaseCreation.swift
//  AdventurePlanner
//
//  Created by Darren Hsu, keming Liang, Nicholas Emig and Osman Balci on 4/29/24.
//  Copyright © 2024 Darren Hsu, Keming Liang, Nicholas Emig and Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData

public func createDatabase() {
    
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
    let destinationFetchDescriptor = FetchDescriptor<Destination>()
    
    var listOfAllDestsInDatabase = [Destination]()
    
    do {
        // Obtain all of the Destination objects from the database
        listOfAllDestsInDatabase = try modelContext.fetch(destinationFetchDescriptor)
    } catch {
        fatalError("Unable to fetch Dest objects from the database")
    }
    
    if !listOfAllDestsInDatabase.isEmpty {
        print("Database has already been created!")
        return
    }
    
    print("Database will be created!")
    
    /*
     ----------------------------------------------------------
     | *** The app is being launched for the first time ***   |
     |   Database needs to be created and populated with      |
     |   the initial content in DatabaseInitialContent.json   |
     ----------------------------------------------------------
     */
    
    // Local variable destStructList is obtained from the JSON file to populate the database
    var destStructList = [DestStruct]()
    
    // The function is given in UtilityFunctions.swift
    destStructList = decodeInitialJsonFileIntoArrayOfStructs(fullFilename: "DatabaseInitialContent.json", fileLocation: "Main Bundle")
    
    /*
     =================================
     |   Dest Object Creation   |
     =================================
     */
    
    for aDestStruct in destStructList {
        let newCovidData = DestCovid(checkTime: aDestStruct.covid.checkTime, activeCases: aDestStruct.covid.activeCases, country: aDestStruct.covid.country, lastUpdate: aDestStruct.covid.lastUpdate, newCases: aDestStruct.covid.newCases, newDeaths: aDestStruct.covid.newDeaths, totalCases: aDestStruct.covid.totalCases, totalDeaths: aDestStruct.covid.totalDeaths, totalRecovered: aDestStruct.covid.totalRecovered)
        // ❎ Instantiate an empty Destination object
        let newDest = Destination(id: aDestStruct.id, wikiDataId: aDestStruct.wikiDataId, city: aDestStruct.city, name: aDestStruct.name, country: aDestStruct.country, countryCode: aDestStruct.countryCode, region: aDestStruct.region, regionCode: aDestStruct.regionCode, latitude: aDestStruct.latitude, longitude: aDestStruct.longitude, population: aDestStruct.population, destPhotos: [DestPhoto](), destPlaces: [DestPlace](), covidData: newCovidData)
        
        // ❎ Insert it into the database context
        modelContext.insert(newDest)
        
        /*
         =======================================
         |   DestPhoto Object Creation    |
         =======================================
         */
        
        var listOfDestPhotoObjects = [DestPhoto]()
        
        for aPhotoStruct in aDestStruct.destPhotoStructs {
            
            // Example photoFullFilename = "Acadia1.jpg"
            let filenameComponents = aPhotoStruct.photoFullFilename.components(separatedBy: ".")
            
            // filenameComponents[0] = "Acadia1"
            // filenameComponents[1] = "jpg"
            
            // Copy the photo file from Assets.xcassets to document directory.
            // The function is given in UtilityFunctions.swift
            copyImageFileFromAssetsToDocumentDirectory(filename: filenameComponents[0], fileExtension: filenameComponents[1])
            
            // ❎ Instantiate a new DestPhoto object and dress it up
            let newDestPhoto = DestPhoto(photoFullFilename: aPhotoStruct.photoFullFilename, dateTime: aPhotoStruct.dateTime)
            
            listOfDestPhotoObjects.append(newDestPhoto)
        }
        
        // Establish one-to-one relationship
        newDest.destPhotos = listOfDestPhotoObjects
        
        /*
         =======================================
         |   DestPlace Object Creation    |
         =======================================
         */
        
        var listOfDestPlaceObjects = [DestPlace]()
        
        for aPlaceStruct in aDestStruct.places {
            // ❎ Instantiate a new DestPlace object and dress it up
            let newDestPlace = DestPlace(business_status: aPlaceStruct.business_status, lat: aPlaceStruct.location.lat, lng: aPlaceStruct.location.lng, icon: aPlaceStruct.icon, name: aPlaceStruct.name, photo_reference: aPlaceStruct.photo_reference, price_level: aPlaceStruct.price_level, rating: aPlaceStruct.rating, user_ratings_total: aPlaceStruct.user_ratings_total, vicinity: aPlaceStruct.vicinity)
            listOfDestPlaceObjects.append(newDestPlace)
        }
        
        // Establish one-to-one relationship
        newDest.destPlaces = listOfDestPlaceObjects


    }   // End of loop
    
    var NoteStructList = [NoteStruct]()
    
    NoteStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "NotesDBInitialContent.json", fileLocation: "Main Bundle")
    
    for aNote in NoteStructList {
        
        let newNote = Note(id: aNote.id, note: aNote.note, date: aNote.date)
        modelContext.insert(newNote)
    }
    
    /*
     =================================
     |   Save All Database Changes   |
     =================================
     🔴 NOTE: Database changes are automatically saved and SwiftUI Views are
     automatically refreshed upon State change in the UI or after a certain time period.
     But sometimes, you can manually save the database changes just to be sure.
     */
    do {
        try modelContext.save()
    } catch {
        fatalError("Unable to save database changes")
    }
    
    print("Database is successfully created!")
}


