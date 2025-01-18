//
//  SearchNearbyAPI.swift
//  AdventurePlanner
//
//  Created by Darren Hsu and Osman Balci on 4/10/24.
//  Copyright © 2024 Darren Hsu and Osman Balci. All rights reserved.
//

import Foundation

// Global variable to contain the API search results
var placesList = [[PlaceStruct]]()

fileprivate var previousApiUrl = ""

public func getNearbyApiData(searchArray: [String]) {

    // Initialize the global variable to contain the API search results
    placesList = [[PlaceStruct]]()
    
    
    
    for i in 2...(searchArray.count - 1) {
        var thisPlacesList = [PlaceStruct]()
        var count = 0
        let apiUrlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(searchArray[0]),\(searchArray[1])&radius=10000&type=\(searchArray[i].lowercased().replacingOccurrences(of: " ", with: "_"))&key=\(myGooglePlacesApiKey)"
        /*
        ***************************************************
        *   Fetch JSON Data from the API Asynchronously   *
        ***************************************************
        */
        var jsonDataFromApi: Data
        
        let jsonDataFetchedFromApi = getJsonDataFromApi(apiHeaders: googlePlacesApiHeaders, apiUrl: apiUrlString, timeout: 20.0)
        
        if let jsonData = jsonDataFetchedFromApi {
            jsonDataFromApi = jsonData
        } else {
            return
        }

        /*
        **************************************************
        *   Process the JSON Data Fetched from the API   *
        **************************************************
        */
        do {
            let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
                              options: JSONSerialization.ReadingOptions.mutableContainers)

            
            //-----------------------------
            // Obtain Top Level JSON Object
            //-----------------------------
            
            var jsonDataDictionary = [String: Any]()
            
            if let jsonObject = jsonResponse as? [String: Any] {
                jsonDataDictionary = jsonObject
            } else {
                // nearbyPlaces will be empty
                return
            }
            
            //-----------------------------------------------------
            // Obtain the JSON Array for the Attribute / Key 'data'
            //-----------------------------------------------------
           
            var arrayOfPlacesJsonObjects = [Any]()
            
            if let jArray = jsonDataDictionary["results"] as? [Any] {
                arrayOfPlacesJsonObjects = jArray
            } else {
                continue
            }
            
            if arrayOfPlacesJsonObjects.isEmpty {
                continue
            }
            
            // Iterate over all of the places in the given radius
            for place in arrayOfPlacesJsonObjects {
                
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
                // Obtain Place vicinity
                //-------------------------------
                
                var vicinity = ""
     
                if let thisAddress = thisPlace["vicinity"] as? String {
                    vicinity = thisAddress
                }
                
                //-------------------------------
                // Obtain Place name
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
                // Obtain Place Location
                //-------------------------------
     
                var latitude = 0.0
                var longtitude = 0.0
     
                if let geometry = thisPlace["geometry"] as? [String: Any] {
                    if let location = geometry["location"] as? [String: Any] {
                        if let lat = location["lat"] as? Double {
                            latitude = lat
                        }
                        if let lng = location["lng"] as? Double {
                            longtitude = lng
                        }
                    }
                }
               
                //-------------------------------
                // Obtain Place Photos
                //-------------------------------
     
                var photoReference = ""
     
                if let photos = thisPlace["photos"] as? [Any] {
                    if let photoList = photos[0] as? [String: Any] {
                        if let reference = photoList["photo_reference"] as? String {
                            photoReference = reference
                        }
                    }
                }
                   
                //-----------------------------------------------------------------------
                // Create an instance of PlacesStrict struct, dress it up with the values
                // obtained from the API, and append it to the list of nearbyPlaces
                //-----------------------------------------------------------------------
                let placeFound = PlaceStruct(business_status: business_status, lat: latitude, lng: longtitude, icon: icon, name: name, photo_reference: photoReference, price_level: price_level, rating: rating, user_ratings_total: totalRatings, vicinity: vicinity)
                
                thisPlacesList.append(placeFound)
                count += 1
                if count == 5 {
                    break
                }
                
            }   // End of for loop
            thisPlacesList = thisPlacesList.sorted(by: { $0.name < $1.name })
            placesList.append(thisPlacesList)
        } catch {
            // nearbyPlaces will be empty
            return
        }
        
        
    }
    
       
}

