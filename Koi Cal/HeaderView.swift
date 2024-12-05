import SwiftUI

struct HeaderView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 34, weight: .heavy))
                .foregroundColor(Color(hex: "474747"))
                .fixedSize(horizontal: true, vertical: false)
            
            Text(subtitle)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "575757"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.bottom, 8)
    }
} 