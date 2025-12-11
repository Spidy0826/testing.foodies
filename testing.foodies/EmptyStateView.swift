//
//  EmptyStateView.swift
//  testing.foodies
//
//  Created by William Peter Lu on 2025/11/19.
//

import SwiftUI

struct EmptyStateView: View {
    let title: String
    let description: String
    let systemImage: String
    
    init(title: String, description: String, systemImage: String = "sparkles") {
        self.title = title
        self.description = description
        self.systemImage = systemImage
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: systemImage)
                .font(.system(size: 60))
                .foregroundStyle(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
            
            Text(title)
                .font(.system(size: 28, weight: .bold))
            
            Text(description)
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    EmptyStateView(title: "Preview", description: "Empty state preview")
}

