import SwiftUI

struct WaterQualityView: View {
    @StateObject private var waterQualityManager = WaterQualityManager()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach(Array(waterQualityManager.measurements.keys), id: \.self) { type in
                    WaterMeasurementView(
                        type: type,
                        selectedValue: Binding(
                            get: { waterQualityManager.measurements[type] ?? 0 },
                            set: { newValue in
                                if let unwrappedValue = newValue {
                                    waterQualityManager.updateMeasurement(type, value: unwrappedValue)
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
