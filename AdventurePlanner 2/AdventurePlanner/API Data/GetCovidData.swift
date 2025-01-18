//
//  GetCovidData.swift
//  AdventurePlanner
//
//  Created by Darren Hsu on 4/26/24.
//  Copyright © 2024 Darren Hsu. All rights reserved.
//

import Foundation

// Global variable to contain the API search results
var covidDataList = [CovidData]()


/*
 ================================================
 |   Fetch and Process JSON Data from the API   |
 |   for a location with its name given         |
 ================================================
*/
func getCovidData() {
    let apiUrl = "https://covid-19.dataflowkit.com/v1"
    covidDataList = [CovidData]()

    /*
    ***************************************************
    *   Fetch JSON Data from the API Asynchronously   *
    ***************************************************
    */
    var jsonDataFromApi: Data
    
    let jsonDataFetchedFromApi = getJsonDataFromApi(apiHeaders: covidHeaders, apiUrl: apiUrl, timeout: 20.0)
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
        // Obtain Top Level Array Object
        //-----------------------------
        
        var arrayOfAllCovidData = [Any]()
        
        if let newArray = jsonResponse as? [Any] {
            arrayOfAllCovidData = newArray
        } else {
            // covidDataList will have empty values
            return
        }
       
        for covidData in arrayOfAllCovidData {
            var covidDataJson = [String: Any]()
            if let jsonData = covidData as? [String: Any] {
                covidDataJson = jsonData
            }
            
            

            
            //-------------------------------
            // Obtain CovidData checkTime
            //-------------------------------
            // Obtain the current date and time
            let currentDateAndTime = Date()
             
            // Create an instance of DateFormatter
            let dateFormatter = DateFormatter()
             
            // Set the date format to yyyy-MM-dd at HH:mm:ss
            dateFormatter.dateFormat = "yyyy-MM-dd' at 'HH:mm:ss"
             
            // Format dateAndTime under the dateFormatter and convert it to String
            let checkTime = dateFormatter.string(from: currentDateAndTime)
            
            
            //-------------------------------
            // Obtain CovidData activeCases
            //-------------------------------

            var activeCases = ""
            if let Cases_text = covidDataJson["Active Cases_text"] as? String {
                activeCases = Cases_text
            }
            
            //-------------------------------
            // Obtain CovidData country
            //-------------------------------

            var country = ""
            if let countryInfo = covidDataJson["Country_text"] as? String {
                country = countryInfo
            }
            if (country == "") {
                continue
            }
            
            //-------------------------------
            // Obtain CovidData lastUpdate
            //-------------------------------

            var lastUpdate = ""
            if let thisUpdate = covidDataJson["Last Update"] as? String {
                lastUpdate = thisUpdate
            }
            
            //-------------------------------
            // Obtain CovidData newCases
            //-------------------------------

            var newCases = ""
            if let newCaseInfo = covidDataJson["New Cases_text"] as? String {
                newCases = newCaseInfo
            }
            
            //-------------------------------
            // Obtain CovidData newDeaths
            //-------------------------------

            var newDeaths = ""
            if let newDeathInfo = covidDataJson["New Deaths_text"] as? String {
                newDeaths = newDeathInfo
            }
            
            //-------------------------------
            // Obtain CovidData totalCases
            //-------------------------------

            var totalCases = ""
            if let totalCaseInfo = covidDataJson["Total Cases_text"] as? String {
                totalCases = totalCaseInfo
            }
            if totalCases == "" {
                continue
            }
            //-------------------------------
            // Obtain CovidData totalDeaths
            //-------------------------------

            var totalDeaths = ""
            if let totalDeathInfo = covidDataJson["Total Deaths_text"] as? String {
                totalDeaths = totalDeathInfo
            }
            
            //-------------------------------
            // Obtain CovidData totalRecovered
            //-------------------------------

            var totalRecovered = ""
            if let totalRecInfo = covidDataJson["Total Recovered_text"] as? String {
                totalRecovered = totalRecInfo
            }
            
            let newCovidData = CovidData(checkTime: checkTime, activeCases: activeCases, country: country, lastUpdate: lastUpdate, newCases: newCases, newDeaths: newDeaths, totalCases: totalCases, totalDeaths: totalDeaths, totalRecovered: totalRecovered)
            covidDataList.append(newCovidData)
            
        }
        return
    } catch {
        // covidDataList will have empty values
        return
    }
}
 
 


