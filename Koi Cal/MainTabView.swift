import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 2  // Start on Feeding History tab
    
    // Define colors as constants
    private let inactiveColor = Color(hex: "A1A1A1")
    private let activeColor = Color(hex: "F18833")
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Fish Stats Tab
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
                    Text("Fish Stats")
                } icon: {
                    Image(systemName: "fish")
                        .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                }
            }
            .tag(0)
            
            // Pond Stats Tab (Coming Soon)
            VStack(spacing: 20) {
                Text("Coming Soon!")
                    .font(.title)
                    .foregroundColor(.secondary)
                
                Image(systemName: "water.waves")
                    .font(.system(size: 60))
                    .foregroundColor(activeColor)
            }
            .tabItem {
                Label {
                    Text("Pond Stats")
                } icon: {
                    Image(systemName: "water.waves")
                        .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
                }
            }
            .tag(1)
            
            // Feeding History Tab (Main Content)
            ContentView()
                .tabItem {
                    Label {
                        Text("Feeding History")
                    } icon: {
                        Image(systemName: "calendar")
                            .environment(\.symbolVariants, selectedTab == 2 ? .fill : .none)
                    }
                }
                .tag(2)
            
            // Health Plan Tab (Coming Soon)
            VStack(spacing: 20) {
                Text("Coming Soon!")
                    .font(.title)
                    .foregroundColor(.secondary)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 60))
                    .foregroundColor(activeColor)
            }
            .tabItem {
                Label {
                    Text("Health Plan")
                } icon: {
                    Image(systemName: "sparkles")
                        .environment(\.symbolVariants, selectedTab == 3 ? .fill : .none)
                }
            }
            .tag(3)
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