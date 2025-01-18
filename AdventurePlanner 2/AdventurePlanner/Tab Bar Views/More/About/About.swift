//
//  About.swift
//  AdventurePlanner
//
//  Created by Keming Liang on 4/24/24.
//  Copyright © 2024 Keming Liang. All rights reserved.
//

import SwiftUI

struct About: View {
    
    @State private var developersList = ["Nicholas Emig", "Darren Hsu", "Keming Liang"]
    @State private var selectedDeveloper = 0
    @State private var phoneNumbersList = ["(845) 418-7614", "(714) 206-8560", "(540) 998-8112"]
    @State private var emailsList = ["nemig@vt.edu", "darrenhsu@vt.edu", "keming@vt.edu"]
    @State private var showAlertMessage = false
    
    var body: some View {
        Text("Please contact us by phone or email if you have any problems about this application!")
            .font(.system(size: 18, weight: .light, design: .serif))
            .italic()
            .multilineTextAlignment(.center)
            .padding()
        Form {
            Section(header: Text("Developer")) {
                Picker("", selection: $selectedDeveloper) {
                    ForEach(0 ..< developersList.count, id:\.self) {
                        Text(developersList[$0])
                    }
                }
            }
            Section(header: Text("\(developersList[selectedDeveloper])'s Phone Number")) {
                HStack {
                    Image(systemName: "phone")
                        .imageScale(.medium)
                        .font(Font.title.weight(.light))
                        .foregroundColor(Color.blue)
                    
                    Link(phoneNumbersList[selectedDeveloper], destination: URL(string: phoneNumberToCall(phoneNumber: phoneNumbersList[selectedDeveloper]))!)
                }
                .contextMenu {
                    Link(destination: URL(string: phoneNumberToCall(phoneNumber: phoneNumbersList[selectedDeveloper]))!) {
                        Image(systemName: "phone")
                        Text("Call")
                    }
                    
                    Button(action: {
                        UIPasteboard.general.string = phoneNumbersList[selectedDeveloper]
                        
                        showAlertMessage = true
                        alertTitle = "Phone Number is Copied to Clipboard"
                        alertMessage = "You can paste it on your iPhone, iPad, Mac laptop or Mac desktop each running under your Apple ID"
                    }) {
                        Image(systemName: "doc.on.doc")
                        Text("Copy Phone Number")
                    }
                }
            }
            
            Section(header: Text("\(developersList[selectedDeveloper])'s Email Address")) {
                HStack {
                    Image(systemName: "envelope")
                        .imageScale(.medium)
                        .font(Font.title.weight(.light))
                        .foregroundColor(Color.blue)
                    
                    Link(emailsList[selectedDeveloper], destination: URL(string: "mailto:\(emailsList[selectedDeveloper])")!)
                }
                .contextMenu {
                    Link(destination: URL(string: "mailto:\(emailsList[selectedDeveloper])")!) {
                        Image(systemName: "envelope")
                        Text("Send Email")
                    }
                    
                    Button(action: {
                        UIPasteboard.general.string = emailsList[selectedDeveloper]
                        
                        showAlertMessage = true
                        alertTitle = "Email Address is Copied to Clipboard"
                        alertMessage = "You can paste it on your iPhone, iPad, Mac laptop or Mac desktop each running under your Apple ID"
                    }) {
                        Image(systemName: "doc.on.doc")
                        Text("Copy Email Address")
                    }
                }
            }
        }
        .font(.system(size: 14))
        .navigationTitle("About")
        .toolbarTitleDisplayMode(.inline)
        .alert(alertTitle, isPresented: $showAlertMessage, actions: {
            Button("OK") {}
        }, message: {
            Text(alertMessage)
        })
    }
    
    func phoneNumberToCall(phoneNumber: String) -> String {
        
        let cleaned1 = phoneNumber.replacingOccurrences(of: " ", with: "")
        let cleaned2 = cleaned1.replacingOccurrences(of: "(", with: "")
        let cleaned3 = cleaned2.replacingOccurrences(of: ")", with: "")
        let cleanedNumber = cleaned3.replacingOccurrences(of: "-", with: "")
                
        return "tel:" + cleanedNumber
    }
}

#Preview {
    About()
}
