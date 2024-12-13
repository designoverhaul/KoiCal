import SwiftUI
import Foundation

class WaterQualityManager: ObservableObject {
    @Published var measurements: [MeasurementType: Double] = [:] {
        didSet {
            // Print all current measurements whenever they change
            print("\n💧 Water Test:")
            if let nitrate = measurements[.nitrate] {
                print("Nitrate: \(nitrate) mg/L")
            }
            if let nitrite = measurements[.nitrite] {
                print("Nitrite: \(nitrite) mg/L")
            }
            if let ph = measurements[.phLow] {
                print("pH: \(ph)")
            }
            if let kh = measurements[.kh] {
                print("KH: \(kh) ppm")
            }
            if let gh = measurements[.gh] {
                print("GH: \(gh) ppm")
            }
            
            // Save values to UserDefaults
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
        if valueString == "-" {
            measurements[type] = nil
        } else if let doubleValue = Double(valueString.replacingOccurrences(of: ",", with: "")) {
            measurements[type] = doubleValue
            print("Updated \(type) to: \(doubleValue)")
        }
    }
} 