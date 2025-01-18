//
//  ContentView.swift
//  AdventurePlanner
//
//  Created by Darren Hsu on 4/20/24.
//  Copyright © 2024 Darren Hsu. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    
    @State private var userAuthenticated = false
    
    var body: some View {
        
        if userAuthenticated {
            // Foreground View
            MainView()
        } else {
            ZStack {
                // Background View
                LoginView(canLogin: $userAuthenticated)
            }
        }
    }
}
