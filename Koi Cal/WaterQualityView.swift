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
                            get: { waterQualityManager.measurements[type] ?? nil },
                            set: { waterQualityManager.updateMeasurement(type, value: $0) }
                        )
                    )
                }
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
        }
    }
} 