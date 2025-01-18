//
//  AddNote.swift
//  AdventurePlanner
//
//  Created by Keming Liang on 4/29/24.
//  Copyright © 2024 Keming Liang. All rights reserved.
//

import SwiftUI
import SwiftData

struct AddNote: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<Destination>(sortBy: [SortDescriptor(\Destination.city, order: .forward)])) private var listOfAllDestsInDatabase: [Destination]
    
    @State private var selectedIndex = 0
    @State private var noteFieldValue = ""
    @State private var date = Date()
    @State private var textEntered = false
    @State private var showAlertMessage = false
    @State private var showConfirmation = false
    
    var dateClosedRange: ClosedRange<Date> {
        let minDate = Calendar.current.date(byAdding: .year, value: -20, to: Date())!
        
        let maxDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())!
        return minDate...maxDate
    }
    
    var body: some View {
        Form {
            Section(header: Text("Select a City")) {
                Picker("", selection: $selectedIndex) {
                    ForEach(0 ..< listOfAllDestsInDatabase.count, id: \.self) {
                        Text(listOfAllDestsInDatabase[$0].city)
                    }
                }
            }
            Section(header: Text("Note"), footer: HStack { Button(action: { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)}) {
                Image(systemName: "keyboard")
                    .font(Font.title.weight(.light))
                    .foregroundColor(.blue)
                }
                                       
                Button(action: {
                    noteFieldValue = ""
                    textEntered = false
                }) {
                    Image(systemName: "multiply.circle")
                        .font(Font.title.weight(.light))
                        .foregroundColor(.blue)
                }
                                       
            }
            ) {
                TextEditor(text: $noteFieldValue)
                    .frame(height: 100)
                    .font(.custom("Helvetica", size: 14))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
            }
            Section(header: Text("Upload Date")) {
                DatePicker(
                    selection: $date,
                    in: dateClosedRange,
                    displayedComponents: .date) {
                        Text("Upload Date")
                    }
            }
        }
        .font(.system(size: 14))
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .navigationTitle("Add New Note")
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    if inputDataValidated() {
                        saveNewNote()
                        
                        showAlertMessage = true
                        alertTitle = "New Note Saved!"
                        alertMessage = "Your new note is successfully saved in the database!"
                    } else {
                        showAlertMessage = true
                        alertTitle = "Missing Input Data!"
                        alertMessage = "All input data must be provided!"
                    }
                }
            }
        }
        .alert(alertTitle, isPresented: $showAlertMessage, actions: {
            Button("OK") {
                if alertTitle == "New Note Saved!" {
                    dismiss()
                }
            }
        }, message: {
            Text(alertMessage)
        })
    }
    
    func inputDataValidated() -> Bool {
        
        if noteFieldValue.isEmpty {
            return false
        }
        
        return true
    }
    
    func saveNewNote() {
        
        let cityId = listOfAllDestsInDatabase[selectedIndex].id
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd' at 'HH:mm:ss"
        let uploadDateString = dateFormatter.string(from: date)
        
        let newNote = Note(id: cityId, note: noteFieldValue, date: uploadDateString)
        
        modelContext.insert(newNote)
    }
}

#Preview {
    AddNote()
}
