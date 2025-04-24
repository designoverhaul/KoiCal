import SwiftUI

struct MainTabView: View {
    @StateObject private var feedingData = FeedingData()
    @StateObject private var xaiService = XAIService()
    @StateObject private var weatherManager = WeatherManager()
    @StateObject private var waterQualityManager = WaterQualityManager()
    @StateObject private var tabRouter = TabRouter()
    @State private var isPulsing = false
    
    private let inactiveColor = Color(hex: "A1A1A1")
    private let activeColor = Color(hex: "F18833")
    
    var body: some View {
        ZStack(alignment: .bottom) {
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
                
                // Health Plan Tab - use empty strings for label to reserve space
                NavigationView {
                    HealthPlanView()
                        .environmentObject(feedingData)
                        .environmentObject(waterQualityManager)
                        .environmentObject(tabRouter)
                }
                .tabItem {
                    Label {
                        Text(" ")
                    } icon: {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 0.1)) // Tiny icon that's effectively invisible
                            .opacity(0.01)
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
                
                // Set up tab bar appearance
                let appearance = UITabBarAppearance()
                appearance.stackedLayoutAppearance.normal.iconColor = UIColor(inactiveColor)
                appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(inactiveColor)]
                UITabBar.appearance().standardAppearance = appearance
                UITabBar.appearance().scrollEdgeAppearance = appearance
                
                // Start pulsing animation for the center button
                isPulsing = true
            }
            .onChange(of: tabRouter.selectedTab) { oldValue, newValue in
                print("📱 Tab changed from \(oldValue) to \(newValue)")
            }
            
            // Custom Health Plan button positioned above the tab bar
            Button {
                tabRouter.selectedTab = 2 // Health Plan tab
                
                // Add haptic feedback when tapped
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
            } label: {
                ZStack {
                    // Outer glow when selected
                    if tabRouter.selectedTab == 2 {
                        Circle()
                            .fill(Color(hex: "F18833").opacity(0.2))
                            .frame(width: 65, height: 65)
                            .scaleEffect(isPulsing ? 1.08 : 1.03)
                            .animation(
                                Animation.easeInOut(duration: 1.2)
                                    .repeatForever(autoreverses: true),
                                value: isPulsing
                            )
                    }
                    
                    // Main button content
                    VStack(spacing: 4) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 28))
                            .environment(\.symbolVariants, .fill)
                    }
                    .frame(width: 54, height: 54)
                    .foregroundColor(.white)
                    .background(
                        Circle()
                            .fill(tabRouter.selectedTab == 2 ? Color(hex: "F18833") : Color(hex: "F18833").opacity(0.85))
                    )
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                    )
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                }
                .scaleEffect(tabRouter.selectedTab == 2 ? 1.05 : 1.0)
                .animation(.spring(response: 0.3), value: tabRouter.selectedTab)
            }
            .offset(y: -5) // Align bottom with other tab items
        }
    }
}

class TabRouter: ObservableObject {
    @Published var selectedTab = 0
    
    func switchToSettings() {
        selectedTab = 4  // Index of Settings tab
    }
}
