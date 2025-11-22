//
//  HomeView.swift
//  testing.foodies
//
//  Created by William Peter Lu on 2025/11/19.
//

import SwiftUI

// 餐點資料模型
struct Meal: Identifiable {
    let id: UUID
    let name: String
    let time: String
    let calories: Int
    let imageName: String // SF Symbols 圖標名稱
    let image: UIImage? // 實際拍攝的圖片（可選）
    
    // 便利初始化器（向後兼容）
    init(id: UUID = UUID(), name: String, time: String, calories: Int, imageName: String, image: UIImage? = nil) {
        self.id = id
        self.name = name
        self.time = time
        self.calories = calories
        self.imageName = imageName
        self.image = image
    }
}

// 目標設定模型
struct Goal {
    var dailyCalories: Int = 2000
    var protein: Int = 150 // 克
    var carbs: Int = 250 // 克
    var fat: Int = 65 // 克
}

struct HomeView: View {
    @State private var meals: [Meal] = []
    @State private var goal: Goal = Goal()
    @State private var showingAddMeal = false
    @State private var showingGoalSettings = false
    @State private var showingCamera = false
    @State private var capturedImage: UIImage?
    @State private var showingAnalysis = false
    @State private var currentAnalysis: MealAnalysis?
    @State private var selectedMealTime = "早餐"
    @State private var isAnalyzing = false
    @State private var showingMealTimePicker = false
    
    // 使用 AuthManager 來處理登出
    @ObservedObject var authManager = AuthManager.shared
    
    // 計算今日總卡路里
    private var totalCalories: Int {
        meals.reduce(0) { $0 + $1.calories }
    }
    
    // 計算進度百分比
    private var calorieProgress: Double {
        guard goal.dailyCalories > 0 else { return 0 }
        return min(Double(totalCalories) / Double(goal.dailyCalories), 1.0)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // 背景顏色
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // 歡迎標題
                        VStack(alignment: .leading, spacing: 8) {
                            Text("今天吃什麼？")
                                .font(.system(size: 28, weight: .bold))
                            
                            Text("追蹤你的每一餐，達成健康目標")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        // 卡路里進度卡片
                        VStack(spacing: 15) {
                            HStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("今日卡路里")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.secondary)
                                    
                                    HStack(alignment: .lastTextBaseline, spacing: 5) {
                                        Text("\(totalCalories)")
                                            .font(.system(size: 32, weight: .bold))
                                        Text("/ \(goal.dailyCalories)")
                                            .font(.system(size: 18))
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                Spacer()
                                
                                // 進度圓環
                                ZStack {
                                    Circle()
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                                        .frame(width: 80, height: 80)
                                    
                                    Circle()
                                        .trim(from: 0, to: calorieProgress)
                                        .stroke(
                                            LinearGradient(
                                                colors: [Color.blue, Color.purple],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                                        )
                                        .frame(width: 80, height: 80)
                                        .rotationEffect(.degrees(-90))
                                    
                                    Text("\(Int(calorieProgress * 100))%")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                            }
                            
                            // 進度條
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(height: 8)
                                    
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.blue, Color.purple],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .frame(width: geometry.size.width * calorieProgress, height: 8)
                                }
                            }
                            .frame(height: 8)
                        }
                        .padding(20)
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                        
                        // 快速操作按鈕
                        HStack(spacing: 15) {
                            Button(action: {
                                // 打開相機拍照
                                showingCamera = true
                            }) {
                                HStack {
                                    Image(systemName: "camera.fill")
                                    Text("拍攝餐點")
                                }
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(
                                    LinearGradient(
                                        colors: [Color.blue, Color.purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                            }
                            
                            // 手動輸入按鈕（保留舊功能）
                            Button(action: {
                                showingAddMeal = true
                            }) {
                                Image(systemName: "pencil")
                                    .font(.system(size: 20))
                                    .foregroundColor(.blue)
                                    .frame(width: 50, height: 50)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(12)
                            }
                            
                            Button(action: {
                                showingGoalSettings = true
                            }) {
                                Image(systemName: "target")
                                    .font(.system(size: 20))
                                    .foregroundColor(.blue)
                                    .frame(width: 50, height: 50)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // 今日餐點列表
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("今日餐點")
                                    .font(.system(size: 20, weight: .bold))
                                
                                Spacer()
                                
                                Text("\(meals.count) 餐")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, 20)
                            
                            if meals.isEmpty {
                                // 空狀態
                                VStack(spacing: 15) {
                                    Image(systemName: "fork.knife")
                                        .font(.system(size: 50))
                                        .foregroundColor(.gray.opacity(0.5))
                                    
                                    Text("還沒有記錄任何餐點")
                                        .font(.system(size: 16))
                                        .foregroundColor(.secondary)
                                    
                                    Text("點擊上方按鈕開始記錄你的第一餐！")
                                        .font(.system(size: 14))
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 40)
                            } else {
                                // 餐點列表
                                ForEach(meals) { meal in
                                    MealRow(meal: meal)
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.top, 10)
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Foodie's")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        authManager.logout()
                    }) {
                        Image(systemName: "person.circle")
                            .font(.system(size: 22))
                    }
                }
            }
            .sheet(isPresented: $showingCamera) {
                CameraView(capturedImage: $capturedImage)
            }
            .sheet(isPresented: $showingAnalysis) {
                if let analysis = currentAnalysis {
                    MealAnalysisView(
                        meals: $meals,
                        goal: $goal,
                        analysis: analysis,
                        mealImage: capturedImage,
                        mealTime: selectedMealTime
                    )
                }
            }
            .sheet(isPresented: $showingAddMeal) {
                AddMealView(meals: $meals)
            }
            .sheet(isPresented: $showingGoalSettings) {
                GoalSettingsView(goal: $goal)
            }
            .onChange(of: capturedImage) { newImage in
                // 當圖片被拍攝後，先選擇用餐時間
                if newImage != nil {
                    showingMealTimePicker = true
                }
            }
            .actionSheet(isPresented: $showingMealTimePicker) {
                ActionSheet(
                    title: Text("選擇用餐時間"),
                    buttons: [
                        .default(Text("早餐")) {
                            selectedMealTime = "早餐"
                            if let image = capturedImage {
                                analyzeImage(image: image)
                            }
                        },
                        .default(Text("午餐")) {
                            selectedMealTime = "午餐"
                            if let image = capturedImage {
                                analyzeImage(image: image)
                            }
                        },
                        .default(Text("晚餐")) {
                            selectedMealTime = "晚餐"
                            if let image = capturedImage {
                                analyzeImage(image: image)
                            }
                        },
                        .default(Text("點心")) {
                            selectedMealTime = "點心"
                            if let image = capturedImage {
                                analyzeImage(image: image)
                            }
                        },
                        .cancel(Text("取消")) {
                            capturedImage = nil
                        }
                    ]
                )
            }
            .overlay {
                // 分析中的載入畫面
                if isAnalyzing {
                    ZStack {
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()
                        
                        VStack(spacing: 20) {
                            ProgressView()
                                .scaleEffect(1.5)
                                .tint(.white)
                            
                            Text("AI 正在分析你的餐點...")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .padding(30)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.systemBackground))
                        )
                    }
                }
            }
        }
    }
    
    // AI 分析圖片
    private func analyzeImage(image: UIImage) {
        isAnalyzing = true
        
        Task {
            let analysis = await AIAnalysisService.shared.analyzeMeal(
                image: image,
                goal: goal,
                mealTime: selectedMealTime
            )
            
            await MainActor.run {
                currentAnalysis = analysis
                isAnalyzing = false
                showingAnalysis = true
            }
        }
    }
}

