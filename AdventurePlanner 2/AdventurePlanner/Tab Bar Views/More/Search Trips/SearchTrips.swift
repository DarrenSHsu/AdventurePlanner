//
//  SearchTrips.swift
//  AdventurePlanner
//
//  Created by Nicholas Luke Emig on 4/26/24.
//  Copyright © 2024 Nicholas Emig. All rights reserved.
//  Code snippets reused and modified from "SearchDatabase.swift" in te MusicALbums tutorial.
//  Original code snippets creator - Osman Balci
//

import SwiftUI

var searchCategory = ""
var searchQuery = ""
var maxPopulation = 0
var maxCovid = 0

struct SearchTrips: View {
    
    let searchCategoriesList = ["City Name", "Region", "Country", "Population"]
    @State private var selectedSearchCategoryIndex = 0
    @State private var searchCompleted = false
    @State private var showAlertMessage = false
    @State private var searchFieldValue = ""
    @State private var populationTextFieldValue = ""
    @State private var covidTextValue = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Select Search Category")) {
                    Picker("", selection: $selectedSearchCategoryIndex) {
                        ForEach(0 ..< searchCategoriesList.count, id: \.self) {
                            Text(searchCategoriesList[$0])
                        }
                    }
                }
                if selectedSearchCategoryIndex < 3 {
                    Section(header: Text("Search Query under Selected Category")) {
                        HStack {
                            TextField("Enter Search Query", text: $searchFieldValue)
                                .textFieldStyle(.roundedBorder)
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.none)
                            // Button to clear the text field
                            Button(action: {
                                searchFieldValue = ""
                            }) {
                                Image(systemName: "clear")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                            }
                        }   // End of HStack
                    }
                }
                
                if selectedSearchCategoryIndex == 3 {
                    Section(header: Text("Enter maximum population"), footer: Text("Return on keyboard after entering value.").italic()) {
                        HStack {
                            TextField("Enter Search Query", text: $populationTextFieldValue)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numbersAndPunctuation)
                                .onSubmit {
                                    if let intValue = Int(populationTextFieldValue) {
                                        maxPopulation = intValue
                                    } else {
                                        showAlertMessage = true
                                        alertTitle = "Unrecognized Population Value!"
                                        alertMessage = "Entered population value \(populationTextFieldValue) is not an integer number."
                                    }
                                }
                            // Button to clear the text field
                            Button(action: {
                                populationTextFieldValue = ""
                            }) {
                                Image(systemName: "clear")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                            }
                        }   // End of HStack
                    }
                }
                Section(header: Text("Search Trip Database")) {
                    HStack {
                        Spacer()
                        Button(searchCompleted ? "Search Completed" : "Search") {
                            if inputDataValidated() {
                                searchDB()
                                searchCompleted = true
                            } else {
                                showAlertMessage = true
                            }
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        Spacer()
                    }
                }
                if searchCompleted {
                    Section(header: Text("List Trips Found")) {
                        NavigationLink(destination: showSearchResults) {
                            HStack {
                                Image(systemName: "list.bullet")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                Text("List Trips Found")
                                    .font(.system(size: 16))
                            }
                            .foregroundColor(.blue)
                        }
                    }
                    Section(header: Text("Clear")) {
                        HStack {
                            Spacer()
                            Button("Clear") {
                                searchCompleted = false
                                searchFieldValue = ""
                                populationTextFieldValue = ""
                            }
                            .tint(.blue)
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                            Spacer()
                        }
                    }
                }
            }
            .font(.system(size: 14))
            .navigationTitle("Search Database")
            .toolbarTitleDisplayMode(.inline)
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                Button("OK") {}
            }, message: {
                Text(alertMessage)
            })
        }
    }
    
    /*
     ---------------------
     MARK: Search Database
     ---------------------
     */
    func searchDB() {
        
        searchCategory = searchCategoriesList[selectedSearchCategoryIndex]
        
        // Public function conductDatabaseSearch is given in DatabaseSearch.swift
        conductDatabaseSearch()
    }
    
    /*
     -------------------------
     MARK: Show Search Results
     -------------------------
     */
    var showSearchResults: some View {
        // Global array databaseSearchResults is given in DatabaseSearch.swift
        if databaseSearchResults.isEmpty {
            return AnyView(
                NotFound(message: "Database Search Produced No Results!\n\nThe database did not return any value for the given search query!")
            )
        }
        return AnyView(DBSearchResultsList())
    }
    
    /*
     ---------------------------
     MARK: Input Data Validation
     ---------------------------
     */
    func inputDataValidated() -> Bool {

        switch selectedSearchCategoryIndex {
        case 0,1,2:
            // Remove spaces, if any, at the beginning and at the end of the entered search query string
            let queryTrimmed = searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if (queryTrimmed.isEmpty) {
                alertTitle = "Empty Query"
                alertMessage = "Please enter a search query!"
                return false
            }
            searchQuery = queryTrimmed
            
        case 3:
            if (maxPopulation == 0) {
                alertTitle = "Missing Maximum Population"
                alertMessage = "Please enter valid values for the maximum population!"
                return false
            }
        default:
            print("Selected Index is out of range")
        }
        
        return true
    }
}
