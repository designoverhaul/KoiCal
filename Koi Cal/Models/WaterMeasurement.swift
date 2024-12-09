import Foundation
import SwiftUI

enum MeasurementType: String, CaseIterable {
    case nitrate = "Nitrate"
    case nitrite = "Nitrite"
    case phLow = "pH"
    case kh = "KH Carbonate Hardness"
    case gh = "General Hardness"
    
    var description: String {
        switch self {
        case .nitrate:
            return "Nitrate levels indicate the amount of waste products in the water. High levels can be harmful to fish and promote excessive algae growth."
        case .nitrite:
            return "Nitrite is highly toxic to fish and is an intermediate product in the nitrogen cycle. High levels can cause brown blood disease."
        case .phLow:
            return "This is the acidity or alkalinity of water; it's crucial because it affects the health, growth, and reproduction of aquatic life."
        case .kh:
            return "KH measures how well water resists pH changes by assessing carbonate and bicarbonate levels, preventing harmful pH shifts for aquatic life."
        case .gh:
            return "General Hardness measures the concentration of dissolved minerals, particularly calcium and magnesium. It affects fish osmoregulation and shell development."
        }
    }
    
    var values: [String] {
        switch self {
        case .nitrate:
            return ["-", "0", "10", "25", "50", "100", "250", "500"]
        case .nitrite:
            return ["-", "0", "1", "5", "10", "20", "40", "80"]
        case .phLow:
            return ["-", "6.0", "6.4", "6.6", "6.8", "7.0", "7.2", "7.6"]
        case .kh:
            return ["-", "0", "40", "80", "120", "180", "240", "360"]
        case .gh:
            return ["-", "0", "30", "60", "120", "180", "", ""]
        }
    }
    
    var colors: [Color] {
        switch self {
        case .nitrate:
            return [
                Color(red: 0.93, green: 0.93, blue: 0.93),  // Gray
                Color(hex: "FFFFFD"),  // 0
                Color(hex: "F9E9EC"),  // 10
                Color(hex: "E6B9CE"),  // 25
                Color(hex: "D35698"),  // 50
                Color(hex: "B72892"),  // 100
                Color(hex: "B91888"),  // 250
                Color(hex: "B91888")   // 500
            ]
        case .nitrite:
            return [
                Color(red: 0.93, green: 0.93, blue: 0.93),  // Gray
                Color(hex: "FFFFFF"),  // 0
                Color(hex: "FAEAED"),  // 1
                Color(hex: "E6B9CE"),  // 5
                Color(hex: "D768AA"),  // 10
                Color(hex: "D354A1"),  // 20
                Color(hex: "C62F90"),  // 40
                Color(hex: "972268")   // 80
            ]
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
        case .gh:
            return [
                Color(red: 0.93, green: 0.93, blue: 0.93),  // Gray for "-"
                Color(hex: "8BCCC4"),  // 0
                Color(hex: "59BDBF"),  // 30
                Color(hex: "6CAEC9"),  // 60
                Color(hex: "5C90C2"),  // 120
                Color(hex: "6879C1"),  // 180
                Color.clear,           // Empty placeholder
                Color.clear            // Empty placeholder
            ]
        }
    }
}

class WaterQualityManager: ObservableObject {
    @AppStorage("waterQuality_nitrate") private var nitrateValue: Int = 0
    @AppStorage("waterQuality_nitrite") private var nitriteValue: Int = 0
    @AppStorage("waterQuality_ph") private var phValue: Int = 0
    @AppStorage("waterQuality_kh") private var khValue: Int = 0
    @AppStorage("waterQuality_gh") private var ghValue: Int = 0
    
    @Published var measurements: [MeasurementType: Int] = [:] {
        didSet {
            // Save values to persistent storage
            nitrateValue = measurements[.nitrate] ?? nitrateValue
            nitriteValue = measurements[.nitrite] ?? nitriteValue
            phValue = measurements[.phLow] ?? phValue
            khValue = measurements[.kh] ?? khValue
            ghValue = measurements[.gh] ?? ghValue
        }
    }
    
    init() {
        // Initialize measurements with stored values
        measurements = [
            .nitrate: nitrateValue,
            .nitrite: nitriteValue,
            .phLow: phValue,
            .kh: khValue,
            .gh: ghValue
        ]
    }
    
    func updateMeasurement(_ type: MeasurementType, value: Int) {
        measurements[type] = value
    }
} 
