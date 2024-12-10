import SwiftUI

struct InfoCardView: View {
    let title: String
    let content: String
    let showSparkle: Bool
    
    init(
        title: String,
        content: String,
        showSparkle: Bool = true
    ) {
        self.title = title
        self.content = content
        self.showSparkle = showSparkle
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title.uppercased())
                    .font(.system(size: 13))
                    .foregroundColor(Color(red: 0.44, green: 0.44, blue: 0.44))
                
                Spacer()
                
                if showSparkle {
                    Image(systemName: "sparkle")
                        .foregroundColor(.orange)
                }
            }
            
            Text(content)
                .font(.system(size: 14))
                .lineSpacing(21.70)
                .foregroundColor(Color(red: 0.34, green: 0.34, blue: 0.34))
        }
        .padding(EdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14))
        .frame(maxWidth: .infinity)
        .frame(height: 70)
        .background(.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .inset(by: 1.50)
                .stroke(Color(red: 0.93, green: 0.93, blue: 0.93), lineWidth: 1.50)
        )
        .shadow(
            color: Color(red: 0.10, green: 0.26, blue: 0.07, opacity: 0.08), 
            radius: 13, 
            y: 4
        )
    }
} 