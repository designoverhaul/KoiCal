import SwiftUI

struct HeaderView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title.uppercased())
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(hex: "565656"))
                .tracking(0.5)
            
            if !subtitle.isEmpty {
                Text(subtitle)
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
        }
    }
}

extension View {
    func koiHeaderStyle(title: String, subtitle: String = "") -> some View {
        modifier(HeaderView(title: title, subtitle: subtitle))
    }
} 