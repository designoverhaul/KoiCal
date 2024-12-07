import Foundation
import SwiftUI

enum MeasurementType: String {
    case phLow = "pH Low Range"
    case kh = "KH Carbonate Hardness"
    
    var description: String {
        switch self {
        case .phLow:
            return "This is the acidity or alkalinity of water; it's crucial because it affects the health, growth, and reproduction of aquatic life."
        case .kh:
            return "KH measures how well water resists pH changes by assessing carbonate and bicarbonate levels, preventing harmful pH shifts for aquatic life."
        }
    }
    
    var values: [String] {
        switch self {
        case .phLow:
            return ["-", "6.0", "6.4", "6.6", "6.8", "7.0", "7.2", "7.6"]
        case .kh:
            return ["-", "0", "40", "80", "120", "180", "240", "360"]
        }
    }
    
    var colors: [Color] {
        switch self {
        case .phLow:
            return [
                Color(red: 0.93, green: 0.93, blue: 0.93),  // Gray
                Color(red: 0.98, green: 0.97, blue: 0.47),  // Yellow
                Color(red: 0.89, green: 0.95, blue: 0.66),  // Light Green
                Color(red: 0.75, green: 0.89, blue: 0.61),
                Color(red: 0.67, green: 0.84, blue: 0.63),
                Color(red: 0.56, green: 0.82, blue: 0.59),
                Color(red: 0.52, green: 0.80, blue: 0.65),
                Color(red: 0.35, green: 0.77, blue: 0.80)   // Blue-Green
            ]
        case .kh:
            return [
                Color(red: 0.93, green: 0.93, blue: 0.93),  // Gray
                Color(red: 0.98, green: 0.97, blue: 0.47),  // Yellow
                Color(red: 0.89, green: 0.95, blue: 0.66),  // Light Green
                Color(red: 0.75, green: 0.89, blue: 0.61),
                Color(red: 0.67, green: 0.84, blue: 0.63),
                Color(red: 0.56, green: 0.82, blue: 0.59),
                Color(red: 0.52, green: 0.80, blue: 0.65),
                Color(red: 0.35, green: 0.77, blue: 0.80)   // Blue-Green
            ]
        }
    }
}

class WaterQualityManager: ObservableObject {
    @Published var measurements: [MeasurementType: Int?] = [
        .phLow: nil,
        .kh: nil
    ]
    
    func updateMeasurement(_ type: MeasurementType, value: Int?) {
        measurements[type] = value
    }
} 
