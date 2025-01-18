//
//  GetWeatherForecast.swift
//  AdventurePlanner
//
//  Created by Keming Liang and Osman Balci on 4/26/24.
//  Copyright © 2024 Keming Liang and Osman Balci. All rights reserved.
//

import SwiftUI

var newForecastList = [WeatherListStruct]()

struct GetWeatherForecast: View {
    @State private var searchFieldValue = ""
    @State private var date = Date()
    @State private var searchCompleted = false
    @State private var showAlertMessage = false
    
    var dateClosedRange: ClosedRange<Date> {
        let minDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())!
        
        let maxDate = Calendar.current.date(byAdding: .day, value: 4, to: Date())!
        return minDate...maxDate
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Image("OpenWeatherApiLogo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 50)
                        Spacer()
                    }
                }
                Section(header: Text("Get Weather Forecast For")) {
                    HStack {
                        TextField("Enter City, State or Country", text: $searchFieldValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                        
                        Button(action: {
                            searchFieldValue = ""
                            newForecastList.removeAll()
                            showAlertMessage = false
                            searchCompleted = false
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                        
                    }   // End of HStack
                }
                Section(header: Text("Select A Date")) {
                    DatePicker(
                        selection: $date,
                        in: dateClosedRange,
                        displayedComponents: .date) {
                            Text("Selected Date")
                        }
                }
                Section(header: Text("Search API")) {
                    HStack {
                        Spacer()
                        Button(searchCompleted ? "Search Completed" : "Search") {
                            if inputDataValidated() {
                                searchApi()
                                dateFilter(selectDate: date)
                                searchCompleted = true
                            } else {
                                showAlertMessage = true
                                alertTitle = "Search Field is Empty!"
                                alertMessage = "Please enter a search query!"
                            }
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        
                        Spacer()
                    }   // End of HStack
                }
                
                if searchCompleted {
                    Section(header: Text("Show Forecast")) {
                        NavigationLink(destination: showSearchResults) {
                            HStack {
                                Image(systemName: "cloud.sun.rain")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                Text("Show Forecast")
                                    .font(.system(size: 16))
                            }
                            .foregroundColor(.blue)
                        }
                    }
                }
                
            }   // End of Form
            .navigationTitle("Weather Forecast")
            .toolbarTitleDisplayMode(.inline)
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                Button("OK") {}
            }, message: {
                Text(alertMessage)
            })
        }
        
    }   // End of body var
    
    func searchApi() {
        let queryCleaned = searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
        let query = queryCleaned.replacingOccurrences(of: " ", with: "+")

        getFoundWeatherFromApi(query: query)
    }
    
    var showSearchResults: some View {
        if foundWeatherList.isEmpty {
            return AnyView(
                NotFound(message: "No Results Obtained!\n\nThe entered search query did not return any value from the Open Weather API! Please enter another search query.")
            )
        }
        
        return AnyView(ForecastResultsList())
    }
    
    
    func dateFilter(selectDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let travelDate = dateFormatter.string(from: selectDate)
        
        for aForecast in foundWeatherList {
            if aForecast.dt_txt.contains(travelDate) {
                newForecastList.append(aForecast)
            }
        }
    }
    
    func inputDataValidated() -> Bool {
        
        let queryTrimmed = searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if queryTrimmed.isEmpty {
            return false
        }
        return true
    }
    
}

#Preview {
    GetWeatherForecast()
}
