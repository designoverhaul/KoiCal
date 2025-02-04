import Foundation

class FeedingData: ObservableObject {
    @Published var currentFoodType: String = "High Protein"
    
    private var feedingHistory: [Date: Int] = [:]
    
    func getFeedingCount(for date: Date) -> Int {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        return feedingHistory[startOfDay, default: 0]
    }
} 