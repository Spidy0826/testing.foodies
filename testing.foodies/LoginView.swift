//
//  LoginView.swift
//  testing.foodies
//
//  Created by William Peter Lu on 2025/11/19.
//

import SwiftUI

struct LoginView: View {
    // @State 類似於 React 的 useState，用來管理視圖的狀態
    // 當這些值改變時，SwiftUI 會自動重新渲染視圖
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var showingRegister = false // 控制是否顯示註冊頁面
    
    // @ObservedObject 用來觀察 AuthManager 的狀態變化
    @ObservedObject var authManager = AuthManager.shared
    
    var body: some View {
        // VStack = Vertical Stack，類似 HTML 的 <div> 加上 flex-direction: column
        // HStack = Horizontal Stack，類似 flex-direction: row
        // ZStack = 層疊視圖，類似 position: absolute 的層疊
        
        ZStack {
            // 背景漸層（類似 CSS 的 linear-gradient）
            LinearGradient(
                colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea() // 讓背景延伸到安全區域外
            
            // 主要內容容器
            VStack(spacing: 30) { // spacing 類似 CSS 的 gap
                
                // Logo 和標題區域
                VStack(spacing: 15) {
                    // SF Symbols 圖標（Apple 提供的圖標庫）
                    Image(systemName: "fork.knife.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                    
                    Text("Foodie's")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("追蹤你的每一餐")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.top, 60)
                
                Spacer() // 類似 CSS 的 flex: 1，用來推開元素
                
                // 登入表單區域
                VStack(spacing: 20) {
                    // 電子郵件輸入框
                    VStack(alignment: .leading, spacing: 8) {
                        Text("電子郵件")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                        
                        // TextField 類似 HTML 的 <input type="text">
                        TextField("請輸入電子郵件", text: $email)
                            .textFieldStyle(CustomTextFieldStyle())
                            .autocapitalization(.none) // 不自動大寫
                            .keyboardType(.emailAddress) // 設定鍵盤類型
                    }
                    
                    // 密碼輸入框
                    VStack(alignment: .leading, spacing: 8) {
                        Text("密碼")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                        
                        // HStack 用來水平排列元素
                        HStack {
                            // SecureField 類似 <input type="password">
                            if isPasswordVisible {
                                TextField("請輸入密碼", text: $password)
                                    .textFieldStyle(CustomTextFieldStyle())
                            } else {
                                SecureField("請輸入密碼", text: $password)
                                    .textFieldStyle(CustomTextFieldStyle())
                            }
                            
                            // 顯示/隱藏密碼按鈕
                            Button(action: {
                                isPasswordVisible.toggle() // toggle() 在 true/false 之間切換
                            }) {
                                Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                    }
                    
                    // 忘記密碼連結
                    HStack {
                        Spacer()
                        Button("忘記密碼？") {
                            // TODO: 實作忘記密碼功能
                        }
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.8))
                    }
                    
                    // 登入按鈕
                    Button(action: {
                        handleLogin()
                    }) {
                        Text("登入")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity) // 類似 width: 100%
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.3))
                            )
                    }
                    .padding(.top, 10)
                    
                    // 註冊連結
                    HStack {
                        Text("還沒有帳號？")
                            .foregroundColor(.white.opacity(0.8))
                        Button("立即註冊") {
                            showingRegister = true
                        }
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    }
                    .font(.system(size: 14))
                    .padding(.top, 10)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
        }
        .sheet(isPresented: $showingRegister) {
            // 顯示註冊頁面（類似 modal）
            RegisterView()
        }
    }
    
    // 處理登入邏輯
    private func handleLogin() {
        // 簡單的驗證（為了方便測試，暫時允許空值登入）
        // 實際應用中應該有完整的驗證邏輯
        if email.isEmpty {
            email = "test@example.com" // 如果為空，使用預設值方便測試
        }
        if password.isEmpty {
            password = "test123" // 如果為空，使用預設值方便測試
        }
        
        // 使用 AuthManager 處理登入
        // 這會自動設置 isLoggedIn = true，觸發 ContentView 切換到 HomeView
        authManager.login(email: email, password: password)
    }
}

// 自訂文字輸入框樣式（類似 CSS 的 class）
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(15)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.2))
            )
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
    }
}

// 預覽（在 Xcode 中可以看到即時預覽）
#Preview {
    LoginView()
}

