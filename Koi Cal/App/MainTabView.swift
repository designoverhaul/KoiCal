import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @StateObject private var locationManager = LocationManager()
    @StateObject private var feedingData = FeedingData()
    @StateObject private var xaiService = XAIService()
    @StateObject private var weatherManager = WeatherManager()
    @State private var selectedAgeGroup = "Mixed"
    @State private var selectedObjective = "General Health"
    
    private let inactiveColor = Color(hex: "A1A1A1")
    private let activeColor = Color(hex: "F18833")
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Fish Stats Tab
            NavigationView {
                GoalsView()
            }
            .tabItem {
                Label {
                    Text("Goals")
                } icon: {
                    Image(systemName: "fish")
                        .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                }
            }
            .tag(0)
            .onAppear { print("📱 Tab 0: GoalsView appeared") }
            
            // Pond Stats Tab
            NavigationView {
                WaterTestView()
            }
            .tabItem {
                Label {
                    Text("Water Test")
                } icon: {
                    Image(systemName: "drop.fill")
                        .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
                }
            }
            .tag(1)
            .onAppear { print("📱 Tab 1: WaterTestView appeared") }
            
            // Feeding History Tab
            NavigationView {
                FeedingHistoryView()
            }
            .tabItem {
                Label {
                    Text("Feeding History")
                } icon: {
                    Image(systemName: "calendar")
                        .environment(\.symbolVariants, selectedTab == 2 ? .fill : .none)
                }
            }
            .tag(2)
            .onAppear { print("📱 Tab 2: FeedingHistoryView appeared") }
            
            // Health Plan Tab
            NavigationView {
                HealthPlanView()
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
            .onAppear { print("📱 Tab 3: HealthPlanView appeared") }
            
            // Settings Tab
            NavigationView {
                SettingsView(
                    selectedAgeGroup: $selectedAgeGroup,
                    selectedObjective: $selectedObjective,
                    feedingData: feedingData,
                    xaiService: xaiService,
                    weatherManager: weatherManager,
                    locationManager: locationManager
                )
            }
            .tabItem {
                Label {
                    Text("Settings")
                } icon: {
                    Image(systemName: "gear")
                        .environment(\.symbolVariants, selectedTab == 4 ? .fill : .none)
                }
            }
            .tag(4)
            .onAppear { print("📱 Tab 4: SettingsView appeared") }
        }
        .tint(activeColor)
        .onAppear {
            print("📱 MainTabView appeared")
            print("📱 Initial selected tab: \(selectedTab)")
            
            // Set the inactive color for tab items
            let appearance = UITabBarAppearance()
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor(inactiveColor)
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(inactiveColor)]
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        .onChange(of: selectedTab) { oldValue, newValue in
            print("📱 Tab changed from \(oldValue) to \(newValue)")
        }
    }
}
