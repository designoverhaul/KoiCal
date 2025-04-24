import SwiftUI

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userPreferences: UserPreferences
    
    var body: some View {
        NavigationStack {
            WatermelonView()
                .navigationBarBackButtonHidden(true)
                .environmentObject(userPreferences)
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(UserPreferences())
} 