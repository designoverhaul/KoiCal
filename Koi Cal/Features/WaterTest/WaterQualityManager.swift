class WaterQualityManager: ObservableObject {
    @Published var measurements: [MeasurementType: Int] = [:] {
        didSet {
            // Save values to persistent storage
            UserDefaults.standard.set(measurements[.nitrate] ?? 0, forKey: "waterQuality_nitrate")
            UserDefaults.standard.set(measurements[.nitrite] ?? 0, forKey: "waterQuality_nitrite")
            UserDefaults.standard.set(measurements[.phLow] ?? 0, forKey: "waterQuality_ph")
            UserDefaults.standard.set(measurements[.kh] ?? 0, forKey: "waterQuality_kh")
            UserDefaults.standard.set(measurements[.gh] ?? 0, forKey: "waterQuality_gh")
        }
    }
    
    init() {
        // Initialize measurements with stored values
        measurements = [
            .nitrate: UserDefaults.standard.integer(forKey: "waterQuality_nitrate"),
            .nitrite: UserDefaults.standard.integer(forKey: "waterQuality_nitrite"),
            .phLow: UserDefaults.standard.integer(forKey: "waterQuality_ph"),
            .kh: UserDefaults.standard.integer(forKey: "waterQuality_kh"),
            .gh: UserDefaults.standard.integer(forKey: "waterQuality_gh")
        ]
    }
    
    func getWaterQuality() -> WaterQuality {
        let quality = WaterQuality(
            nitrate: getMeasurementValue(for: .nitrate),
            nitrite: getMeasurementValue(for: .nitrite),
            ph: getMeasurementValue(for: .phLow),
            carbonateHardness: getMeasurementValue(for: .kh),
            generalHardness: getMeasurementValue(for: .gh)
        )
        return quality
    }
    
    private func getMeasurementValue(for type: MeasurementType) -> Double? {
        guard let index = measurements[type], index > 0 else { return nil }
        return Double(type.values[index].replacingOccurrences(of: "-", with: ""))
    }
    
    func updateMeasurement(_ type: MeasurementType, value: Int) {
        measurements[type] = value
    }
} 