import SwiftUI

struct HealthPlanView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Headline Section
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            Text("HEALTH PLAN")
                                .font(.system(size: 34, weight: .heavy))
                                .foregroundColor(Color(hex: "474747"))
                                .fixedSize(horizontal: true, vertical: false)
                            
                            Text("DEC 22")
                                .font(.system(size: 34, weight: .regular))
                                .foregroundColor(Color(hex: "F18833"))
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        
                        Text("Based on your fish, pond, climate, and more")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "575757"))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 12)
                    .padding(.bottom, 8)
                    
                    // Schedule Box
                    RecommendationBox(
                        title: "Schedule",
                        description: "Twice a week, once a day.",
                        content: {
                            HStack(spacing: 7) {
                                ForEach(0..<8) { index in
                                    Image(systemName: "fork.knife.circle.fill")
                                        .foregroundColor(index == 1 || index == 5 ? Color(hex: "F18833") : .gray.opacity(0.3))
                                        .font(.system(size: 20))
                                }
                            }
                        }
                    )
                    
                    // Food Type Box
                    RecommendationBox(
                        title: "Food Type",
                        description: "One brief sentence describing your decision.",
                        content: {
                            HStack(spacing: 6) {
                                Image(systemName: "fork.knife.circle.fill")
                                    .foregroundColor(Color(hex: "F18833"))
                                Text("Low Protein - Spring and Fall")
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                        }
                    )
                    
                    // Aggression Box
                    RecommendationBox(
                        title: "Help with aggression",
                        description: "Consult veterinarian if aggression persists.",
                        content: {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(Color(hex: "F18833"))
                                .font(.system(size: 20))
                        },
                        isCompact: true
                    )
                    
                    // General Happiness Box
                    RecommendationBox(
                        title: "General Happiness",
                        description: "One brief sentence describing your advice.",
                        content: {
                            Image(systemName: "heart.fill")
                                .foregroundColor(Color(hex: "F18833"))
                                .font(.system(size: 20))
                        },
                        isCompact: true
                    )
                    
                    // Optional Treats Box
                    RecommendationBox(
                        title: "Optional treats - Feed sparingly",
                        description: "Low protein, summer food, fun treat but cut in half to prevent choking.",
                        content: {
                            HStack(spacing: 6) {
                                Text("🍇")
                                    .font(.system(size: 17))
                                Text("Grapes")
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                        }
                    )
                }
                .padding()
            }
            .navigationTitle("Health Plan")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground))
        }
    }
}

// Reusable component for recommendation boxes
struct RecommendationBox<Content: View>: View {
    let title: String
    let description: String
    let content: () -> Content
    var isCompact: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if isCompact {
                HStack(spacing: 6) {
                    content()
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text(description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            } else {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                content()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
} 