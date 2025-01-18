//
//  NotesList.swift
//  AdventurePlanner
//
//  Created by Keming Liang on 4/29/24.
//  Copyright © 2024 Keming Liang. All rights reserved.
//

import SwiftUI
import SwiftData

struct NotesList: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<Note>(sortBy: [SortDescriptor(\Note.date, order: .forward)])) private var listOfNotesInDatabase: [Note]
    @Query(FetchDescriptor<Destination>(sortBy: [SortDescriptor(\Destination.name, order: .forward)])) private var listOfAllDestsInDatabase: [Destination]
    
    @State private var newNotesList = [Note]()
    @State private var searchFieldValue = ""
    @State private var searchCompleted = false
    @State private var showAlertMessage = false
    @State private var showConfirmation = false
    
    let searchCategories = ["All", "Date", "City Name", "Country Name", "Notes"]
    @State private var selectedCategoryIndex = 0
    
    var body: some View {
        NavigationStack {
            Form {
                HStack {
                    Section(header: Text("Search Category:")) {
                        Picker("", selection: $selectedCategoryIndex) {
                            ForEach(0 ..< searchCategories.count, id: \.self) {
                                Text(searchCategories[$0])
                            }
                        }
                    }
                }
                if selectedCategoryIndex == 1 || selectedCategoryIndex == 2 || selectedCategoryIndex == 3 || selectedCategoryIndex == 4 {
                    HStack {
                        Section(header: Text("")) {
                            TextField("Enter Search Query", text: $searchFieldValue)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                            
                            Button(action: {
                                searchCompleted = false
                                searchFieldValue = ""
                            }) {
                                Image(systemName: "clear")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                            }
                        }
                    }
                    HStack {
                        Section(header: Text("")) {
                            Spacer()
                            Button(searchCompleted ? "Search Completed" : "Search") {
                                if inputDataValidated() {
                                    searchCompleted = true
                                    if selectedCategoryIndex == 2 {
                                        cityFilter(searchQuery: searchFieldValue)
                                    }
                                    if selectedCategoryIndex == 3 {
                                        countryFilter(searchQuery: searchFieldValue)
                                    }
                                    if selectedCategoryIndex == 4 {
                                        noteFilter(searchQuery: searchFieldValue)
                                    }
                                }
                                else {
                                    showAlertMessage = true
                                    alertTitle = "Missing Input Data!"
                                    alertMessage = "Please enter a database search query!"
                                }
                            }
                            .tint(.blue)
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                            Spacer()
                        }
                    }
                }
                if selectedCategoryIndex == 0 {
                    ForEach(listOfNotesInDatabase, id: \.date) { aNote in
                        Section(header: Text(aNote.date)) {
                            Text(aNote.note)
                        }
                        .headerProminence(.increased)
                    }
                }
                if searchCompleted {
                    if selectedCategoryIndex == 1 {
                        ForEach(listOfNotesInDatabase, id: \.date) { aNote in
                            if aNote.date.contains(searchFieldValue) {
                                Section(header: Text(aNote.date)) {
                                    Text(aNote.note)
                                }
                                .headerProminence(.increased)
                            }
                        }
                    }
                
                    if selectedCategoryIndex == 2 || selectedCategoryIndex == 3 || selectedCategoryIndex == 4 {
                        ForEach(newNotesList, id: \.date) { aNote in
                            Section(header: Text(aNote.date)) {
                                Text(aNote.note)
                            }
                            .headerProminence(.increased)
                        }
                    }
                }
            }
            .font(.system(size: 14))
            .navigationTitle("Notes List")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: AddNote()) {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                Button("OK") {}
            }, message: {
                Text(alertMessage)
            })
        }
    }
    
    func inputDataValidated() -> Bool {
        
        let queryTrimmed = searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if queryTrimmed.isEmpty {
            return false
        }
        return true
    }
    
    func cityFilter(searchQuery: String) {
        newNotesList = [Note]()
        for aNote in listOfNotesInDatabase {
            for aDest in listOfAllDestsInDatabase {
                if aNote.id == aDest.id {
                    if aDest.city.contains(searchQuery) {
                        newNotesList.append(aNote)
                    }
                }
            }
        }
    }
    
    func countryFilter(searchQuery: String) {
        newNotesList = [Note]()
        for aNote in listOfNotesInDatabase {
            for aDest in listOfAllDestsInDatabase {
                if aNote.id == aDest.id {
                    if aDest.country.contains(searchQuery) {
                        newNotesList.append(aNote)
                    }
                }
            }
        }
    }
    
    func noteFilter(searchQuery: String) {
        newNotesList = [Note]()
        for aNote in listOfNotesInDatabase {
            if aNote.note.contains(searchQuery) {
                newNotesList.append(aNote)
            }
        }
    }
}

#Preview {
    NotesList()
}
