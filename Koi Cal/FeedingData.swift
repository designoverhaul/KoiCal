import Foundation

struct FeedingEntry: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let feedingNumber: Int
    let foodType: String
    let isHistoricalEntry: Bool
    
    static func == (lhs: FeedingEntry, rhs: FeedingEntry) -> Bool {
        return lhs.id == rhs.id
    }
}

class FeedingData: ObservableObject {
    @Published var feedings: [Date: Int] = [:] {
        didSet {
            saveFeedingData()
        }
    }
    @Published var feedingEntries: [FeedingEntry] = [] {
        didSet {
            saveFeedingData()
        }
    }
    @Published var currentFoodType: String = "High Protein"
    
    init() {
        loadFeedingData()
    }
    
    private func saveFeedingData() {
        // Save feeding counts with dates as timestamps
        let feedingDict = feedings.reduce(into: [String: Int]()) { result, entry in
            result["\(entry.key.timeIntervalSince1970)"] = entry.value
        }
        UserDefaults.standard.set(feedingDict, forKey: "feedingCounts")
        
        // Save feeding entries as array of dictionaries
        let entryDicts = feedingEntries.map { entry -> [String: Any] in
            return [
                "date": entry.date.timeIntervalSince1970,
                "feedingNumber": entry.feedingNumber,
                "foodType": entry.foodType,
                "isHistoricalEntry": entry.isHistoricalEntry
            ]
        }
        UserDefaults.standard.set(entryDicts, forKey: "feedingEntries")
    }
    
    private func loadFeedingData() {
        // Load feeding counts
        if let savedFeedings = UserDefaults.standard.dictionary(forKey: "feedingCounts") as? [String: Int] {
            feedings = savedFeedings.reduce(into: [Date: Int]()) { result, entry in
                if let timestamp = Double(entry.key) {
                    result[Date(timeIntervalSince1970: timestamp)] = entry.value
                }
            }
        }
        
        // Load feeding entries
        if let savedEntries = UserDefaults.standard.array(forKey: "feedingEntries") as? [[String: Any]] {
            feedingEntries = savedEntries.compactMap { dict -> FeedingEntry? in
                guard let timestamp = dict["date"] as? Double,
                      let feedingNumber = dict["feedingNumber"] as? Int,
                      let foodType = dict["foodType"] as? String,
                      let isHistoricalEntry = dict["isHistoricalEntry"] as? Bool else {
                    return nil
                }
                return FeedingEntry(
                    date: Date(timeIntervalSince1970: timestamp),
                    feedingNumber: feedingNumber,
                    foodType: foodType,
                    isHistoricalEntry: isHistoricalEntry
                )
            }
        }
    }
    
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