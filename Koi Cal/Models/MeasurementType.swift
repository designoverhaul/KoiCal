import SwiftUI

enum MeasurementType: String, CaseIterable {
    case nitrate = "NO₃ Nitrate"
    case nitrite = "NO₂ Nitrite"
    case pH = "pH"
    case kh = "KH Carbonate Hardness"
    case gh = "GH General Hardness"
    
    // Helper property to split the title into chemical symbol and name
    var splitTitle: (symbol: String, name: String?) {
        switch self {
        case .nitrate:
            return ("NO₃", "Nitrate")
        case .nitrite:
            return ("NO₂", "Nitrite")
        case .pH:
            return ("pH", nil)
        case .kh:
            return ("KH", "Carbonate Hardness")
        case .gh:
            return ("GH", "General Hardness")
        }
    }
    
    var description: String {
        switch self {
        case .nitrate:
            return "Nitrate levels indicate the amount of waste products in the water. High levels can be harmful to fish and promote excessive algae growth."
        case .nitrite:
            return "Nitrite is highly toxic to fish and is an intermediate product in the nitrogen cycle. High levels can cause brown blood disease."
        case .pH:
            return "This is the acidity or alkalinity of water; it's crucial because it affects the health, growth, and reproduction of aquatic life."
        case .kh:
            return "KH measures how well water resists pH changes by assessing carbonate and bicarbonate levels, preventing harmful pH shifts for aquatic life."
        case .gh:
            return "General Hardness measures the concentration of dissolved minerals, particularly calcium and magnesium. It affects fish osmoregulation and shell development."
        }
    }
    
    var values: [String] {
        switch self {
        case .nitrate:
            return ["-", "0", "20", "40", "80", "160", "200", ""]
        case .nitrite:
            return ["-", "0", "0.5", "1", "3", "5", "10", ""]
        case .pH:
            return ["-", "6.0", "6.5", "7.0", "7.5", "8.0", "8.5", "9.0"]
        case .kh:
            return ["-", "0", "40", "80", "120", "180", "240", ""]
        case .gh:
            return ["-", "0", "30", "60", "120", "180", "", ""]
        }
    }
    
    var colors: [Color] {
        switch self {
        case .nitrate:
            return [
                Color(red: 0.93, green: 0.93, blue: 0.93),  // Gray for "-"
                Color(hex: "F1E8D7"),  // 0
                Color(hex: "F3E0D4"),  // 20
                Color(hex: "F5D7CD"),  // 40
                Color(hex: "FFC6C4"),  // 80
                Color(hex: "FEADB4"),  // 160
                Color(hex: "FF8EA0"),  // 200
                Color.clear            // Empty
            ]
        case .nitrite:
            return [
                Color(red: 0.93, green: 0.93, blue: 0.93),  // Gray for "-"
                Color(hex: "F1EAD0"),  // 0
                Color(hex: "F2E4D9"),  // 0.5
                Color(hex: "F3DAD3"),  // 1
                Color(hex: "FCC4C4"),  // 3
                Color(hex: "FFB3B7"),  // 5
                Color(hex: "FF8EA1"),  // 10
                Color.clear            // Empty
            ]
        case .pH:
            return [
                Color(red: 0.93, green: 0.93, blue: 0.93),  // Gray for "-"
                Color(hex: "FFC849"),  // 6.0
                Color(hex: "FFB84C"),  // 6.5
                Color(hex: "FE9E45"),  // 7.0
                Color(hex: "FF7345"),  // 7.5
                Color(hex: "FE6152"),  // 8.0
                Color(hex: "FF5753"),  // 8.5
                Color(hex: "FE4E64")   // 9.0
            ]
        case .kh:
            return [
                Color(red: 0.93, green: 0.93, blue: 0.93),  // Gray for "-"
                Color(hex: "F7DE82"),  // 0
                Color(hex: "CFD365"),  // 40
                Color(hex: "AFD3A5"),  // 80
                Color(hex: "9FD1AB"),  // 120
                Color(hex: "8BC7B1"),  // 180
                Color(hex: "6BC5C5"),  // 240
                Color.clear            // Empty
            ]
        case .gh:
            return [
                Color(red: 0.93, green: 0.93, blue: 0.93),  // Gray for "-"
                Color(hex: "8BCCC4"),  // 0
                Color(hex: "59BDBF"),  // 30
                Color(hex: "6CAEC9"),  // 60
                Color(hex: "5C90C2"),  // 120
                Color(hex: "6879C1"),  // 180
                Color.clear,           // Empty
                Color.clear            // Empty
            ]
        }
    }
} 