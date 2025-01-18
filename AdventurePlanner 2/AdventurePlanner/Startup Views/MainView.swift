//
//  MainView.swift
//  AdventurePlanner
//
//  Created by Darren Hsu and Osman Balci on 4/20/24.
//  Copyright © 2024 Darren Hsu and Osman Balci. All rights reserved.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            DestinationList()
                .tabItem {
                    Label("Trips", systemImage: "photo")
                }
            SearchCity()
                .tabItem {
                    Label("Search Cities", systemImage: "square.grid.3x3")
                }
            NotesList()
                .tabItem {
                    Label("Notes", systemImage: "pencil.and.list.clipboard")
                }
            CovidChecker()
                .tabItem {
                    Label("Covid Check", systemImage: "person.wave.2.fill")
                }
            More()
                .tabItem {
                    Label("More", systemImage: "line.3.horizontal")
                }
        }   // End of TabView
        .onAppear {
            // Display TabView with opaque background
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}

#Preview {
    MainView()
}
