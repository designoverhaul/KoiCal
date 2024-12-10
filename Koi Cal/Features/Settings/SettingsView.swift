import SwiftUI

struct SettingsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Settings content will go here
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
    }
}
