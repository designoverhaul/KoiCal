import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 1  // Start on Feeding History tab
    
    // Define colors as constants
    private let inactiveColor = Color(hex: "A1A1A1")
    private let activeColor = Color(hex: "F18833")
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // The Plan Tab (Coming Soon)
            VStack(spacing: 20) {
                Text("Coming Soon!")
                    .font(.title)
                    .foregroundColor(.secondary)
                
                Image(systemName: "map.fill")
                    .font(.system(size: 60))
                    .foregroundColor(activeColor)
            }
            .tabItem {
                Label {
                    Text("The Plan")
                } icon: {
                    Image(systemName: "map")
                        .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                }
            }
            .tag(0)
            
            // Feeding History Tab (Main Content)
            ContentView()
                .tabItem {
                    Label {
                        Text("Feeding History")
                    } icon: {
                        Image(systemName: "calendar")
                            .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
                    }
                }
                .tag(1)
            
            // Settings Tab
            SettingsView(
                selectedAgeGroup: .constant("Mixed"),
                selectedObjective: .constant("General Health"),
                feedingData: FeedingData(),
                xaiService: XAIService(),
                weatherManager: WeatherManager(),
                locationManager: LocationManager()
            )
            .tabItem {
                Label {
                    Text("Settings")
                } icon: {
                    Image(systemName: "gearshape")
                        .environment(\.symbolVariants, selectedTab == 2 ? .fill : .none)
                }
            }
            .tag(2)
        }
        .tint(activeColor) // Set active color
        .onAppear {
            // Set the inactive color for tab items
            let appearance = UITabBarAppearance()
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor(inactiveColor)
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(inactiveColor)]
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
} 