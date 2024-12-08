import SwiftUI

struct FallingPelletsView: View {
    let numberOfPellets = Int.random(in: 10...15)
    @State private var startAnimation = false
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<numberOfPellets, id: \.self) { index in
                let xPosition = CGFloat.random(in: 0...geometry.size.width)
                let delay = Double.random(in: 0...0.3)
                
                Image("Single-Fish-Food")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .position(x: xPosition, y: startAnimation ? geometry.size.height + 50 : -50)
                    .animation(
                        .linear(duration: 2)
                        .delay(delay),
                        value: startAnimation
                    )
            }
        }
        .ignoresSafeArea()
        .onAppear {
            startAnimation = true
        }
    }
} 