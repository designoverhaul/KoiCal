import SwiftUI
import Foundation

extension Color {
    static let koiBrown = Color(hex: "58411F")
    static let firstFeeding = Color(hex: "F1DBC4")
    static let secondFeeding = Color(hex: "C0A681")
    static let thirdFeeding = Color(hex: "58411F")
    static let koiOrange = Color(hex: "E26935")
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255.0
        let g = Double((int >> 8) & 0xFF) / 255.0
        let b = Double(int & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
} 