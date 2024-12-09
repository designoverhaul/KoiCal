import SwiftUI

struct WaterMeasurementView: View {
    let type: MeasurementType
    @Binding var selectedValue: Int?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title with different font weights
            HStack(spacing: 4) {
                Text(type.splitTitle.symbol)
                    .font(.system(size: 18, weight: .heavy))
                
                if let name = type.splitTitle.name {
                    Text(name)
                        .font(.system(size: 18, weight: .regular))
                }
            }
            
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
            HStack(spacing: 4) {
                ForEach(type.colors.indices, id: \.self) { index in
                    Rectangle()
                        .fill(type.colors[index])
                        .frame(width: 40, height: 40)
                        .overlay(
                            Rectangle()
                                .stroke(Color(red: 0.34, green: 0.34, blue: 0.34), lineWidth: selectedValue == index ? 1.25 : 0)
                        )
                        .onTapGesture {
                            selectedValue = index
                        }
                }
            }
            .frame(maxWidth: .infinity)
            
            Text(type.description)
                .font(.system(size: 11))
                .foregroundColor(Color(red: 0.44, green: 0.44, blue: 0.44))
                .padding(.top, 8)
        }
        .padding()
    }
} 