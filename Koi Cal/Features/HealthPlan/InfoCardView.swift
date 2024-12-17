import SwiftUI

struct InfoCardView: View {
    let title: String
    let content: String
    let showSparkle: Bool
    
    init(
        title: String,
        content: String,
        showSparkle: Bool = true
    ) {
        self.title = title
        self.content = content
        self.showSparkle = showSparkle
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !title.isEmpty {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            Text(content.trimmingCharacters(in: .whitespacesAndNewlines))
                .font(.body)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
        .overlay(alignment: .topTrailing) {
            if showSparkle {
                Image(systemName: "sparkle")
                    .foregroundColor(Color(hex: "F18833"))
                    .font(.system(size: 14))
                    .padding(8)
            }
        }
    }
} 