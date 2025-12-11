//
//  PersonalView.swift
//  testing.foodies
//
//  Created by William Peter Lu on 2025/11/19.
//

import SwiftUI

struct PersonalView: View {
    var body: some View {
        EmptyStateView(
            title: "Personal Hub",
            description: "這裡可以管理個人資料、健康目標與 AI 偏好設定。目前是占位頁，未來可以加入設定、通知與進度總覽。",
            systemImage: "person.crop.circle"
        )
        .navigationTitle("Personal")
    }
}

#Preview {
    PersonalView()
}

