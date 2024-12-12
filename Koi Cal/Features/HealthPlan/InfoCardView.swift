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
            HStack {
                Text(title)
                    .font(.headline)
                if showSparkle {
                    Image(systemName: "sparkles")
                        .foregroundColor(.orange)
                }
            }
            
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
} 