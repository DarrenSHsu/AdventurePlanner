//
//  SearchWeatherAPI.swift
//  AdventurePlanner
//
//  Created by Osman Balci, Keming Liang on 4/15/24.
//  Copyright © 2024 Osman Balci, Keming Liang. All rights reserved.
//

import Foundation

var foundWeatherList = [WeatherListStruct]()
var weatherItem = ForecastStruct(weatherList: [WeatherListStruct](), name: "", latitude: 0.0, longitude: 0.0, country: "")

public func getFoundWeatherFromApi(query: String) {
    
    foundWeatherList = [WeatherListStruct]()
    weatherItem = ForecastStruct(weatherList: [WeatherListStruct](), name: "", latitude: 0.0, longitude: 0.0, country: "")
    
    let openWeatherUrlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(query)&units=imperial&appid=\(myOpenWeatherApiKey)"
    
    var jsonDataFromApi: Data
    
    let jsonDataFetchedFromApi = getJsonDataFromApi(apiHeaders: openWeatherApiHeaders, apiUrl: openWeatherUrlString, timeout: 20.0)
    
    if let jsonData = jsonDataFetchedFromApi {
        jsonDataFromApi = jsonData
    } else {
        return
    }
    
    do {
        let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
                                                            options: JSONSerialization.ReadingOptions.mutableContainers)
        
        if let jsonObject = jsonResponse as? [String: Any] {
            
            var weatherStruct = WeatherStruct(description: "", icon: "")
            var name = ""
            var latitude = 0.0
            var longitude = 0.0
            var country = ""
            if let arrayOfLists = jsonObject["list"] as? [Any] {
                
                for aList in arrayOfLists {
                    
                    if let weatherList = aList as? [String: Any] {
                        
                        var minTemp = 0.0
                        var maxTemp = 0.0
                        var humidity = 0
                        if let main = weatherList["main"] as? [String: Any] {
                            
                            if let tempMin = main["temp_min"] as? Double {
                                minTemp = tempMin
                            }
                            
                            if let tempMax = main["temp_max"] as? Double {
                                maxTemp = tempMax
                            }
                            
                            if let humidityPercentage = main["humidity"] as? Int {
                                humidity = humidityPercentage
                            }
                        }
                        
                        if let arrayOfWeathers = weatherList["weather"] as? [Any] {
                            
                            for aWeather in arrayOfWeathers {
                                
                                if let weather = aWeather as? [String: Any] {
                                    
                                    var weatherDescription = ""
                                    var weatherIcon = ""
                                    if let description = weather["description"] as? String {
                                        weatherDescription = description
                                    }
                                    if let icon = weather["icon"] as? String {
                                        weatherIcon = icon
                                    }
                                    weatherStruct = WeatherStruct(description: weatherDescription, icon: weatherIcon)
                                }
                            }
                        }
                        
                        var date = ""
                        if let dt_txt = weatherList["dt_txt"] as? String {
                            date = dt_txt
                        }
                        let newWeatherListStruct = WeatherListStruct(temp_min: minTemp, temp_max: maxTemp, humidity: humidity, weather: weatherStruct, dt_txt: date)
                        foundWeatherList.append(newWeatherListStruct)
                    }
                    foundWeatherList = foundWeatherList.sorted(by: { $0.dt_txt < $1.dt_txt })
                }
            }
            
            if let cityObject = jsonObject["city"] as? [String: Any] {
                
                if let cityName = cityObject["name"] as? String {
                    name = cityName
                }
                
                if let cityCoordinate = cityObject["coord"] as? [String: Any] {
                    
                    if let cityLatitude = cityCoordinate["lat"] as? Double {
                        latitude = cityLatitude
                    }
                    
                    if let cityLongitude = cityCoordinate["lon"] as? Double {
                        longitude = cityLongitude
                    }
                }
                
                if let cityCountry = cityObject["country"] as? String {
                    country = cityCountry
                }
            }
            weatherItem = ForecastStruct(weatherList: foundWeatherList, name: name, latitude: latitude, longitude: longitude, country: country)
        }
    } catch {
        return
    }
}
