import SwiftUI

struct MainTabView: View {
    @StateObject private var feedingData = FeedingData()
    @StateObject private var xaiService = XAIService()
    @StateObject private var weatherManager = WeatherManager()
    @StateObject private var waterQualityManager = WaterQualityManager()
    @StateObject private var tabRouter = TabRouter()
    
    private let inactiveColor = Color(hex: "A1A1A1")
    private let activeColor = Color(hex: "F18833")
    
    var body: some View {
        TabView(selection: $tabRouter.selectedTab) {
            // Feeding History Tab
            NavigationView {
                FeedingHistoryView()
                    .environmentObject(feedingData)
            }
            .tabItem {
                Label {
                    Text("Koi Cal")
                } icon: {
                    Image(systemName: "calendar")
                        .environment(\.symbolVariants, tabRouter.selectedTab == 0 ? .fill : .none)
                }
            }
            .tag(0)
            .onAppear { print("📱 Tab 0: FeedingHistoryView appeared") }
            
            // Goals Tab
            NavigationView {
                GoalsView()
            }
            .tabItem {
                Label {
                    Text("Goals")
                } icon: {
                    Image(systemName: "fish")
                        .environment(\.symbolVariants, tabRouter.selectedTab == 1 ? .fill : .none)
                }
            }
            .tag(1)
            .onAppear { print("📱 Tab 1: GoalsView appeared") }
            
            // Health Plan Tab
            NavigationView {
                HealthPlanView()
                    .environmentObject(feedingData)
                    .environmentObject(waterQualityManager)
                    .environmentObject(tabRouter)
            }
            .tabItem {
                Label {
                    Text("Health Plan")
                } icon: {
                    Image(systemName: "sparkles")
                        .environment(\.symbolVariants, tabRouter.selectedTab == 2 ? .fill : .none)
                }
            }
            .tag(2)
            .onAppear { print("📱 Tab 2: HealthPlanView appeared") }
            
            // Water Test Tab
            NavigationView {
                WaterTestView()
                    .environmentObject(waterQualityManager)
            }
            .tabItem {
                Label {
                    Text("Water Test")
                } icon: {
                    Image(systemName: "waterbottle")
                        .environment(\.symbolVariants, tabRouter.selectedTab == 3 ? .fill : .none)
                }
            }
            .tag(3)
            .onAppear { print("📱 Tab 3: WaterTestView appeared") }
            
            // Settings Tab
            NavigationView {
                SettingsView(
                    feedingData: feedingData,
                    xaiService: xaiService,
                    weatherManager: weatherManager
                )
                .environmentObject(waterQualityManager)
            }
            .tabItem {
                Label {
                    Text("Settings")
                } icon: {
                    Image(systemName: "gear")
                        .environment(\.symbolVariants, tabRouter.selectedTab == 4 ? .fill : .none)
                }
            }
            .tag(4)
            .onAppear { print("📱 Tab 4: SettingsView appeared") }
        }
        .environmentObject(waterQualityManager)
        .environmentObject(feedingData)
        .environmentObject(tabRouter)
        .tint(activeColor)
        .onAppear {
            print("📱 MainTabView appeared")
            print("📱 Initial selected tab: \(tabRouter.selectedTab)")
            
            // Set the inactive color for tab items
            let appearance = UITabBarAppearance()
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor(inactiveColor)
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(inactiveColor)]
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        .onChange(of: tabRouter.selectedTab) { oldValue, newValue in
            print("📱 Tab changed from \(oldValue) to \(newValue)")
        }
    }
}

class TabRouter: ObservableObject {
    @Published var selectedTab = 0
    
    func switchToSettings() {
        selectedTab = 4  // Index of Settings tab
    }
}
