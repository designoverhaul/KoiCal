import Foundation

class SettingsManager: ObservableObject {
    private let defaults = UserDefaults.standard
    
    // Keys for UserDefaults
    private enum Keys {
        static let ageGroup = "ageGroup"
        static let objective = "objective"
        static let foodType = "foodType"
        static let location = "location"
    }
    
    @Published var ageGroup: String {
        didSet {
            defaults.set(ageGroup, forKey: Keys.ageGroup)
        }
    }
    
    @Published var objective: String {
        didSet {
            defaults.set(objective, forKey: Keys.objective)
        }
    }
    
    @Published var foodType: String {
        didSet {
            defaults.set(foodType, forKey: Keys.foodType)
        }
    }
    
    @Published var location: String {
        didSet {
            defaults.set(location, forKey: Keys.location)
        }
    }
    
    init() {
        // Load saved values or use defaults
        self.ageGroup = defaults.string(forKey: Keys.ageGroup) ?? "Mixed"
        self.objective = defaults.string(forKey: Keys.objective) ?? "General Health"
        self.foodType = defaults.string(forKey: Keys.foodType) ?? "High Protein"
        self.location = defaults.string(forKey: Keys.location) ?? "Atlanta, Georgia"
    }
} 