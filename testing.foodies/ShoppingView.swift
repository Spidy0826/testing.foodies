//
//  ShoppingView.swift
//  testing.foodies
//
//  Created by William Peter Lu on 2025/11/19.
//

import SwiftUI

struct ShoppingView: View {
    var body: some View {
        EmptyStateView(
            title: "Shopping",
            description: "未來可以在這裡購買健康食材、預製餐點或 AI 推薦的營養品。目前為占位頁。",
            systemImage: "cart.fill"
        )
        .navigationTitle("Shopping")
    }
}

#Preview {
    ShoppingView()
}

