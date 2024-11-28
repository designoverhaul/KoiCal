import Foundation

struct FeedingEntry: Identifiable {
    let id = UUID()
    let date: Date
    let feedingNumber: Int
    let foodType: String
    let isHistoricalEntry: Bool
}

class FeedingData: ObservableObject {
    @Published var feedings: [Date: Int] = [:]
    @Published var feedingEntries: [FeedingEntry] = []
    @Published var currentFoodType: String = "High Protein"
    
    func toggleFeeding(for date: Date) {
        let calendar = Calendar.current
        let normalizedDate = calendar.startOfDay(for: date)
        let isHistoricalEntry = !calendar.isDateInToday(date)
        
        let currentCount = feedings[normalizedDate] ?? 0
        if currentCount >= 3 {
            return
        }
        
        let entryDate = isHistoricalEntry ? 
            calendar.date(bySettingHour: 12, minute: 0, second: 0, of: date)! :
            Date()
        
        feedings[normalizedDate] = currentCount + 1
        feedingEntries.append(FeedingEntry(
            date: entryDate,
            feedingNumber: currentCount + 1,
            foodType: currentFoodType,
            isHistoricalEntry: isHistoricalEntry
        ))
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
    
    func getEntries(for date: Date) -> [FeedingEntry] {
        let calendar = Calendar.current
        return feedingEntries.filter { entry in
            calendar.isDate(entry.date, inSameDayAs: date)
        }
    }
} 