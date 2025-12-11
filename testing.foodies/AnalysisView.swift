//
//  AnalysisView.swift
//  testing.foodies
//
//  Created by William Peter Lu on 2025/11/19.
//

import SwiftUI

struct AnalysisView: View {
    var body: some View {
        EmptyStateView(
            title: "AI Analysis",
            description: "這裡會顯示更深入的 AI 健康分析與趨勢圖。目前為占位頁，之後可加上歷史趨勢、圖表與報告。"
        )
        .navigationTitle("Analysis")
    }
}

#Preview {
    AnalysisView()
}

