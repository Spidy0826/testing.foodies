//
//  GroupView.swift
//  testing.foodies
//
//  Created by William Peter Lu on 2025/11/19.
//

import SwiftUI

struct GroupView: View {
    var body: some View {
        EmptyStateView(
            title: "Friends & Groups",
            description: "在這裡可以與朋友互相分享餐點、挑戰與 AI 分析結果。目前是占位頁，之後可加入社交串流、排行榜與聊天室。",
            systemImage: "person.3.fill"
        )
        .navigationTitle("Group")
    }
}

#Preview {
    GroupView()
}

