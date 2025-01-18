//
//  SearchCityApi.swift
//  AdventurePlanner
//
//  Created by Darren Hsu on 4/27/24.
//  Copyright © 2024 Darren Hsu. All rights reserved.
//

import Foundation

// Global variable to contain the API search results
var citiesList = [CityStruct]()

public func searchCityApi(apiUrl: String) {
 
    /*
    ***************************************************
    *   Fetch JSON Data from the API Asynchronously   *
    ***************************************************
    */
    var jsonDataFromApi: Data
    
    let jsonDataFetchedFromApi = getJsonDataFromApi(apiHeaders: cityHeaders, apiUrl: apiUrl, timeout: 20.0)
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
            // citiesList will be empty
            return
        }
        
        //-----------------------------------------------------
        // Obtain the JSON Array for the Attribute / Key 'data'
        //-----------------------------------------------------
       
        var arrayOfCitiesJsonObjects = [Any]()
        
        if let jArray = jsonDataDictionary["data"] as? [Any] {
            arrayOfCitiesJsonObjects = jArray
        } else {
            // citiesList will be empty
            return
        }
        
        if arrayOfCitiesJsonObjects.isEmpty {
            // citiesList will be empty
            return
        }
        
        // Iterate over all of the cities in the given radius
        for city in arrayOfCitiesJsonObjects {
            
            var thisCity = [String: Any]()
            
            if let cityJsonObject = city as? [String: Any] {
                thisCity = cityJsonObject
            }
 
            
            ///-------------------------------
            // Obtain City id
            //-------------------------------
            var id = -1
 
            if let thisId = thisCity["id"] as? Int {
                id = thisId
            }
            
            //-------------------------------
            // Obtain City wikiDataId
            //-------------------------------
            var wikiDataId = ""
 
            if let thiswikiDataId = thisCity["wikiDataId"] as? String {
                wikiDataId = thiswikiDataId
            }
            
            //-------------------------------
            // Obtain City city
            //-------------------------------
            var city = ""
 
            if let thiscity = thisCity["city"] as? String {
                city = thiscity
            }
            
            //-------------------------------
            // Obtain City name
            //-------------------------------
            var name = ""
 
            if let this_name = thisCity["name"] as? String {
                name = this_name
            }
            
            //-------------------------------
            // Obtain City country
            //-------------------------------
            var country = ""
 
            if let this_country = thisCity["country"] as? String {
                country = this_country
            }
            
            //-------------------------------
            // Obtain City countryCode
            //-------------------------------
            var countryCode = ""
 
            if let this_countryCode = thisCity["countryCode"] as? String {
                countryCode = this_countryCode
            }
            
            //-------------------------------
            // Obtain City region
            //-------------------------------
            var region = ""
 
            if let this_region = thisCity["region"] as? String {
                region = this_region
            }
            
            //-------------------------------
            // Obtain City regionCode
            //-------------------------------
            var regionCode = ""
 
            if let this_regionCode = thisCity["regionCode"] as? String {
                regionCode = this_regionCode
            }
            
            //-------------------------------
            // Obtain City latitude
            //-------------------------------
            var latitude = 0.0
 
            if let this_latitude = thisCity["latitude"] as? Double {
                latitude = this_latitude
            }
            
            //-------------------------------
            // Obtain City longitude
            //-------------------------------
            var longitude = 0.0
 
            if let this_longitude = thisCity["longitude"] as? Double {
                longitude = this_longitude
            }
            
            //-------------------------------
            // Obtain City population
            //-------------------------------
            var population = -1
 
            if let this_population = thisCity["population"] as? Int {
                population = this_population
            }
            
            //-------------------------------
            // Obtain Next Page reference
            //-------------------------------
            var next = ""
 
            if let linkArray = jsonDataDictionary["links"] as? [Any] {
                for link in linkArray {
                    if let thisReference = link as? [String: Any] {
                        if let this_population = thisReference["rel"] as? String {
                            if this_population == "next" {
                                if let nextRef = thisReference["href"] as? String {
                                    next = "https://wft-geo-db.p.rapidapi.com" + nextRef
                                }
                            }
                        }
                    }
                }
            }

            //-----------------------------------------------------------------------
            // Create an instance of PlacesStrict struct, dress it up with the values
            // obtained from the API, and append it to the list of nearbyPlaces
            //-----------------------------------------------------------------------
            let cityFound = CityStruct(id: id, wikiDataId: wikiDataId, city: city, name: name, country: country, countryCode: countryCode, region: region, regionCode: regionCode, latitude: latitude, longitude: longitude, population: population, next: next)
            
            citiesList.append(cityFound)
            
        }   // End of for loop
        
    } catch {
        // citiesList will be empty
        return
    }
       
}
