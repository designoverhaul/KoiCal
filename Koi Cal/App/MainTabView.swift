import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HealthPlanView()
                .tabItem {
                    Label("Health Plan", systemImage: "heart.fill")
                }
                .tag(0)
                .onAppear {
                    print("📱 Tab 0: HealthPlanView appeared")
                }
            
            // ... other tabs ...
        }
        .onAppear {
            print("📱 MainTabView appeared")
            print("📱 Initial selected tab: \(selectedTab)")
        }
        .onChange(of: selectedTab) { oldValue, newValue in
            print("📱 Tab changed from \(oldValue) to \(newValue)")
        }
    }
} 
