import SwiftUI

struct WaterQualityView: View {
    @StateObject private var waterQualityManager = WaterQualityManager()
    
    // Define the order of measurements
    private let orderedMeasurements: [MeasurementType] = [
        .nitrate,
        .nitrite,
        .pH,
        .kh,
        .gh
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(orderedMeasurements, id: \.self) { type in
                    WaterMeasurementView(
                        type: type,
                        selectedValue: Binding(
                            get: { 
                                if let value = waterQualityManager.measurements[type] {
                                    // Find the index of the closest value
                                    return type.values.firstIndex { valueStr in
                                        if let doubleValue = Double(valueStr.replacingOccurrences(of: ",", with: "")) {
                                            return abs(doubleValue - value) < 0.01
                                        }
                                        return false
                                    }
                                }
                                return nil
                            },
                            set: { newValue in
                                if let index = newValue {
                                    waterQualityManager.updateMeasurement(type, value: index)
                                }
                            }
                        )
                    )
                }
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
        }
    }
}
