import SwiftUI

struct HeaderView: View {
    let title: String
    let subtitle: String
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
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
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
            .background {
                Color(.systemBackground)
                    .opacity(scrollOffset > 0 ? 0.9 : 1.0)
                    .blur(radius: scrollOffset > 0 ? 3 : 0)
                    .ignoresSafeArea()
            }
            .onChange(of: geometry.frame(in: .global).minY) { _, newValue in
                scrollOffset = -newValue
            }
        }
        .frame(height: 90)
    }
} 