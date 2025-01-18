//
//  CovidChecker.swift
//  AdventurePlanner
//
//  Created by Darren Hsu on 4/24/24.
//  Copyright © 2024 Darren Hsu. All rights reserved.
//

import SwiftUI

struct CovidChecker: View {
    
    //--------------
    // Progress View
    //--------------
    @State private var showProgressView = false
    
    //Seperate variable for this covidDataList for the filter function
    @State private var thisCovidDataList = covidDataList
    
    @State private var showAlertMessage = false
    
    @State private var searchFieldValue = ""
    @State private var searchCompleted = false
    
    var body: some View {
        
        return AnyView(
            NavigationStack {
                Section(header: Text("Covid Checker")
                    .bold()) {
                    VStack {
                        HStack {
                            HStack {
                                Spacer()
                                Spacer()
                                TextField("Enter Filter Text", text: $searchFieldValue)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                
                                // Button to clear the text field
                                Button(action: {
                                    searchCompleted = false
                                    searchFieldValue = ""
                                }) {
                                    Image(systemName: "clear")
                                        .imageScale(.medium)
                                        .font(Font.title.weight(.regular))
                                }
                            }
                            Button("Filter") {
                                if (inputDataValidated()) {
                                    showProgressView = true
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        /*
                                         Execute the following code after 0.1 second of delay
                                         so that they are not executed during the view update.
                                         */
                                        filterList(searchQuery: searchFieldValue)
                                        
                                        // API search is completed
                                        showProgressView = false
                                        searchCompleted = true
                                    }
                                }
                                else {
                                    showAlertMessage = true
                                    alertTitle = "Missing Input Data!"
                                    alertMessage = "Please enter a filter query!"
                                }
                            }
                            .tint(.blue)
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                        }
                    }
                    Button("Refresh List") {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            /*
                             Execute the following code after 0.1 second of delay
                             so that they are not executed during the view update.
                             */
                            getCovidData()
                            thisCovidDataList = covidDataList
                        }
                    }
                    .tint(.blue)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                }
                if (showProgressView) {
                    ProgressView()
                }
                List {
                    if (thisCovidDataList.count > 0) {
                        ForEach(thisCovidDataList, id: \.self) { aCovidData in
                            NavigationLink(destination: CovidDetails(covid: aCovidData)) {
                                CovidItem(aCovidData: aCovidData)
                            }
                        }
                    }
                    else {
                        Text("Unable to find matching country. Please try again.")
                    }
        
                }
            }   // End of Stack
                .font(.system(size: 14))
                .navigationTitle("Covid Checker")
                .toolbarTitleDisplayMode(.inline)
                .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                    Button("OK") {}
                }, message: {
                    Text(alertMessage)
                })
            
        )   // End of AnyView
    }   // End of body var

    /*
    ------------------
    MARK: Search API
    ------------------
    */
    func filterList(searchQuery: String) {
        //Trim the query
        let queryTrimmed = searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        //Initilize the list
        thisCovidDataList = [CovidData]()
        
        //Pick out matching entries and add to this list
        for aCovidData in covidDataList {
            if (aCovidData.country.lowercased().contains(queryTrimmed)) {
                thisCovidDataList.append(aCovidData)
                
            }
        }
    }
    /*
     ---------------------------
     MARK: Input Data Validation
     ---------------------------
     */
    func inputDataValidated() -> Bool {
        
        let queryTrimmed = searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if queryTrimmed.isEmpty {
            return false
        }
        return true
    }
    
}
