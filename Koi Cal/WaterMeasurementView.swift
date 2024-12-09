import SwiftUI

struct WaterMeasurementView: View {
    let type: MeasurementType
    @Binding var selectedValue: Int?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title with different font weights
            HStack(spacing: 4) {
                switch type {
                case .nitrate:
                    Text("NO₃")
                        .font(.system(size: 18, weight: .heavy))
                    Text("Nitrate")
                        .font(.system(size: 18, weight: .regular))
                case .nitrite:
                    Text("NO₂")
                        .font(.system(size: 18, weight: .heavy))
                    Text("Nitrite")
                        .font(.system(size: 18, weight: .regular))
                case .phLow:
                    Text("pH")
                        .font(.system(size: 18, weight: .heavy))
                case .kh:
                    Text("KH")
                        .font(.system(size: 18, weight: .heavy))
                    Text("Carbonate Hardness")
                        .font(.system(size: 18, weight: .regular))
                case .gh:
                    Text("GH")
                        .font(.system(size: 18, weight: .heavy))
                    Text("General Hardness")
                        .font(.system(size: 18, weight: .regular))
                }
            }
            
            // Color boxes
            HStack(spacing: 4) {
                ForEach(0..<type.values.count, id: \.self) { index in
                    if !type.values[index].isEmpty {
                        Button {
                            selectedValue = index == 0 ? nil : index
                        } label: {
                            VStack(spacing: 4) {
                                Text(type.values[index])
                                    .font(.system(size: 14))
                                    .fontWeight(selectedValue == index ? .bold : .regular)
                                    .foregroundColor(.primary)
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(type.colors[index])
                                    .frame(height: 32)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                            }
                        }
                    } else {
                        // Empty spacer for missing values
                        Color.clear
                            .frame(width: 32)
                    }
                }
            }
            
            // Description
            Text(type.description)
                .font(.system(size: 11))
                .foregroundColor(.gray)
        }
    }
} 