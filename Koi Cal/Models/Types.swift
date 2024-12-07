import Foundation

// All shared types in one file
enum HealthProblem: String, Codable, CaseIterable {
    case aggression = "Aggression"
    case lowEnergy = "Low Energy (normal in winter)"
    case stuntedGrowth = "Stunted Growth"
    case lackOfAppetite = "Lack of appetite"
    case obesity = "Obesity or bloating"
    case constantHiding = "Constant Hiding"
}

struct WaterQuality: Codable {
    var phLow: Double?
    var khHardness: Double?
}

enum RecommendationState {
    case loading
    case success(String)
    case error(String)
    case none
} 