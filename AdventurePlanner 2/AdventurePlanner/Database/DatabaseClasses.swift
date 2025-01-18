//
//  DatabaseClasses.swift
//  AdventurePlanner
//
//  Created by Darren Hsu, Keming liang, Nicholas Emig and Osman Balci on 4/29/24.
//  Copyright © 2024 Darren Hsu, Keming Liang, Nicholas Emig and Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData

@Model
final class Destination {
    /*
     ------------------------- DELETE RULES -----------------------------
     <> Select NULLIFY to delete the source object instance, and
     nullify references to it in any destination object instances.
     <> Select CASCADE to delete the source object instance, and with it,
     delete all of the destination object instances.
     --------------------------------------------------------------------
     */
    
    // Attributes
    var id: Int
    var wikiDataId: String
    var city: String
    var name: String
    var country: String
    var countryCode: String
    var region: String
    var regionCode: String
    var latitude: Double
    var longitude: Double
    var population: Int
    
    
    // Relationships
    
    // If Destination is deleted, also delete its destPhotos
    @Relationship(deleteRule: .cascade) var destPhotos: [DestPhoto]?
    // One-to-Many Relationship: ONE Destination can have MANY DestPhoto
    
    // If Destination is deleted, also delete its destPlaces
    @Relationship(deleteRule: .cascade) var destPlaces: [DestPlace]?
    // One-to-Many Relationship: ONE Destination can have MANY DestPlace
    
    // If Destination is deleted, also delete its destPhotos
    @Relationship(deleteRule: .cascade) var covidData: DestCovid?
    // One-to-One Relationship: ONE Trip can have One covidData
    
    init(id: Int, wikiDataId: String, city: String, name: String, country: String, countryCode: String, region: String, regionCode: String, latitude: Double, longitude: Double, population: Int, destPhotos: [DestPhoto]? = nil, destPlaces: [DestPlace]? = nil, covidData: DestCovid? = nil) {
        self.id = id
        self.wikiDataId = wikiDataId
        self.city = city
        self.name = name
        self.country = country
        self.countryCode = countryCode
        self.region = region
        self.regionCode = regionCode
        self.latitude = latitude
        self.longitude = longitude
        self.population = population
        self.destPhotos = destPhotos
        self.destPlaces = destPlaces
        self.covidData = covidData
    }
}
    

@Model
final class DestPhoto {
    
    // Attributes
    var photoFullFilename: String
    var dateTime: String

    init(photoFullFilename: String, dateTime: String) {
        self.photoFullFilename = photoFullFilename
        self.dateTime = dateTime
    }
}

@Model
final class DestPlace {
    
    // Attributes
    var business_status: String
    var lat: Double
    var lng: Double
    var icon: String
    var name: String
    var photo_reference: String
    var price_level: Int
    var rating: Double
    var user_ratings_total: Int
    var vicinity: String

    init(business_status: String, lat: Double, lng: Double, icon: String, name: String, photo_reference: String, price_level: Int, rating: Double, user_ratings_total: Int, vicinity: String) {
        self.business_status = business_status
        self.lat = lat
        self.lng = lng
        self.icon = icon
        self.name = name
        self.photo_reference = photo_reference
        self.price_level = price_level
        self.rating = rating
        self.user_ratings_total = user_ratings_total
        self.vicinity = vicinity
    }
}

@Model
final class DestCovid {
    
    // Attributes
    var checkTime: String
    var activeCases: String
    var country: String
    var lastUpdate: String
    var newCases: String
    var newDeaths: String
    var totalCases: String
    var totalDeaths: String
    var totalRecovered: String

    init(checkTime: String, activeCases: String, country: String, lastUpdate: String, newCases: String, newDeaths: String, totalCases: String, totalDeaths: String, totalRecovered: String) {
        self.checkTime = checkTime
        self.activeCases = activeCases
        self.country = country
        self.lastUpdate = lastUpdate
        self.newCases = newCases
        self.newDeaths = newDeaths
        self.totalCases = totalCases
        self.totalDeaths = totalDeaths
        self.totalRecovered = totalRecovered
    }
}

@Model
final class Note {
    
    var id: Int
    var note: String
    var date: String
    
    init(id: Int, note: String, date: String) {
        self.id = id
        self.note = note
        self.date = date
    }
}

@Model
final class Adventure {
    var name: String
    var id: Int
    
    // If Adventure is deleted, also delete its destinations
    @Relationship(deleteRule: .cascade) var info: [AdventureInfo]?
    
    init(name: String, id: Int, info: [AdventureInfo]? = nil) {
        self.name = name
        self.id = id
        self.info = info
    }
    
}
