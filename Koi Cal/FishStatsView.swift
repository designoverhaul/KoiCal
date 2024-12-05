import SwiftUI

struct FishStatsView: View {
    @StateObject private var feedingData = FeedingData()
    @StateObject private var xaiService = XAIService()
    @StateObject private var weatherManager = WeatherManager()
    @StateObject private var locationManager = LocationManager()
    @State private var selectedAgeGroup = "Mixed"
    @State private var selectedObjectives = Set<String>()
    @State private var selectedProblems = Set<String>()
    @AppStorage("useCelsius") private var useCelsius = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Fish Age Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Age of Fish")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Picker("", selection: $selectedAgeGroup) {
                            ForEach(["Juvenile", "Adult", "Mixed"], id: \.self) { age in
                                Text(age).tag(age)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Primary Objective Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("What are your primary objectives?")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            ForEach([
                                "Improved Color",
                                "General Health",
                                "Growth and Breeding",
                                "Improved Behavior"
                            ], id: \.self) { objective in
                                Button(action: {
                                    if selectedObjectives.contains(objective) {
                                        selectedObjectives.remove(objective)
                                    } else {
                                        selectedObjectives.insert(objective)
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: selectedObjectives.contains(objective) ? "checkmark.square.fill" : "square")
                                            .foregroundColor(selectedObjectives.contains(objective) ? Color(hex: "F18833") : .gray)
                                        Text(objective)
                                            .foregroundColor(.primary)
                                        Spacer()
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.vertical, 8)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Fish Problems Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Do your fish have any of these problems?")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            ForEach([
                                "Aggression",
                                "Low Energy",
                                "Stunted Growth"
                            ], id: \.self) { problem in
                                Button(action: {
                                    if selectedProblems.contains(problem) {
                                        selectedProblems.remove(problem)
                                    } else {
                                        selectedProblems.insert(problem)
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: selectedProblems.contains(problem) ? "checkmark.square.fill" : "square")
                                            .foregroundColor(selectedProblems.contains(problem) ? Color(hex: "F18833") : .gray)
                                        Text(problem)
                                            .foregroundColor(.primary)
                                        Spacer()
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.vertical, 8)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("Fish Stats")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground))
        }
    }
} 
