import SwiftUI
import AVFoundation

struct WaterMeasurementView: View {
    let type: MeasurementType
    @Binding var selectedValue: Int?
    private let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
    private var audioPlayer: AVAudioPlayer?
    
    init(type: MeasurementType, selectedValue: Binding<Int?>) {
        self.type = type
        self._selectedValue = selectedValue
        
        // Set up audio session
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
        
        // Initialize audio player
        if let soundURL = Bundle.main.url(forResource: "tick", withExtension: "wav") {
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.prepareToPlay()
            } catch {
                print("Error loading sound: \(error)")
            }
        }
    }
    
    private func playTickSound() {
        audioPlayer?.play()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Title with different font weights
            HStack(spacing: 4) {
                Text(type.splitTitle.symbol)
                    .font(.system(size: 18, weight: .heavy))
                
                if let name = type.splitTitle.name {
                    Text(name)
                        .font(.system(size: 18, weight: .regular))
                }
            }
            
            // Values row
            HStack(spacing: 0) {
                ForEach(type.values.indices, id: \.self) { index in
                    Text(type.values[index])
                        .font(.system(size: 14))
                        .fontWeight(selectedValue == index ? .bold : .regular)
                        .foregroundColor(Color(red: 0.17, green: 0.17, blue: 0.17))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 4)
            
            // Color squares row
            HStack(spacing: 4) {
                ForEach(type.colors.indices, id: \.self) { index in
                    Rectangle()
                        .fill(type.colors[index])
                        .frame(width: 40, height: 40)
                        .overlay(
                            ZStack {
                                Rectangle()
                                    .stroke(Color(red: 0.34, green: 0.34, blue: 0.34), lineWidth: selectedValue == index ? 1.85 : 0)
                                
                                // Warning triangles
                                if ((type == .nitrite && type.values[index] == "3") ||
                                    (type == .nitrite && type.values[index] == "5") ||
                                    (type == .nitrite && type.values[index] == "10")) ||
                                   (type == .nitrate && type.values[index] == "160") ||
                                   (type == .nitrate && type.values[index] == "200") ||
                                   (type == .pH && type.values[index] == "6.0") ||
                                   (type == .pH && type.values[index] == "9.0") ||
                                   (type == .gh && type.values[index] == "0") ||
                                   (type == .gh && type.values[index] == "180") ||
                                   (type == .kh && type.values[index] == "0") ||
                                   (type == .kh && type.values[index] == "40") ||
                                   (type == .kh && type.values[index] == "240") {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.yellow)
                                        .font(.system(size: 20))
                                        .position(x: 20, y: 20)
                                        .shadow(color: .black.opacity(0.3), radius: 1, x: 1, y: 1)
                                }
                                
                                // Nil indicator for "-" values
                                if type.values[index] == "-" {
                                    Image(systemName: "slash.circle")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 16))
                                        .position(x: 20, y: 20)
                                }
                            }
                        )
                        .onTapGesture {
                            hapticFeedback.impactOccurred()
                            playTickSound()
                            selectedValue = index
                        }
                }
            }
            .frame(maxWidth: .infinity)
            
            Text(type.description)
                .font(.system(size: 11))
                .foregroundColor(Color(red: 0.44, green: 0.44, blue: 0.44))
                .padding(.top, 8)
        }
        .padding()
    }
} 


#Preview {
    NavigationView {
        WaterTestView()
    }
}