// 餐點行視圖
struct MealRow: View {
    let meal: Meal
    
    var body: some View {
        HStack(spacing: 15) {
            // 圖片或圖標
            if let image = meal.image {
                // 顯示實際拍攝的圖片
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipped()
                    .cornerRadius(12)
            } else {
                // 顯示 SF Symbols 圖標
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: meal.imageName)
                        .font(.system(size: 24))
                        .foregroundColor(.blue)
                }
            }
            
            // 餐點資訊
            VStack(alignment: .leading, spacing: 5) {
                Text(meal.name)
                    .font(.system(size: 16, weight: .semibold))
                
                Text(meal.time)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // 卡路里
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(meal.calories)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.blue)
                
                Text("kcal")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
        }
        .padding(15)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

// 添加餐點視圖
struct AddMealView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var meals: [Meal]
    
    @State private var mealName: String = ""
    @State private var selectedTime: String = "早餐"
    @State private var calories: String = ""
    
    let mealTimes = ["早餐", "午餐", "晚餐", "點心"]
    
    var body: some View {
        NavigationView {
            Form {
                Section("餐點資訊") {
                    TextField("餐點名稱", text: $mealName)
                    
                    Picker("用餐時間", selection: $selectedTime) {
                        ForEach(mealTimes, id: \.self) { time in
                            Text(time).tag(time)
                        }
                    }
                    
                    TextField("卡路里", text: $calories)
                        .keyboardType(.numberPad)
                }
                
                Section {
                    Button("儲存") {
                        saveMeal()
                    }
                    .disabled(mealName.isEmpty || calories.isEmpty)
                }
            }
            .navigationTitle("記錄餐點")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveMeal() {
        guard let calorieValue = Int(calories) else { return }
        
        let meal = Meal(
            name: mealName,
            time: selectedTime,
            calories: calorieValue,
            imageName: getMealIcon(for: selectedTime)
        )
        
        meals.append(meal)
        dismiss()
    }
    
    private func getMealIcon(for time: String) -> String {
        switch time {
        case "早餐": return "sunrise.fill"
        case "午餐": return "sun.max.fill"
        case "晚餐": return "moon.fill"
        case "點心": return "cup.and.saucer.fill"
        default: return "fork.knife"
        }
    }
}

// 目標設定視圖
struct GoalSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var goal: Goal
    
    var body: some View {
        NavigationView {
            Form {
                Section("每日目標") {
                    HStack {
                        Text("卡路里")
                        Spacer()
                        TextField("卡路里", value: $goal.dailyCalories, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("蛋白質 (克)")
                        Spacer()
                        TextField("蛋白質", value: $goal.protein, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("碳水化合物 (克)")
                        Spacer()
                        TextField("碳水化合物", value: $goal.carbs, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("脂肪 (克)")
                        Spacer()
                        TextField("脂肪", value: $goal.fat, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            .navigationTitle("目標設定")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}

