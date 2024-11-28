import SwiftUI

struct FeedingEntryView: View {
    let entry: FeedingEntry
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Text(entry.date.formatted(date: .omitted, time: .shortened))
                .font(.footnote)
                .foregroundColor(.secondary)
            
            Text("•")
                .foregroundColor(.secondary)
            
            Text(entry.foodType)
                .font(.footnote)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
} 