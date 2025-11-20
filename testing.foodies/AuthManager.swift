//
//  AuthManager.swift
//  testing.foodies
//
//  Created by William Peter Lu on 2025/11/19.
//

import Foundation
import SwiftUI
import Combine  // 必需！@Published 和 ObservableObject 都需要這個框架

// 認證管理器 - 使用 ObservableObject 來管理全域登入狀態
// 類似 React 的 Context 或 Redux 的 Store
class AuthManager: ObservableObject {
    // @Published 讓所有觀察這個物件的視圖在 isLoggedIn 改變時自動更新
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: String = ""
    
    // 單例模式（Singleton）- 確保整個應用程式只有一個 AuthManager 實例
    static let shared = AuthManager()
    
    private init() {
        // 檢查是否有儲存的登入狀態（實際應用中應該從 UserDefaults 或 Keychain 讀取）
        // 這裡為了示範，我們預設為未登入
        isLoggedIn = false
    }
    
    // 登入函數
    func login(email: String, password: String) {
        // TODO: 實作實際的登入邏輯（API 呼叫等）
        // 這裡只是示範，實際應用中應該：
        // 1. 呼叫後端 API 驗證帳號密碼
        // 2. 儲存 token 或 session
        // 3. 更新 isLoggedIn 狀態
        
        // 簡單的示範驗證
        if !email.isEmpty && !password.isEmpty {
            currentUser = email
            isLoggedIn = true
            print("登入成功: \(email)")
        }
    }
    
    // 註冊函數
    func register(name: String, email: String, password: String) {
        // TODO: 實作實際的註冊邏輯（API 呼叫等）
        // 這裡只是示範
        print("註冊成功: \(name), \(email)")
        
        // 註冊成功後自動登入
        currentUser = email
        isLoggedIn = true
    }
    
    // 登出函數
    func logout() {
        isLoggedIn = false
        currentUser = ""
        // TODO: 清除儲存的 token 或 session
        print("已登出")
    }
}

