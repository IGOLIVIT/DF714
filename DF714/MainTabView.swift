//
//  MainTabView.swift
//  DF714
//
//  Created by IGOR on 09/10/2025.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            RecipesView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "book.fill" : "book")
                    Text("Recipes")
                }
                .tag(0)
            
            NotesView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "note.text" : "note.text")
                    Text("Notes")
                }
                .tag(1)
            
            TimerView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "timer.circle.fill" : "timer.circle")
                    Text("Timer")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "gearshape.fill" : "gearshape")
                    Text("Settings")
                }
                .tag(3)
        }
        .accentColor(Color.tasteLogPrimary)
        .onAppear {
            // Customize tab bar appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(Color.tasteLogCardBackground)
            appearance.selectionIndicatorTintColor = UIColor(Color.tasteLogPrimary)
            
            // Normal state
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.tasteLogText.opacity(0.6))
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor(Color.tasteLogText.opacity(0.6))
            ]
            
            // Selected state
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.tasteLogPrimary)
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor(Color.tasteLogPrimary)
            ]
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(DataManager())
}

