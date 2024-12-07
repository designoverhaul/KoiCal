import Foundation

enum HealthProblem: String, Codable, CaseIterable {
    case aggression = "Aggression"
    case lowEnergy = "Low Energy (normal in winter)"
    case stuntedGrowth = "Stunted Growth"
    case lackOfAppetite = "Lack of appetite"
    case obesity = "Obesity or bloating"
    case constantHiding = "Constant Hiding"
} 