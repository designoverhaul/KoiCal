import Foundation

class WaterQualityManager: ObservableObject {
    enum Measurement {
        case nitrate, nitrite, pH, kh, gh
    }
    
    @Published var measurements: [Measurement: Double] = [:]
} 