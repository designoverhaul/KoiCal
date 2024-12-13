import SwiftUI
import Foundation

class WaterQualityManager: ObservableObject {
    @Published var measurements: [MeasurementType: Double] = [:] {
        didSet {
            // Just save to UserDefaults, no printing
            for (key, value) in measurements {
                UserDefaults.standard.set(value, forKey: "waterQuality_\(key.rawValue)")
            }
        }
    }
    
    init() {
        // Load saved values
        for type in MeasurementType.allCases {
            if let savedValue = UserDefaults.standard.object(forKey: "waterQuality_\(type.rawValue)") as? Double {
                measurements[type] = savedValue
            }
        }
    }
    
    func updateMeasurement(_ type: MeasurementType, value: Int) {
        let valueString = type.values[value]
        print("⚡️ Updating \(type) with value: \(valueString)")
        
        if valueString == "-" {
            measurements[type] = nil
        } else if let doubleValue = Double(valueString.replacingOccurrences(of: ",", with: "")) {
            measurements[type] = doubleValue
            
            // Print complete water test after each update
            print("\n💧 Water Test:")
            if let nitrate = measurements[.nitrate] {
                print("Nitrate: \(Int(nitrate)) mg/L")  // Remove decimal
            }
            if let nitrite = measurements[.nitrite] {
                print("Nitrite: \(nitrite) mg/L")  // Keep decimal for nitrite
            }
            if let ph = measurements[.phLow] {
                print("pH: \(String(format: "%.1f", ph))")  // Keep one decimal for pH
            }
            if let kh = measurements[.kh] {
                print("KH: \(Int(kh)) ppm")  // Remove decimal
            }
            if let gh = measurements[.gh] {
                print("GH: \(Int(gh)) ppm")  // Remove decimal
            }
        }
    }
} 