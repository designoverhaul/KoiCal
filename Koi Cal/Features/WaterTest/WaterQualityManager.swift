import SwiftUI

class WaterQualityManager: ObservableObject {
    @AppStorage("waterQuality.nitrate") private var nitrateValue: Double?
    @AppStorage("waterQuality.nitrite") private var nitriteValue: Double?
    @AppStorage("waterQuality.pH") private var pHValue: Double?
    @AppStorage("waterQuality.kh") private var khValue: Double?
    @AppStorage("waterQuality.gh") private var ghValue: Double?
    
    @Published var measurements: [MeasurementType: Double] = [:] {
        didSet {
            // Debug print
            print("\n🔄 WaterQualityManager - Measurements Updated:")
            print("Current measurements: \(measurements)")
            
            // Save to AppStorage whenever measurements change
            if let nitrate = measurements[.nitrate] { nitrateValue = nitrate }
            if let nitrite = measurements[.nitrite] { nitriteValue = nitrite }
            if let pH = measurements[.pH] { pHValue = pH }
            if let kh = measurements[.kh] { khValue = kh }
            if let gh = measurements[.gh] { ghValue = gh }
            
            // Force immediate save
            UserDefaults.standard.synchronize()
        }
    }
    
    init() {
        // Only load values that are actually set
        // Don't set any default values
        if let nitrate = nitrateValue { measurements[.nitrate] = nitrate }
        if let nitrite = nitriteValue { measurements[.nitrite] = nitrite }
        if let pH = pHValue { measurements[.pH] = pH }
        if let kh = khValue { measurements[.kh] = kh }
        if let gh = ghValue { measurements[.gh] = gh }
    }
    
    func updateMeasurement(_ type: MeasurementType, value: Int) {
        let valueString = type.values[value]
        
        print("\n🚨 DEBUG:")
        print("Selected value: \(valueString)")
        print("For measurement: \(type)")
        
        if valueString == "-" {
            print("❌ REMOVING measurement for \(type)")
            measurements.removeValue(forKey: type)
            
            // Clear AppStorage values
            switch type {
            case .nitrate:
                nitrateValue = nil
                UserDefaults.standard.removeObject(forKey: "waterQuality.nitrate")
            case .nitrite:
                nitriteValue = nil
                UserDefaults.standard.removeObject(forKey: "waterQuality.nitrite")
            case .pH:
                pHValue = nil
                UserDefaults.standard.removeObject(forKey: "waterQuality.pH")
            case .kh:
                khValue = nil
                UserDefaults.standard.removeObject(forKey: "waterQuality.kh")
            case .gh:
                ghValue = nil
                UserDefaults.standard.removeObject(forKey: "waterQuality.gh")
            }
            
            UserDefaults.standard.synchronize()
            print("📊 Measurements after removal: \(measurements)")
        } else if let doubleValue = Double(valueString.replacingOccurrences(of: ",", with: "")) {
            print("✅ SETTING measurement for \(type) to \(doubleValue)")
            measurements[type] = doubleValue
            print("📊 Measurements after setting: \(measurements)")
        }
    }
} 
