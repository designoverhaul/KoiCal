import SwiftUI
import Lottie

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            LottieAnimationView(animation: .named("splash"))
                .looping()
                .frame(width: 200, height: 200)
        }
    }
}

#Preview {
    LoadingView()
} 