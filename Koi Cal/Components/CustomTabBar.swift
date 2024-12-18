import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    let activeColor = Color(hex: "F18833")
    let inactiveColor = Color(hex: "A1A1A1")
    
    var body: some View {
        HStack(spacing: 0) {
            // Koi Cal Tab
            tabButton(image: "calendar", text: "Koi Cal", tag: 0)
            
            // Goals Tab
            tabButton(image: "fish", text: "Goals", tag: 1)
            
            // Health Plan Tab (Center)
            ZStack {
                Circle()
                    .fill(activeColor)
                    .frame(width: 70, height: 70)
                    .offset(y: -20)
                
                VStack(spacing: 4) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .offset(y: -20)
                    
                    Text("Health Plan")
                        .font(.caption2)
                        .foregroundColor(selectedTab == 2 ? activeColor : inactiveColor)
                }
            }
            .frame(width: UIScreen.main.bounds.width / 5)
            .onTapGesture {
                withAnimation {
                    selectedTab = 2
                }
            }
            
            // Water Test Tab
            tabButton(image: "waterbottle", text: "Water Test", tag: 3)
            
            // Settings Tab
            tabButton(image: "gear", text: "Settings", tag: 4)
        }
        .frame(height: 50)
        .background(Color(.systemBackground))
        .clipShape(Rectangle())
    }
    
    private func tabButton(image: String, text: String, tag: Int) -> some View {
        Button {
            withAnimation {
                selectedTab = tag
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: image)
                    .font(.system(size: 24))
                    .foregroundColor(selectedTab == tag ? activeColor : inactiveColor)
                    .environment(\.symbolVariants, selectedTab == tag ? .fill : .none)
                
                Text(text)
                    .font(.caption2)
                    .foregroundColor(selectedTab == tag ? activeColor : inactiveColor)
            }
        }
        .frame(width: UIScreen.main.bounds.width / 5)
    }
} 