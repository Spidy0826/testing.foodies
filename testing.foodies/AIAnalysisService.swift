//
//  AIAnalysisService.swift
//  testing.foodies
//
//  Created by William Peter Lu on 2025/11/19.
//

import UIKit
import SwiftUI

// AI 分析服務（目前使用模擬數據，之後可以連接實際的 AI API）
class AIAnalysisService {
    static let shared = AIAnalysisService()
    
    private init() {}
    
    // 分析食物圖片（模擬 AI 分析）
    // 實際應用中，這裡應該：
    // 1. 將圖片上傳到 AI 服務（如 OpenAI Vision API, Google Cloud Vision 等）
    // 2. 接收分析結果
    // 3. 根據用戶目標評估這餐的好壞
    func analyzeMeal(image: UIImage, goal: Goal, mealTime: String) async -> MealAnalysis {
        // 模擬 API 延遲
        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 秒
        
        // 模擬 AI 分析結果（實際應用中這裡會是 API 回應）
        let mockAnalyses = generateMockAnalysis(goal: goal, mealTime: mealTime)
        let analysis = mockAnalyses.randomElement() ?? mockAnalyses[0]
        
        return analysis
    }
    
    // 生成模擬分析結果
    private func generateMockAnalysis(goal: Goal, mealTime: String) -> [MealAnalysis] {
        let mealNames = [
            "雞胸肉沙拉", "鮭魚便當", "義大利麵", "牛肉漢堡", 
            "蔬菜湯", "壽司", "炒飯", "三明治"
        ]
        
        let goodReasons = [
            "這餐含有豐富的蛋白質，卡路里適中，非常適合你的減重目標。蔬菜提供了充足的纖維，有助於消化。",
            "營養均衡，蛋白質和碳水化合物的比例完美，能夠提供足夠的能量同時不會過量。",
            "低卡路里但營養豐富，含有大量維生素和礦物質，對你的健康目標很有幫助。",
            "優質蛋白質來源，搭配適量的健康脂肪，能夠維持飽足感並支持肌肉生長。"
        ]
        
        let badReasons = [
            "這餐的卡路里偏高，可能會超過你今日的目標。建議減少份量或選擇較低熱量的替代品。",
            "碳水化合物含量較高，如果今天已經攝取較多碳水，這餐可能會影響你的目標進度。",
            "脂肪含量偏高，雖然有些是健康脂肪，但總熱量可能超過你的需求。",
            "營養密度較低，主要是精緻碳水化合物，缺乏足夠的蛋白質和纖維。"
        ]
        
        let suggestions = [
            "下一餐可以選擇一些優質碳水化合物，如糙米或全麥麵包，搭配適量的蛋白質。",
            "建議下一餐以蔬菜和蛋白質為主，減少碳水化合物的攝取。",
            "可以選擇一些低卡路里的食物，如清湯或沙拉，來平衡今日的總熱量。",
            "下一餐建議增加蔬菜的份量，並選擇瘦肉或魚類作為蛋白質來源。"
        ]
        
        var analyses: [MealAnalysis] = []
        
        // 生成好的分析
        for i in 0..<4 {
            analyses.append(MealAnalysis(
                mealName: mealNames[i],
                calories: Int.random(in: 300...450),
                protein: Double.random(in: 25...40),
                carbs: Double.random(in: 30...50),
                fat: Double.random(in: 8...15),
                isGoodForGoal: true,
                reason: goodReasons[i],
                suggestion: suggestions[i],
                score: Int.random(in: 75...95)
            ))
        }
        
        // 生成需要注意的分析
        for i in 4..<8 {
            analyses.append(MealAnalysis(
                mealName: mealNames[i],
                calories: Int.random(in: 500...700),
                protein: Double.random(in: 15...25),
                carbs: Double.random(in: 60...90),
                fat: Double.random(in: 20...35),
                isGoodForGoal: false,
                reason: badReasons[i - 4],
                suggestion: suggestions[i - 4],
                score: Int.random(in: 40...65)
            ))
        }
        
        return analyses
    }
}

