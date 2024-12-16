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
            updateFedYesterday()
        }
    }
    @Published var feedingEntries: [FeedingEntry] = [] {
        didSet {
            saveFeedingData()
            updateFedYesterday()
        }
    }
    @Published var currentFoodType: String = "High Protein"
    @Published private(set) var fedYesterday: Bool = false
    
    init() {
        loadFeedingData()
        updateFedYesterday()
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
                    let date = Date(timeIntervalSince1970: timestamp)
                    // Normalize the date to start of day
                    let calendar = Calendar.current
                    let normalizedDate = calendar.startOfDay(for: date)
                    result[normalizedDate] = entry.value
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
    
    private func updateFedYesterday() {
        let calendar = Calendar.current
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())!
        fedYesterday = getFeedingCount(for: yesterday) > 0
    }
    
    func toggleFeeding(for date: Date) {
        let calendar = Calendar.current
        let normalizedDate = calendar.startOfDay(for: date)
        let isHistoricalEntry = !calendar.isDateInToday(date)
        
        let currentCount = feedings[normalizedDate] ?? 0
        if currentCount >= 3 {
            return
        }
        
        // For historical entries, create an entry at noon of the selected date
        // For current entries, use the current time
        let entryDate = isHistoricalEntry ? 
            calendar.date(bySettingHour: 12, minute: 0, second: 0, of: normalizedDate)! :
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
            let calendar = Calendar.current
            let normalizedDate = calendar.startOfDay(for: entry.date)
            
            feedingEntries.remove(at: index)
            
            // Update the feeding count for the day
            let remainingEntries = getEntries(for: normalizedDate)
            feedings[normalizedDate] = remainingEntries.count
            
            if remainingEntries.isEmpty {
                feedings.removeValue(forKey: normalizedDate)
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
        let normalizedDate = calendar.startOfDay(for: date)
        return feedingEntries.filter { entry in
            calendar.isDate(calendar.startOfDay(for: entry.date), equalTo: normalizedDate, toGranularity: .day)
        }
    }
} 