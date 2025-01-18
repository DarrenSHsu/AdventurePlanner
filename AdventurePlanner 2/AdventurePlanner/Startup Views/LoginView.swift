//
//  LoginView.swift
//  PhotosVideos
//
//  Created by Nicholas Luke Emig on 4/28/24.
//  Copyright © 2024 Nicholas Emig. All rights reserved.
//  Reused and modified code snippets from original creator Osman Balci.
//

import SwiftUI
import SwiftData

struct LoginView : View {
    
    // Binding Input Parameter
    @Binding var canLogin: Bool
    
    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<Destination>(sortBy: [SortDescriptor(\Destination.name, order: .forward)])) private var listOfDestinationsInDatabase: [Destination]
    
    // State Variables
    @State private var enteredPassword = ""
    @State private var showAlertMessage = false
    
    @State private var index = 0
    /*
     Create a timer publisher that fires 'every' 3 seconds and updates the view.
     It runs 'on' the '.main' runloop so that it can update the view.
     It runs 'in' the '.common' mode so that it can run alongside other
     common events such as when the ScrollView is being scrolled.
     */
    @State private var timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            // Background View
            ZStack {
                Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
                
            // Foreground View
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Image("logo")
                        .resizable()
                        .padding()
                    if !listOfDestinationsInDatabase[index].destPhotos!.isEmpty {
                        getImageFromDocumentDirectory(filename: listOfDestinationsInDatabase[index].destPhotos![0].photoFullFilename.components(separatedBy: ".")[0],
                                                      fileExtension: listOfDestinationsInDatabase[index].destPhotos![0].photoFullFilename.components(separatedBy: ".")[1],
                                                      defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                        .padding(.horizontal)
                    
                        // Subscribe to the timer publisher
                        .onReceive(timer) { _ in
                            index += 1
                            if index > listOfDestinationsInDatabase.count - 1 {
                                index = 0
                            }
                        }
                    }
                    else {
                        // This function is given in UtilityFunctions.swift
                        getImageFromUrl(url: "https://flagcdn.com/w320//\(listOfDestinationsInDatabase[index].countryCode.lowercased()).png", defaultFilename: "ImageUnavailable")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                            .padding(.horizontal)
                        
                            // Subscribe to the timer publisher
                            .onReceive(timer) { _ in
                                index += 1
                                if index > listOfDestinationsInDatabase.count - 1 {
                                    index = 0
                                }
                            }
                    }
                    
                    Text(listOfDestinationsInDatabase[index].name)
                        .font(.system(size: 24, weight: .light, design: .serif))
                        .padding(.bottom)
                    
                    SecureField("Password", text: $enteredPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 300, height: 36)
                        .padding()
                    
                    HStack {
                        Button("Login") {
                            /*
                             UserDefaults provides an interface to the user’s defaults database,
                             where you store key-value pairs persistently across launches of your app.
                             */
                            // Retrieve the password from the user’s defaults database under the key "Password"
                            let validPassword = UserDefaults.standard.string(forKey: "Password")
                            
                            /*
                             If the user has not yet set a password, validPassword = nil
                             In this case, allow the user to login.
                             */
                            if validPassword == nil || enteredPassword == validPassword {
                                canLogin = true
                            } else {
                                showAlertMessage = true
                                alertTitle = "Invalid Password!"
                                alertMessage = "Please enter a valid password to unlock the app!"
                            }
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        .padding()
                        
                        if UserDefaults.standard.string(forKey: "SecurityQuestion") != nil {
                            NavigationLink(destination: ResetPassword()) {
                                Text("Forgot Password")
                            }
                            .tint(.blue)
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                            .padding()
                        }
                    }   // End of HStack
                    
                    /*
                     *********************************************************
                     *   Biometric Authentication with Face ID or Touch ID   *
                     *********************************************************
                     */
                    
                    // Enable biometric authentication only if a password has already been set
                    if UserDefaults.standard.string(forKey: "Password") != nil {
                        Button("Use Face ID or Touch ID") {
                            // authenticateUser() is given in UserAuthentication
                            authenticateUser() { status in
                                switch (status) {
                                case .Success:
                                    canLogin = true
                                case .Failure:
                                    canLogin = false
                                    showAlertMessage = true
                                    alertTitle = "Unable to Authenticate!"
                                    alertMessage = "Something went wrong and authentication failed."
                                case .Unavailable:
                                    canLogin = false
                                    showAlertMessage = true
                                    alertTitle = "Unable to Use Biometric Authentication!"
                                    alertMessage = "Your device does not support biometric authentication!"
                                }
                            }
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        
                        HStack {
                            Image(systemName: "faceid")
                                .font(.system(size: 40))
                                .padding()
                            Image(systemName: "touchid")
                                .font(.system(size: 40))
                                .padding()
                        }
                    }
                }   // End of VStack
            }   // End of ScrollView
            .onAppear() {
                startTimer()
            }
            .onDisappear() {
                stopTimer()
            }
                
            }   // End of ZStack
            .navigationBarHidden(true)
            
        }   // End of NavigationStack
        .alert(alertTitle, isPresented: $showAlertMessage, actions: {
              Button("OK") {}
            }, message: {
              Text(alertMessage)
            })
        
    }   // End of body var
    
    func startTimer() {
        timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    }
    
    func stopTimer() {
        timer.upstream.connect().cancel()
    }
    
}

