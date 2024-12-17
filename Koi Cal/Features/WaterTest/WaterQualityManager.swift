import SwiftUI

class WaterQualityManager: ObservableObject {
    @AppStorage("waterQuality.nitrate") private var nitrateValue: Double?
    @AppStorage("waterQuality.nitrite") private var nitriteValue: Double?
    @AppStorage("waterQuality.pH") private var pHValue: Double?
    @AppStorage("waterQuality.kh") private var khValue: Double?
    @AppStorage("waterQuality.gh") private var ghValue: Double?
    
    @Published var measurements: [MeasurementType: Double] = [:]
    
    init() {
        // Load from AppStorage
        if let nitrate = nitrateValue { measurements[.nitrate] = nitrate }
        if let nitrite = nitriteValue { measurements[.nitrite] = nitrite }
        if let pH = pHValue { measurements[.pH] = pH }
        if let kh = khValue { measurements[.kh] = kh }
        if let gh = ghValue { measurements[.gh] = gh }
    }
    
    func updateMeasurement(_ type: MeasurementType, value: Int) {
        let valueString = type.values[value]
        print("\n🔄 Updating measurement:")
        print("Type: \(type)")
        print("Value index: \(value)")
        print("Value string: \(valueString)")
        
        if valueString == "-" {
            measurements[type] = nil
            // Clear AppStorage
            switch type {
            case .nitrate: nitrateValue = nil
            case .nitrite: nitriteValue = nil
            case .pH: pHValue = nil
            case .kh: khValue = nil
            case .gh: ghValue = nil
            }
        } else if let doubleValue = Double(valueString.replacingOccurrences(of: ",", with: "")) {
            measurements[type] = doubleValue
            // Update AppStorage
            switch type {
            case .nitrate: nitrateValue = doubleValue
            case .nitrite: nitriteValue = doubleValue
            case .pH: pHValue = doubleValue
            case .kh: khValue = doubleValue
            case .gh: ghValue = doubleValue
            }
        }
        
        // Debug print current values
        print("\n💧 Water Test Values:")
        if let nitrate = measurements[.nitrate] { print("Nitrate: \(Int(nitrate)) mg/L") }
        if let nitrite = measurements[.nitrite] { print("Nitrite: \(nitrite) mg/L") }
        if let ph = measurements[.pH] { print("pH: \(String(format: "%.1f", ph))") }
        if let kh = measurements[.kh] { print("KH: \(Int(kh)) ppm") }
        if let gh = measurements[.gh] { print("GH: \(Int(gh)) ppm") }
    }
} 
