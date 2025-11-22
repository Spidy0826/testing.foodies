//
//  MealAnalysisView.swift
//  testing.foodies
//
//  Created by William Peter Lu on 2025/11/19.
//

import SwiftUI

// AI 分析結果模型
struct MealAnalysis {
    let mealName: String
    let calories: Int
    let protein: Double // 克
    let carbs: Double // 克
    let fat: Double // 克
    let isGoodForGoal: Bool // 對目標是好是壞
    let reason: String // 原因
    let suggestion: String // 下一餐建議
    let score: Int // 評分 0-100
}

// AI 分析結果視圖
struct MealAnalysisView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var meals: [Meal]
    @Binding var goal: Goal
    
    let analysis: MealAnalysis
    let mealImage: UIImage?
    let mealTime: String
    
    @State private var showingSaveConfirmation = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // 餐點圖片
                    if let image = mealImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 250)
                            .clipped()
                            .cornerRadius(20)
                            .padding(.horizontal, 20)
                    }
                    
                    // 評分卡片（好/壞的視覺化）
                    VStack(spacing: 15) {
                        // 評分圓環
                        ZStack {
                            Circle()
                                .stroke(
                                    analysis.isGoodForGoal ? Color.green.opacity(0.2) : Color.orange.opacity(0.2),
                                    lineWidth: 12
                                )
                                .frame(width: 120, height: 120)
                            
                            Circle()
                                .trim(from: 0, to: Double(analysis.score) / 100.0)
                                .stroke(
                                    analysis.isGoodForGoal ? Color.green : Color.orange,
                                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                                )
                                .frame(width: 120, height: 120)
                                .rotationEffect(.degrees(-90))
                            
                            VStack(spacing: 5) {
                                Text("\(analysis.score)")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(analysis.isGoodForGoal ? .green : .orange)
                                
                                Text("分")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        // 好/壞標籤
                        HStack(spacing: 10) {
                            Image(systemName: analysis.isGoodForGoal ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(analysis.isGoodForGoal ? .green : .orange)
                            
                            Text(analysis.isGoodForGoal ? "這餐對你的目標很好！" : "這餐需要注意")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(analysis.isGoodForGoal ? .green : .orange)
                        }
                    }
                    .padding(25)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(analysis.isGoodForGoal ? Color.green.opacity(0.1) : Color.orange.opacity(0.1))
                    )
                    .padding(.horizontal, 20)
                    
                    // 原因說明
                    VStack(alignment: .leading, spacing: 12) {
                        Text("為什麼？")
                            .font(.system(size: 18, weight: .bold))
                        
                        Text(analysis.reason)
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    
                    // 營養資訊卡片
                    VStack(alignment: .leading, spacing: 15) {
                        Text("營養資訊")
                            .font(.system(size: 18, weight: .bold))
                        
                        VStack(spacing: 12) {
                            NutritionRow(label: "卡路里", value: "\(analysis.calories) kcal", color: .blue)
                            NutritionRow(label: "蛋白質", value: String(format: "%.1f 克", analysis.protein), color: .red)
                            NutritionRow(label: "碳水化合物", value: String(format: "%.1f 克", analysis.carbs), color: .purple)
                            NutritionRow(label: "脂肪", value: String(format: "%.1f 克", analysis.fat), color: .orange)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    
                    // 下一餐建議
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.yellow)
                            Text("下一餐建議")
                                .font(.system(size: 18, weight: .bold))
                        }
                        
                        Text(analysis.suggestion)
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.yellow.opacity(0.1))
                    )
                    .padding(.horizontal, 20)
                    
                    // 儲存按鈕
                    Button(action: {
                        saveMeal()
                    }) {
                        Text("儲存這餐")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(
                                LinearGradient(
                                    colors: [Color.blue, Color.purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
                .padding(.top, 10)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("分析結果")
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
        let meal = Meal(
            id: UUID(),
            name: analysis.mealName,
            time: mealTime,
            calories: analysis.calories,
            imageName: getMealIcon(for: mealTime),
            image: mealImage
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

// 營養資訊行視圖
struct NutritionRow: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            Text(label)
                .font(.system(size: 16))
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    let sampleAnalysis = MealAnalysis(
        mealName: "雞胸肉沙拉",
        calories: 350,
        protein: 35.0,
        carbs: 20.0,
        fat: 12.0,
        isGoodForGoal: true,
        reason: "這餐含有豐富的蛋白質，卡路里適中，非常適合你的減重目標。蔬菜提供了充足的纖維，有助於消化。",
        suggestion: "下一餐可以選擇一些優質碳水化合物，如糙米或全麥麵包，搭配適量的蛋白質。",
        score: 85
    )
    
    return MealAnalysisView(
        meals: .constant([]),
        goal: .constant(Goal()),
        analysis: sampleAnalysis,
        mealImage: nil,
        mealTime: "午餐"
    )
}

