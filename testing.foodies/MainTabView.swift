//
//  MainTabView.swift
//  testing.foodies
//
//  Created by William Peter Lu on 2025/11/19.
//

import SwiftUI

struct MainTabView: View {
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            AnalysisView()
                .tabItem {
                    Label("Analysis", systemImage: "chart.bar.fill")
                }
                .tag(1)
            
            GroupView()
                .tabItem {
                    Label("Group", systemImage: "person.3.fill")
                }
                .tag(2)
            
            PersonalView()
                .tabItem {
                    Label("Personal", systemImage: "person.crop.circle")
                }
                .tag(3)
            
            ShoppingView()
                .tabItem {
                    Label("Shopping", systemImage: "cart.fill")
                }
                .tag(4)
        }
    }
}

#Preview {
    MainTabView()
}

