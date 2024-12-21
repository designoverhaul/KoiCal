import SwiftUI

struct OnboardingProblemsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Do your fish have any problems I should know about?")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                Button("Next") {
                    // Handle next action
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .navigationBarItems(leading: Button("Cancel") {
                dismiss()
            })
        }
    }
} 