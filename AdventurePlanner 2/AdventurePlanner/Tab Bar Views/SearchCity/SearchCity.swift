//
//  SearchCity.swift
//  AdventurePlanner
//
//  Created by Darren Hsu on 4/24/24.
//  Copyright © 2024 Darren Hsu. All rights reserved.
//

import SwiftUI

//Global Search Parameters
var populationMin = 0
var populationMax = 0
var latitude = 0.0
var longtitude = 0.0

struct SearchCity: View {
    
    let searchCategories = ["Location", "Country Code", "Population", "Name Prefix"]
    @State private var selectedIndex = 3
    
    @State private var searchFieldValue = ""
    @State private var searchCompleted = false
    @State private var showAlertMessage = false
    
    @State private var populationMinTextFieldValue = ""
    @State private var populationMaxTextFieldValue = ""
    
    @State private var latitudeTextFieldValue = ""
    @State private var longtitudeTextFieldValue = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Image("GeoCitiesApiLogo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 50)
                        Spacer()
                    }
                }
                Section(header: Text("Select Search Category")) {
                    Picker("", selection: $selectedIndex) {
                        ForEach(0 ..< searchCategories.count, id: \.self) {
                            Text(searchCategories[$0])
                        }
                    }
                }
                if (selectedIndex == 0) {
                    Section(header: Text("Location (Latitude / Longtitude"), footer: Text("Return on keyboard after entering value.").italic()) {
                        HStack {
                            TextField("Enter Latitude", text: $latitudeTextFieldValue)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numbersAndPunctuation)
                                .onSubmit {
                                    if let intValue = Double(latitudeTextFieldValue) {
                                        latitude = intValue
                                    } else {
                                        showAlertMessage = true
                                        alertTitle = "Unrecognized Latitude!"
                                        alertMessage = "Entered population value \(latitudeTextFieldValue) is not an decimal number."
                                    }
                                }
                            
                            // Button to clear the text field
                            Button(action: {
                                latitudeTextFieldValue = ""
                                searchCompleted = false
                            }) {
                                Image(systemName: "clear")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                            }
                        }
                        HStack {
                            TextField("Enter Longtitude", text: $longtitudeTextFieldValue)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numbersAndPunctuation)
                                .onSubmit {
                                    if let intValue = Double(longtitudeTextFieldValue) {
                                        longtitude = intValue
                                    } else {
                                        showAlertMessage = true
                                        alertTitle = "Unrecognized Longtitude!"
                                        alertMessage = "Entered population value \(longtitudeTextFieldValue) is not an decimal number."
                                    }
                                }
                            
                            // Button to clear the text field
                            Button(action: {
                                longtitudeTextFieldValue = ""
                                searchCompleted = false
                            }) {
                                Image(systemName: "clear")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                            }
                        }
                    }
                }
                else if (selectedIndex == 2) {
                    Section(header: Text("≤ Population ≤"), footer: Text("Return on keyboard after entering value.").italic()) {
                        HStack {
                            TextField("Enter minimum population", text: $populationMinTextFieldValue)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numbersAndPunctuation)
                                .onSubmit {
                                    if let intValue = Int(populationMinTextFieldValue) {
                                        populationMin = intValue
                                    } else {
                                        showAlertMessage = true
                                        alertTitle = "Unrecognized Population!"
                                        alertMessage = "Entered population value \(populationMinTextFieldValue) is not an integer number."
                                    }
                                }
                            
                            // Button to clear the text field
                            Button(action: {
                                populationMinTextFieldValue = ""
                                searchCompleted = false
                            }) {
                                Image(systemName: "clear")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                            }
                        }
                        HStack {
                            TextField("Enter maximum population", text: $populationMaxTextFieldValue)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numbersAndPunctuation)
                                .onSubmit {
                                    if let intValue = Int(populationMaxTextFieldValue) {
                                        populationMax = intValue
                                    } else {
                                        showAlertMessage = true
                                        alertTitle = "Unrecognized Population!"
                                        alertMessage = "Entered population value \(populationMaxTextFieldValue) is not an integer number."
                                    }
                                }
                            
                            // Button to clear the text field
                            Button(action: {
                                populationMaxTextFieldValue = ""
                                searchCompleted = false
                            }) {
                                Image(systemName: "clear")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                            }
                        }
                    }
                }
                else {
                    Section(header: Text("Enter a \(searchCategories[selectedIndex])")) {
                        HStack {
                            TextField("Enter Search Query", text: $searchFieldValue)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disableAutocorrection(true)
                            
                            // Button to clear the text field
                            Button(action: {
                                searchFieldValue = ""
                                showAlertMessage = false
                                searchCompleted = false
                            }) {
                                Image(systemName: "clear")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                            }
                            
                        }   // End of HStack
                    }
                }
                
                Section(header: Text("Search Cities")) {
                    HStack {
                        Spacer()
                        Button(searchCompleted ? "Search Completed" : "Search") {
                            if inputDataValidated(index: selectedIndex) {
                                searchApi()
                                searchCompleted = true
                            } else {
                                showAlertMessage = true
                                alertTitle = "Missing Input Data!"
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
                    Section(header: Text("List Cities Found")) {
                        NavigationLink(destination: showSearchResults) {
                            HStack {
                                Image(systemName: "list.bullet")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                Text("List Cities Found")
                                    .font(.system(size: 16))
                            }
                            .foregroundColor(.blue)
                        }
                    }
                }
                
            }   // End of Form
            .navigationTitle("Search Any City in the World")
            .toolbarTitleDisplayMode(.inline)
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                Button("OK") {}
            }, message: {
                Text(alertMessage)
            })
            
        }   // End of NavigationStack
        
    }   // End of body var
    
    /*
     ----------------
     MARK: Search API
     ----------------
     */
    func searchApi() {
        var apiUrlString = ""
        
        citiesList = [CityStruct]()
        
        let queryTrimmed = searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines).lowercased().replacingOccurrences(of: " ", with: "%20")
        
        switch searchCategories[selectedIndex] {
        case "Location":
            apiUrlString = "https://wft-geo-db.p.rapidapi.com/v1/geo/cities?location=\(latitude)\(longtitude)"
        case "Country Code":
            apiUrlString = "https://wft-geo-db.p.rapidapi.com/v1/geo/cities?countryIds=\(queryTrimmed)"
        case "Population":
            apiUrlString = "https://wft-geo-db.p.rapidapi.com/v1/geo/cities?minPopulation=\(populationMin)&maxPopulation=\(populationMax)"
        case "Name Prefix":
            apiUrlString = "https://wft-geo-db.p.rapidapi.com/v1/geo/cities?namePrefix=\(queryTrimmed)"
        default:
            fatalError("Search category is out of range!")
        }
        
        searchCityApi(apiUrl: apiUrlString)
    }
    
    /*
     -------------------------
     MARK: Show Search Results
     -------------------------
     */
    var showSearchResults: some View {
        
        if citiesList.isEmpty {
            return AnyView(
                NotFound(message: "No City Found!\n\nThe search query did not return any city from the API! Please enter another search query.")
            )
        }
        
        return AnyView(FoundCitiesList())
    }
    
    /*
     ---------------------------
     MARK: Input Data Validation
     ---------------------------
     */
    func inputDataValidated(index: Int) -> Bool {
        
        if (index != 0 && index != 2 ) {
            // Remove spaces, if any, at the beginning and at the end of the entered search query string
            let queryTrimmed = searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
            print(selectedIndex)
            
            if queryTrimmed.isEmpty {
                return false
            }
        }
        else if (index == 0) {
            // Remove spaces, if any, at the beginning and at the end of the entered search query string
            var queryTrimmed = latitudeTextFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
            print("2")
            if queryTrimmed.isEmpty {
                return false
            }
            queryTrimmed = longtitudeTextFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if queryTrimmed.isEmpty {
                return false
            }

        }
        else {
            // Remove spaces, if any, at the beginning and at the end of the entered search query string
            var queryTrimmed = populationMinTextFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
            print("3")
            if queryTrimmed.isEmpty {
                return false
            }
            queryTrimmed = populationMaxTextFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if queryTrimmed.isEmpty {
                return false
            }

        }
        return true
    }
    
}


