import SwiftUI

struct FeedingEntryView: View {
    let entry: FeedingEntry
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Text(entry.date.formatted(date: .omitted, time: .shortened))
                .font(.callout)
                .foregroundColor(.primary.opacity(0.85))
            
            Text("•")
                .foregroundColor(.primary.opacity(0.70))
            
            Text(entry.foodType)
                .font(.callout)
                .foregroundColor(.primary.opacity(0.70))
            
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
