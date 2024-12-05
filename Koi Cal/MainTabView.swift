import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 2  // Start on Feeding History tab
    @AppStorage("useCelsius") private var useCelsius = false
    @AppStorage("useCentimeters") private var useCentimeters = false
    @StateObject private var locationManager = LocationManager()
    
    // Define colors as constants
    private let inactiveColor = Color(hex: "A1A1A1")
    private let activeColor = Color(hex: "F18833")
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Fish Stats Tab
            FishStatsView()
                .tabItem {
                    Label {
                        Text("Fish Stats")
                    } icon: {
                        Image(systemName: "fish")
                            .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                    }
                }
                .tag(0)
            
            // Pond Stats Tab
            NavigationView {
                ScrollView {
                    VStack(spacing: 24) {
                        HeaderView(
                            title: "POND STATS",
                            subtitle: "Based on your fish, pond, climate, and more"
                        )
                        
                        // Location Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("LOCATION")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.horizontal, 4)
                            
                            HStack {
                                Text("Pond Location")
                                    .foregroundColor(.primary)
                                Spacer()
                                Text(locationManager.cityName)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        
                        // Temperature Unit Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Temperature Unit")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Picker("", selection: $useCelsius) {
                                Text("Fahrenheit").tag(false)
                                Text("Celsius").tag(true)
                            }
                            .pickerStyle(.segmented)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding()
                        
                        // Length Unit Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Length Unit")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Picker("", selection: $useCentimeters) {
                                Text("Feet").tag(false)
                                Text("Centimeters").tag(true)
                            }
                            .pickerStyle(.segmented)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground))
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
            HealthPlanView()
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