import Foundation

// All shared types in one file
public enum HealthProblem: String, Codable, CaseIterable {
    case aggression = "Aggression"
    case lowEnergy = "Low Energy (normal in winter)"
    case stuntedGrowth = "Stunted Growth"
    case lackOfAppetite = "Lack of appetite"
    case obesity = "Obesity or bloating"
    case constantHiding = "Constant Hiding"
}

public struct WaterQuality: Codable {
    var phLow: Double?
    var khHardness: Double?
}

public enum RecommendationState {
    case loading
    case success(String)
    case error(String)
    case none
}

public enum FishSize: String, CaseIterable {
    case small = "Small"
    case medium = "Medium"
    case large = "Large"
} 