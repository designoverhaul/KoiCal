import Foundation

struct FeedingEntry: Identifiable, Equatable {
    let id: UUID
    let date: Date
    let feedingNumber: Int
    let foodType: String
    let isHistoricalEntry: Bool
    
    init(id: UUID = UUID(), date: Date, feedingNumber: Int, foodType: String, isHistoricalEntry: Bool) {
        self.id = id
        self.date = date
        self.feedingNumber = feedingNumber
        self.foodType = foodType
        self.isHistoricalEntry = isHistoricalEntry
    }
    
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
    @Published var currentFoodType: String {
        didSet {
            // Make sure we only save valid food types
            if currentFoodType != "High Protein" && currentFoodType != "Cool Season" {
                currentFoodType = "High Protein"
            }
            UserDefaults.standard.set(currentFoodType, forKey: "currentFoodType")
        }
    }
    @Published private(set) var fedYesterday: Bool = false
    
    init() {
        // Initialize currentFoodType from UserDefaults with validation
        let savedFoodType = UserDefaults.standard.string(forKey: "currentFoodType") ?? "High Protein"
        if savedFoodType != "High Protein" && savedFoodType != "Cool Season" {
            self.currentFoodType = "High Protein"
        } else {
            self.currentFoodType = savedFoodType
        }
        
        loadFeedingData()
        updateFedYesterday()
    }
    
    private func saveFeedingData() {
        print("💾 Saving feeding data...")
        
        // Save feeding counts with dates as timestamps
        let feedingDict = feedings.reduce(into: [String: Int]()) { result, entry in
            result["\(entry.key.timeIntervalSince1970)"] = entry.value
        }
        print("💾 Saving feeding counts: \(feedingDict)")
        UserDefaults.standard.set(feedingDict, forKey: "feedingCounts")
        
        // Save feeding entries as array of dictionaries
        let entryDicts = feedingEntries.map { entry -> [String: Any] in
            return [
                "id": entry.id.uuidString,
                "date": entry.date.timeIntervalSince1970,
                "feedingNumber": entry.feedingNumber,
                "foodType": entry.foodType,
                "isHistoricalEntry": entry.isHistoricalEntry
            ]
        }
        print("💾 Saving feeding entries: \(entryDicts)")
        UserDefaults.standard.set(entryDicts, forKey: "feedingEntries")
        
        // Force UserDefaults to save immediately
        UserDefaults.standard.synchronize()
    }
    
    private func loadFeedingData() {
        print("⏳ Starting to load feeding data...")
        
        // First load the feeding entries
        if let savedEntries = UserDefaults.standard.array(forKey: "feedingEntries") as? [[String: Any]] {
            print("📝 Found saved feeding entries: \(savedEntries)")
            feedingEntries = savedEntries.compactMap { dict -> FeedingEntry? in
                guard let timestamp = dict["date"] as? Double,
                      let feedingNumber = dict["feedingNumber"] as? Int,
                      let foodType = dict["foodType"] as? String,
                      let isHistoricalEntry = dict["isHistoricalEntry"] as? Bool,
                      let idString = dict["id"] as? String,
                      let id = UUID(uuidString: idString) else {
                    return nil
                }
                return FeedingEntry(
                    id: id,
                    date: Date(timeIntervalSince1970: timestamp),
                    feedingNumber: feedingNumber,
                    foodType: foodType,
                    isHistoricalEntry: isHistoricalEntry
                )
            }
            print("📝 Processed feeding entries: \(feedingEntries)")
            
            // Rebuild the feedings dictionary from the entries
            let calendar = Calendar.current
            feedings = Dictionary(grouping: feedingEntries) { entry in
                calendar.startOfDay(for: entry.date)
            }.mapValues { $0.count }
            
            print("🔄 Rebuilt feeding counts from entries: \(feedings)")
        }
    }
    
    private func updateFedYesterday() {
        let calendar = Calendar.current
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())!
        fedYesterday = getFeedingCount(for: yesterday) > 0
    }
    
    func toggleFeeding(for date: Date) {
        print("🔄 Toggle feeding for date: \(date)")
        let calendar = Calendar.current
        let normalizedDate = calendar.startOfDay(for: date)
        let isHistoricalEntry = !calendar.isDateInToday(date)
        
        // Get current count from entries for this date
        let entriesForDate = feedingEntries.filter {
            calendar.isDate(calendar.startOfDay(for: $0.date), equalTo: normalizedDate, toGranularity: .day)
        }
        let currentCount = entriesForDate.count
        print("📊 Current count for date: \(currentCount)")
        
        if currentCount >= 3 {
            print("⚠️ Max feedings reached for this date")
            return
        }
        
        let entryDate = isHistoricalEntry ? 
            calendar.date(bySettingHour: 12, minute: 0, second: 0, of: normalizedDate)! :
            Date()
        
        let newEntry = FeedingEntry(
            id: UUID(),
            date: entryDate,
            feedingNumber: currentCount + 1,
            foodType: currentFoodType,
            isHistoricalEntry: isHistoricalEntry
        )
        feedingEntries.append(newEntry)
        print("📝 Added new entry: \(newEntry)")
        
        // Update feedings dictionary to match entries
        feedings[normalizedDate] = currentCount + 1
        print("📈 Updated feeding count: \(currentCount + 1)")
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