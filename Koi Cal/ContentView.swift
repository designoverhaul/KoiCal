//
//  ContentView.swift
//  Koi Cal
//
//  Created by Aaron Heine on 11/14/24 you don't understand I'm telling why understand tutorial release 207.
//

import SwiftUI
import WeatherKit
import CoreLocation

enum RecommendationState {
    case loading
    case success(String)
    case error(String)
    case none
}

struct ContentView: View {
    @State private var selectedDate = Date()
    @StateObject private var feedingData = FeedingData()
    @State private var showingFeedingGuide = false
    @State private var animations: [UUID] = []
    @State private var showingSettings = false
    @StateObject private var weatherManager = WeatherManager()
    @StateObject private var xaiService = XAIService()
    @State private var recommendationState: RecommendationState = .none
    @AppStorage("lastRecommendationDate") private var lastRecommendationDate = Date().timeIntervalSince1970
    @State private var selectedAgeGroup = "Mixed"
    @State private var selectedObjective = "General Health"
    @StateObject private var locationManager = LocationManager()
    @AppStorage("useCelsius") private var useCelsius = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                // Top Bar
                HStack {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 48)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("7 Day Avg")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        if locationManager.authorizationStatus == .notDetermined {
                            Button("Enable Location") {
                                locationManager.requestPermission()
                            }
                            .font(.caption)
                        } else if locationManager.authorizationStatus == .denied {
                            Text("Location Access Denied")
                                .font(.caption)
                                .foregroundColor(.red)
                        } else if let temp = weatherManager.currentTemperature {
                            Text(formatTemperature(temp))
                                .font(.title)
                        } else {
                            Text(useCelsius ? "--°C" : "--°F")
                                .font(.title)
                        }
                    }
                }
                .padding(.horizontal)
                .task {
                    if locationManager.location == nil {
                        print("No location available yet")
                        locationManager.requestPermission()
                    }
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    await weatherManager.getTemperature(for: locationManager.location)
                    print("🔍 Checking for new recommendation on app launch")
                    await getRecommendation()  // Force an initial recommendation
                }
                .onChange(of: locationManager.location) { _, newLocation in
                    guard let newLocation else { return }
                    print("Location changed to: \(newLocation.coordinate)")
                    Task {
                        try? await Task.sleep(nanoseconds: 500_000_000)
                        await weatherManager.getTemperature(for: newLocation)
                    }
                }
                .onChange(of: weatherManager.currentTemperature) { _, newTemp in
                    print("🌡️ Temperature changed to: \(String(describing: newTemp))")
                    if newTemp != nil {
                        weatherManager.objectWillChange.send()
                        if !Calendar.current.isDateInToday(Date(timeIntervalSince1970: lastRecommendationDate)) {
                            Task {
                                await getRecommendation()
                                lastRecommendationDate = Date().timeIntervalSince1970
                            }
                        }
                    }
                }
                
                // Food Image and Recommendation
                VStack(spacing: 12) {
                    GeometryReader { geometry in
                        Image("fishsFood")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 210)
                            .frame(maxWidth: .infinity)
                    }
                    .frame(height: 80)
                    .onTapGesture {
                        print("Food tapped")
                        feedingData.toggleFeeding(for: selectedDate)
                        let animationId = UUID()
                        print("Adding animation: \(animationId)")
                        animations.append(animationId)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            print("Removing animation: \(animationId)")
                            animations.removeAll { $0 == animationId }
                        }
                    }
                    
                    VStack(spacing: 8) {
                        Text(selectedDate.formatted(.dateTime.month(.wide).day().year()))
                            .font(.caption)
                            .foregroundColor(Color.koiOrange)
                            .textCase(.uppercase)
                            .kerning(2)
                        
                        if case .success(let recommendation) = recommendationState {
                            HStack(alignment: .top, spacing: 4) {
                                Image(systemName: "sparkles")
                                    .foregroundColor(Color.koiOrange)
                                    .font(.system(size: 20))
                                
                                Text(recommendation)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(.vertical, 6)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        } else if case .loading = recommendationState {
                            ProgressView()
                                .padding(.vertical, 6)
                                .padding(.horizontal, 16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .padding(.horizontal)
                        } else {
                            Text("Loading feeding recommendation...")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal)
                .padding(.top, -10)
                
                // Snack Time section
                HStack(alignment: .center, spacing: 12) {
                    Text("🍒")
                        .font(.system(size: 32))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 4) {
                            Text("Snack Time!")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text("- Feed in moderation")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Text("Cherries are a low protein summer food. Please remove seeds.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineSpacing(2)
                    }
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                CustomCalendarView(selectedDate: $selectedDate, feedingData: feedingData)
                    .padding(.horizontal)
                    .padding(.top, -10)
                
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(feedingData.getEntries(for: selectedDate).sorted(by: { $0.date > $1.date })) { entry in
                            FeedingEntryView(entry: entry) {
                                feedingData.deleteEntry(entry)
                            }
                            
                            Divider()
                                .padding(.horizontal)
                        }
                    }
                }
                .frame(maxHeight: 200)
                .padding(.top, -10)
                
                Spacer()
                
                // Bottom Navigation
                HStack {
                    Button(action: { showingFeedingGuide = true }) {
                        Image(systemName: "graduationcap.fill")
                            .font(.title2)
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                    
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
                            .foregroundStyle(.gray)
                    }
                    .sheet(isPresented: $showingSettings) {
                        SettingsView(
                            selectedAgeGroup: $selectedAgeGroup,
                            selectedObjective: $selectedObjective,
                            feedingData: feedingData,
                            xaiService: xaiService,
                            weatherManager: weatherManager,
                            locationManager: locationManager
                        )
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom)
            }
            .zIndex(0)
            
            ForEach(animations, id: \.self) { id in
                FallingPelletsView()
                    .onAppear { print("Pellets view appeared for: \(id)") }
            }
            .zIndex(1)
            
            if showingFeedingGuide {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .zIndex(2)
                    .onTapGesture {
                        showingFeedingGuide = false
                    }
                
                FeedingGuideView {
                    showingFeedingGuide = false
                }
                .transition(.opacity)
                .zIndex(3)
            }
        }
    }
    
    private func getRecommendation() async {
        guard let temperature = weatherManager.currentTemperature else {
            print("❌ No temperature data available")
            recommendationState = .error("Unable to get temperature data")
            return
        }
        
        print("🌡️ Getting recommendation for temp: \(temperature)°F")
        
        // Get feeding history for the last week
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let weekHistory = (0...6).map { dayOffset -> (date: Date, count: Int) in
            let date = calendar.date(byAdding: .day, value: -dayOffset, to: today)!
            return (date: date, count: feedingData.getFeedingCount(for: date))
        }
        
        // Format feeding history for the AI
        let historyText = weekHistory
            .map { date, count in
                let dayString: String
                if calendar.isDateInToday(date) {
                    dayString = "today"
                } else if calendar.isDateInYesterday(date) {
                    dayString = "yesterday"
                } else {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "EEEE"
                    dayString = formatter.string(from: date).lowercased()
                }
                return "\(count) times \(dayString)"
            }
            .joined(separator: ", ")
        
        print("📅 Feeding history: \(historyText)")
        recommendationState = .loading
        
        do {
            print("🤖 Calling XAI service...")
            let recommendation = try await xaiService.getRecommendation(
                temperature: temperature,
                fishAge: selectedAgeGroup,
                objective: selectedObjective,
                location: locationManager.cityName,
                feedingHistory: historyText
            )
            print("✅ Got recommendation: \(recommendation)")
            await MainActor.run {
                recommendationState = .success(recommendation)
            }
        } catch {
            print("❌ Error getting recommendation: \(error)")
            await MainActor.run {
                recommendationState = .error("Unable to get feeding recommendation")
            }
        }
    }
    
    private func checkForNewRecommendation() {
        let calendar = Calendar.current
        let lastDate = Date(timeIntervalSince1970: lastRecommendationDate)
        
        print("🔄 Checking if new recommendation needed")
        print("   Last recommendation: \(lastDate)")
        print("   Is today? \(calendar.isDateInToday(lastDate))")
        
        // Only get a new recommendation if it's a new day
        if !calendar.isDateInToday(lastDate) {
            print("📅 Getting new recommendation for new day")
            Task {
                await getRecommendation()
                // Update the timestamp after successful recommendation
                lastRecommendationDate = Date().timeIntervalSince1970
            }
        } else {
            print("⏭️ Skipping recommendation - already have one for today")
        }
    }
    
    private func formatTemperature(_ fahrenheit: Double) -> String {
        if useCelsius {
            let celsius = (fahrenheit - 32) * 5/9
            return String(format: "%.0f°C", celsius)
        } else {
            return String(format: "%.0f°F", fahrenheit)
        }
    }
}

#Preview {
    ContentView()
}
