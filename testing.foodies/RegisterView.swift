//
//  RegisterView.swift
//  testing.foodies
//
//  Created by William Peter Lu on 2025/11/19.
//

import SwiftUI

struct RegisterView: View {
    // 用於導航回登入頁面
    @Environment(\.dismiss) var dismiss
    
    // 狀態變數
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var isConfirmPasswordVisible: Bool = false
    @State private var errorMessage: String = ""
    
    // 使用 AuthManager 來處理註冊
    @ObservedObject var authManager = AuthManager.shared
    
    var body: some View {
        ZStack {
            // 背景漸層（與登入頁面相同的風格）
            LinearGradient(
                colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    // 標題區域
                    VStack(spacing: 15) {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .font(.system(size: 70))
                            .foregroundColor(.white)
                        
                        Text("建立新帳號")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("開始你的健康追蹤之旅")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.top, 40)
                    
                    // 表單區域
                    VStack(spacing: 20) {
                        // 姓名輸入框
                        VStack(alignment: .leading, spacing: 8) {
                            Text("姓名")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.9))
                            
                            TextField("請輸入您的姓名", text: $name)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        // 電子郵件輸入框
                        VStack(alignment: .leading, spacing: 8) {
                            Text("電子郵件")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.9))
                            
                            TextField("請輸入電子郵件", text: $email)
                                .textFieldStyle(CustomTextFieldStyle())
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                        }
                        
                        // 密碼輸入框
                        VStack(alignment: .leading, spacing: 8) {
                            Text("密碼")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.9))
                            
                            HStack {
                                if isPasswordVisible {
                                    TextField("請輸入密碼（至少 6 個字元）", text: $password)
                                        .textFieldStyle(CustomTextFieldStyle())
                                } else {
                                    SecureField("請輸入密碼（至少 6 個字元）", text: $password)
                                        .textFieldStyle(CustomTextFieldStyle())
                                }
                                
                                Button(action: {
                                    isPasswordVisible.toggle()
                                }) {
                                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                        }
                        
                        // 確認密碼輸入框
                        VStack(alignment: .leading, spacing: 8) {
                            Text("確認密碼")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.9))
                            
                            HStack {
                                if isConfirmPasswordVisible {
                                    TextField("請再次輸入密碼", text: $confirmPassword)
                                        .textFieldStyle(CustomTextFieldStyle())
                                } else {
                                    SecureField("請再次輸入密碼", text: $confirmPassword)
                                        .textFieldStyle(CustomTextFieldStyle())
                                }
                                
                                Button(action: {
                                    isConfirmPasswordVisible.toggle()
                                }) {
                                    Image(systemName: isConfirmPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                        }
                        
                        // 錯誤訊息顯示
                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .font(.system(size: 14))
                                .foregroundColor(.red)
                                .padding(.horizontal)
                                .multilineTextAlignment(.center)
                        }
                        
                        // 註冊按鈕
                        Button(action: {
                            handleRegister()
                        }) {
                            Text("註冊")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.3))
                                )
                        }
                        .padding(.top, 10)
                        
                        // 返回登入連結
                        HStack {
                            Text("已經有帳號了？")
                                .foregroundColor(.white.opacity(0.8))
                            Button("返回登入") {
                                dismiss() // 關閉當前視圖，返回上一頁
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
        }
    }
    
    // 處理註冊邏輯
    private func handleRegister() {
        // 清除之前的錯誤訊息
        errorMessage = ""
        
        // 驗證所有欄位都已填寫
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "請填寫所有欄位"
            return
        }
        
        // 驗證密碼長度
        guard password.count >= 6 else {
            errorMessage = "密碼長度至少需要 6 個字元"
            return
        }
        
        // 驗證密碼是否一致
        guard password == confirmPassword else {
            errorMessage = "兩次輸入的密碼不一致"
            return
        }
        
        // 簡單的電子郵件格式驗證
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "請輸入有效的電子郵件地址"
            return
        }
        
        // 使用 AuthManager 處理註冊
        authManager.register(name: name, email: email, password: password)
        
        // 註冊成功後，關閉註冊頁面
        // AuthManager 會自動更新 isLoggedIn 狀態，ContentView 會自動切換到主頁面
        dismiss()
    }
}

#Preview {
    RegisterView()
}

