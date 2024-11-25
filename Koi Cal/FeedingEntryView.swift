import SwiftUI

struct FeedingEntryView: View {
    let entry: FeedingEntry
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Feeding #\(entry.feedingNumber)")
                    .font(.headline)
                
                if !entry.isHistoricalEntry {
                    Text(entry.date.formatted(date: .omitted, time: .shortened))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Text(entry.foodType)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
} 