import SwiftUI

struct FeedingGuideView: View {
    var onDismiss: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text("Best Practices")
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Button(action: onDismiss) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title2)
                }
            }
            .padding()
            // ... rest of the view
        }
    }
}

struct GuideSection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
} 