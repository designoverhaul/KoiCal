import SwiftUI

struct FeedingEntryView: View {
    let entry: FeedingEntry
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Text(entry.date.formatted(date: .omitted, time: .shortened))
                .font(.subheadline)
                .foregroundColor(.primary.opacity(0.85))
                .lineSpacing(1)
            
            Text("•")
                .foregroundColor(.primary.opacity(0.75))
            
            Text(entry.foodType)
                .font(.subheadline)
                .foregroundColor(.primary.opacity(0.75))
                .lineSpacing(1)
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
    }
} 
