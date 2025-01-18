//
//  DecodeInitialJsonFileIntoArrayOfStructs.swift
//  AdventurePlanner
//
//  Created by Darren Hsu on 4/25/24.
//  Copyright © 2024 Darren Hsu. All rights reserved.
//

import SwiftUI
import Foundation

/*
***********************************************
MARK: Decode JSON file into an Array of Structs
***********************************************
*/
func decodeInitialJsonFileIntoArrayOfStructs(fullFilename: String, fileLocation: String) -> [DestStruct] {
   
    /*
     T.self defines the struct type T into which each JSON object will be decoded.
        exampleStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "exampleFile.json", fileLocation: "Main Bundle")
     or
        exampleStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "exampleFile.json", fileLocation: "Document Directory")
     The left hand side of the equation defines the struct type T into which JSON objects will be decoded.
    
     This function returns an array of structs of type T representing the JSON objects in the input JSON file.
     In Swift, an Array stores values of the same type in an ordered list. Therefore, the structs will keep their order.
     */
    var jsonFileData: Data?
    var jsonFileUrl: URL?
    //var arrayOfStructs: [DestStruct]
    var arrayOfStructs = [DestStruct]()
   
    if fileLocation == "Main Bundle" {

        // Obtain URL of the JSON file in main bundle
        let urlOfJsonFileInMainBundle: URL? = Bundle.main.url(forResource: fullFilename, withExtension: nil)
       
        if let mainBundleUrl = urlOfJsonFileInMainBundle {
            jsonFileUrl = mainBundleUrl
        } else {
            print("JSON file \(fullFilename) does not exist in main bundle!")
        }
    } else {
        // Obtain URL of the JSON file in document directory on user's device
        let urlOfJsonFileInDocumentDirectory: URL? = documentDirectory.appendingPathComponent(fullFilename)
       
        if let docDirectoryUrl = urlOfJsonFileInDocumentDirectory {
            jsonFileUrl = docDirectoryUrl
        } else {
            print("JSON file \(fullFilename) does not exist in document directory!")
        }
    }
   
    do {
        jsonFileData = try Data(contentsOf: jsonFileUrl!)
    } catch {
        print("Unable to obtain JSON file \(fullFilename) content!")
    }
    
    do {
        let jsonResponse = try JSONSerialization.jsonObject(with: jsonFileData!,
                          options: JSONSerialization.ReadingOptions.mutableContainers)
        
        
        //-----------------------------------------------------
        // Obtain the JSON Array for the Attribute / Key 'data'
        //-----------------------------------------------------
        var arrayOfDestJsonObjects = [Any]()
        
        if let jArray = jsonResponse as? [Any] {
            arrayOfDestJsonObjects = jArray
        }
        
        // Iterate over all of the Destinations
        for dest in arrayOfDestJsonObjects {
            var destJson = [String: Any]()
            if let newDest = dest as? [String: Any] {
                destJson = newDest
            }
            
            //-------------------------------
            // Obtain Dest id
            //-------------------------------
            var id = -1
 
            if let thisId = destJson["id"] as? Int {
                id = thisId
            }
            
            //-------------------------------
            // Obtain Dest wikiDataId
            //-------------------------------
            var wikiDataId = ""
 
            if let thiswikiDataId = destJson["wikiDataId"] as? String {
                wikiDataId = thiswikiDataId
            }
            
            //-------------------------------
            // Obtain Dest city
            //-------------------------------
            var city = ""
 
            if let thiscity = destJson["city"] as? String {
                city = thiscity
            }
            
            //-------------------------------
            // Obtain Dest name
            //-------------------------------
            var name = ""
 
            if let this_name = destJson["name"] as? String {
                name = this_name
            }
            
            //-------------------------------
            // Obtain Dest country
            //-------------------------------
            var country = ""
 
            if let this_country = destJson["country"] as? String {
                country = this_country
            }
            
            //-------------------------------
            // Obtain Dest countryCode
            //-------------------------------
            var countryCode = ""
 
            if let this_countryCode = destJson["countryCode"] as? String {
                countryCode = this_countryCode
            }
            
            //-------------------------------
            // Obtain Dest region
            //-------------------------------
            var region = ""
 
            if let this_region = destJson["region"] as? String {
                region = this_region
            }
            
            //-------------------------------
            // Obtain Dest regionCode
            //-------------------------------
            var regionCode = ""
 
            if let this_regionCode = destJson["regionCode"] as? String {
                regionCode = this_regionCode
            }
            
            //-------------------------------
            // Obtain Dest latitude
            //-------------------------------
            var latitude = 0.0
 
            if let this_latitude = destJson["latitude"] as? Double {
                latitude = this_latitude
            }
            
            //-------------------------------
            // Obtain Dest longitude
            //-------------------------------
            var longitude = 0.0
 
            if let this_longitude = destJson["longitude"] as? Double {
                longitude = this_longitude
            }
            
            //-------------------------------
            // Obtain Dest population
            //-------------------------------
            var population = -1
 
            if let this_population = destJson["population"] as? Int {
                population = this_population
            }
            
            
            //-------------------------------
            // Obtain Dest Covid Data
            //-------------------------------
            var covidJson = [String: Any]()
 
            if let newCovidData = destJson["covid"] as? [String: Any] {
                covidJson = newCovidData
            }
            
            //-------------------------------
            // Obtain Covid checkTime
            //-------------------------------
            var checkTime = ""
 
            if let this_checkTime = covidJson["checkTime"] as? String {
                checkTime = this_checkTime
            }
            
            //-------------------------------
            // Obtain Covid activeCases
            //-------------------------------
            var activeCases = "0"
 
            if let this_activeCases = covidJson["activeCases"] as? String {
                activeCases = this_activeCases
            }
            
            //-------------------------------
            // Obtain Covid country
            //-------------------------------
            var covidCountry = ""
 
            if let this_country = covidJson["country"] as? String {
                covidCountry = this_country
            }
            
            //-------------------------------
            // Obtain Covid lastUpdate
            //-------------------------------
            var lastUpdate = ""
 
            if let this_lastUpdate = covidJson["lastUpdate"] as? String {
                lastUpdate = this_lastUpdate
            }
            
            //-------------------------------
            // Obtain Covid newCases
            //-------------------------------
            var newCases = "0"
 
            if let this_newCases = covidJson["newCases"] as? String {
                newCases = this_newCases
            }
            
            //-------------------------------
            // Obtain Covid newDeaths
            //-------------------------------
            var newDeaths = "0"
 
            if let this_newDeaths = covidJson["newDeaths"] as? String {
                newDeaths = this_newDeaths
            }
            
            //-------------------------------
            // Obtain Covid totalCases
            //-------------------------------
            var totalCases = "0"
 
            if let this_totalCases = covidJson["totalCases"] as? String {
                totalCases = this_totalCases
            }
            
            //-------------------------------
            // Obtain Covid totalDeaths
            //-------------------------------
            var totalDeaths = "0"
 
            if let this_totalDeaths = covidJson["totalDeaths"] as? String {
                totalDeaths = this_totalDeaths
            }
            
            //-------------------------------
            // Obtain Covid totalRecovered
            //-------------------------------
            var totalRecovered = "0"
 
            if let this_totalRecovered = covidJson["totalRecovered"] as? String {
                totalRecovered = this_totalRecovered
            }
            
            let newCovidStruct = CovidData(checkTime: checkTime, activeCases: activeCases, country: covidCountry, lastUpdate: lastUpdate, newCases: newCases, newDeaths: newDeaths, totalCases: totalCases, totalDeaths: totalDeaths, totalRecovered: totalRecovered)
            //-------------------------------
            // Obtain Dest Photo Array
            //-------------------------------
            var photoArray = [Any]()
 
            if let newphotoArray = destJson["destPhotoStructs"] as? [Any] {
                photoArray = newphotoArray
            }
            
            var destPhotoArray = [DestPhotoStruct]()
            for photoData in photoArray {
                var thisPhoto = [String: Any]()
                
                if let photoJsonObject = photoData as? [String: Any] {
                    thisPhoto = photoJsonObject
                }
                
                //-------------------------------
                // Obtain Photo photoFullFilename
                //-------------------------------
                var photoFullFilename = ""
                
                if let this_photoFullFilename = thisPhoto["photoFullFilename"] as? String {
                    photoFullFilename = this_photoFullFilename
                }
                
                //-------------------------------
                // Obtain Photo dateTime
                //-------------------------------
                var dateTime = ""
                
                if let this_dateTime = thisPhoto["dateTime"] as? String {
                    dateTime = this_dateTime
                }
                let newDestPhotoStruct = DestPhotoStruct(photoFullFilename: photoFullFilename, dateTime: dateTime)
                destPhotoArray.append(newDestPhotoStruct)
            }
            
            var listOfPlaces = [Any]()
            if let newList = destJson["places"] as? [Any] {
                listOfPlaces = newList
            }
            var arrayOfPlaces = [DestPlaceStruct]()
            for place in listOfPlaces {
                var thisPlace = [String: Any]()
                
                if let placeJsonObject = place as? [String: Any] {
                    thisPlace = placeJsonObject
                }
                
                //-------------------------------
                // Obtain Place business_status
                //-------------------------------
     
                var business_status = ""
     
                if let thisStatus = thisPlace["business_status"] as? String {
                    business_status = thisStatus
                }
                
                //-------------------------------
                // Obtain Place Location
                //-------------------------------
     
                var latitude = 0.0
                var longtitude = 0.0
                
                if let location = thisPlace["location"] as? [String: Any] {
                    if let lat = location["lat"] as? Double {
                        latitude = lat
                    }
                    if let lng = location["lng"] as? Double {
                        longtitude = lng
                    }
                }
                let newLocation = LocationStuct(lat: latitude, lng: longtitude)
                
                //-------------------------------
                // Obtain Place icon
                //-------------------------------
     
                var icon = ""
     
                if let thisIcon = thisPlace["icon"] as? String {
                    icon = thisIcon
                }
                
                //-------------------------------
                // Obtain Place price_level
                //-------------------------------
     
                var price_level = -1
     
                if let price = thisPlace["price_level"] as? Int {
                    price_level = price
                }
                
                //-------------------------------
                // Obtain Place price_level
                //-------------------------------
                
                var vicinity = ""
     
                if let thisAddress = thisPlace["vicinity"] as? String {
                    vicinity = thisAddress
                }
                
                //-------------------------------
                // Obtain Place vicinity
                //-------------------------------
     
                var name = ""
     
                if let fullName = thisPlace["name"] as? String {
                    name = fullName
                } else {
                    // Skip if it does not have a name
                    continue
                }
                
                //-------------------------------
                // Obtain Place rating
                //-------------------------------
     
                var rating = 0.0
     
                if let thisRating = thisPlace["rating"] as? Double {
                    rating = thisRating
                }
                
                //-------------------------------
                // Obtain Place totalRatings
                //-------------------------------
     
                var totalRatings = 0
     
                if let ratingCount = thisPlace["user_ratings_total"] as? Int {
                    totalRatings = ratingCount
                }
               
                //-------------------------------
                // Obtain Place Photos
                //-------------------------------
     
                var photoReference = ""
     
                if let reference = thisPlace["photo_reference"] as? String {
                    photoReference = reference
                }
                
                let newPlaceStruct = DestPlaceStruct(business_status: business_status, location: newLocation, icon: icon, name: name, photo_reference: photoReference, price_level: price_level, rating: rating, user_ratings_total: totalRatings, vicinity: vicinity)
                arrayOfPlaces.append(newPlaceStruct)
            }
            
            let newDestination = DestStruct(id: id, wikiDataId: wikiDataId, city: city, name: name, country: country, countryCode: countryCode, region: region, regionCode: regionCode, latitude: latitude, longitude: longitude, population: population, covid: newCovidStruct, destPhotoStructs: destPhotoArray, places: arrayOfPlaces)
            arrayOfStructs.append(newDestination)
            
        }
        

    } catch {
        print("Unable to decode JSON file \(fullFilename)!")
    }
   
    // Return the array of structs of type T
    return arrayOfStructs
}
