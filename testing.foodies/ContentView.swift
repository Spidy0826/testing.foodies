//
//  ContentView.swift
//  testing.foodies
//
//  Created by William Peter Lu on 2025/11/19.
//

import SwiftUI

struct ContentView: View {
    // @ObservedObject 觀察 AuthManager 的狀態
    // 當 isLoggedIn 改變時，視圖會自動更新
    @ObservedObject var authManager = AuthManager.shared
    
    var body: some View {
        // 根據登入狀態顯示不同的視圖
        if authManager.isLoggedIn {
            // 已登入：顯示主頁面
            HomeView()
        } else {
            // 未登入：顯示登入頁面
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
