import SwiftUI

struct WaterQualityView: View {
    @EnvironmentObject private var waterQualityManager: WaterQualityManager
    
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
                                // If the value is nil, return the index of "-"
                                if waterQualityManager.measurements[type] == nil {
                                    return type.values.firstIndex(of: "-")
                                }
                                
                                // Otherwise find the closest value
                                if let value = waterQualityManager.measurements[type] {
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
