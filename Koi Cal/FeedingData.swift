import Foundation

struct FeedingEntry: Identifiable {
    let id = UUID()
    let date: Date
    let feedingNumber: Int
    let foodType: String
}

class FeedingData: ObservableObject {
    @Published var feedings: [Date: Int] = [:]
    @Published var feedingEntries: [FeedingEntry] = []
    @Published var currentFoodType: String = "High Protein"
    
    func toggleFeeding(for date: Date) {
        let calendar = Calendar.current
        let normalizedDate = calendar.startOfDay(for: date)
        
        if let currentCount = feedings[normalizedDate] {
            if currentCount < 3 {
                feedings[normalizedDate] = currentCount + 1
                feedingEntries.append(FeedingEntry(
                    date: Date(),
                    feedingNumber: currentCount + 1,
                    foodType: currentFoodType
                ))
            }
        } else {
            feedings[normalizedDate] = 1
            feedingEntries.append(FeedingEntry(
                date: Date(),
                feedingNumber: 1,
                foodType: currentFoodType
            ))
        }
    }
    
    func deleteEntry(_ entry: FeedingEntry) {
        if let index = feedingEntries.firstIndex(where: { $0.id == entry.id }) {
            feedingEntries.remove(at: index)
            
            let calendar = Calendar.current
            let normalizedDate = calendar.startOfDay(for: entry.date)
            if let currentCount = feedings[normalizedDate] {
                if currentCount > 1 {
                    feedings[normalizedDate] = currentCount - 1
                } else {
                    feedings.removeValue(forKey: normalizedDate)
                }
            }
        }
    }
    
    func getFeedingCount(for date: Date) -> Int {
        let calendar = Calendar.current
        let normalizedDate = calendar.startOfDay(for: date)
        return feedings[normalizedDate] ?? 0
    }
} 