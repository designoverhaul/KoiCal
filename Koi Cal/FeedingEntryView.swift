import SwiftUI

struct FeedingEntryView: View {
    let entry: FeedingEntry
    let onDelete: () -> Void
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return formatter.string(from: entry.date)
    }
    
    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        return formatter.string(from: entry.date)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 8) {
                Text(formattedDate)
                    .foregroundColor(.primary)
                    .padding(.trailing, 4)
                
                Text(formattedTime)
                    .foregroundColor(.primary)
                    .padding(.leading, 4)
            }
            
            Spacer()
            
            Text(entry.foodType)
                .foregroundColor(.secondary)
                .padding(.trailing, 8)
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
} 