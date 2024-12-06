import SwiftUI

struct WaterMeasurementView: View {
    let type: MeasurementType
    @Binding var selectedValue: Int?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(type.rawValue)
                .font(.system(size: 18, weight: .heavy))
                .foregroundColor(Color(red: 0.34, green: 0.34, blue: 0.34))
            
            // Values row
            HStack(spacing: 0) {
                ForEach(type.values.indices, id: \.self) { index in
                    Text(type.values[index])
                        .font(.system(size: 14))
                        .fontWeight(selectedValue == index ? .bold : .regular)
                        .foregroundColor(Color(red: 0.17, green: 0.17, blue: 0.17))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 4)
            
            // Color squares row
            HStack(spacing: 5.48) {
                ForEach(type.colors.indices, id: \.self) { index in
                    Rectangle()
                        .fill(type.colors[index])
                        .frame(width: 46, height: 46)
                        .overlay(
                            Rectangle()
                                .stroke(Color(red: 0.34, green: 0.34, blue: 0.34), lineWidth: selectedValue == index ? 1.25 : 0)
                        )
                        .onTapGesture {
                            selectedValue = index
                        }
                }
            }
            
            Text(type.description)
                .font(.system(size: 11))
                .foregroundColor(Color(red: 0.44, green: 0.44, blue: 0.44))
                .padding(.top, 8)
        }
        .padding()
    }
} 