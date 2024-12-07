import SwiftUI
import Lottie

struct SplashScreenView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            LottieView(animationName: "Two_Koi")
                .frame(width: 340, height: 340)
                .onAppear {
                    print("🎬 Animation view appeared")
                }
        }
        .onAppear {
            print("🎬 SplashScreen appeared")
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.3) {
                withAnimation(.easeOut(duration: 0.3)) {
                    isPresented = false
                }
            }
        }
    }
}

public struct LottieView: UIViewRepresentable {
    let animationName: String
    
    public init(animationName: String) {
        self.animationName = animationName
    }
    
    public func makeUIView(context: Context) -> LottieAnimationView {
        print("📂 Attempting to load animation: \(animationName)")
        
        // Create animation view with specific size
        let animationView = LottieAnimationView()
        animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        
        // Try loading the dotLottie file
        DotLottieFile.loadedFrom(filepath: Bundle.main.path(forResource: animationName, ofType: "lottie") ?? "") { result in
            switch result {
            case .success(let dotLottie):
                print("✅ Successfully loaded .lottie animation")
                animationView.loadAnimation(from: dotLottie)
                configureAnimationView(animationView)
            case .failure(let error):
                print("❌ Failed to load .lottie animation: \(error)")
                if let animation = LottieAnimation.named(animationName) {
                    print("✅ Successfully loaded animation using named method")
                    animationView.animation = animation
                    configureAnimationView(animationView)
                }
            }
        }
        
        return animationView
    }
    
    public func updateUIView(_ uiView: LottieAnimationView, context: Context) {
        if !uiView.isAnimationPlaying {
            uiView.play()
        }
    }
    
    private func configureAnimationView(_ view: LottieAnimationView) {
        view.contentMode = .scaleAspectFit
        view.loopMode = .playOnce
        view.backgroundBehavior = .pauseAndRestore
        
        // Set explicit bounds to control size
        view.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
        
        // Ensure proper scaling
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        view.play()
    }
    
    private func printBundleContents() {
        guard let resourcePath = Bundle.main.resourcePath else {
            print("Unable to access bundle resource path")
            return
        }
        
        print("\n📁 Files in bundle root:")
        do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: resourcePath)
            contents.forEach { print("Found: \($0)") }
            
            // Also check if the file exists directly
            let lottiePath = resourcePath + "/Two_Koi.lottie"
            let exists = FileManager.default.fileExists(atPath: lottiePath)
            print("\nDoes Two_Koi.lottie exist at path? \(exists)")
            
            if exists {
                print("File attributes:")
                let attributes = try FileManager.default.attributesOfItem(atPath: lottiePath)
                print(attributes)
            }
        } catch {
            print("Error reading bundle contents: \(error)")
        }
    }
} 
