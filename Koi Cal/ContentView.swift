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
    @State private var animations: [UUID] = []
    @StateObject private var weatherManager = WeatherManager()
    @StateObject private var xaiService = XAIService()
    @State private var recommendationState: RecommendationState = .none
    @AppStorage("lastRecommendationDate") private var lastRecommendationDate = Date().timeIntervalSince1970
    @State private var selectedAgeGroup = "Mixed"
    @State private var selectedObjective = "General Health"
    @StateObject private var locationManager = LocationManager()
    @AppStorage("useCelsius") private var useCelsius = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 10) {
                    // Top Bar
                    HStack {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 48)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Water Temp")
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
                                Text(formatTemperature(temp - 4))
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
                            locationManager.requestPermission()
                        }
                        try? await Task.sleep(nanoseconds: 1_000_000_000)
                        await weatherManager.getTemperature(for: locationManager.location)
                        await getRecommendation()
                    }
                    .onChange(of: locationManager.location) { _, newLocation in
                        guard let newLocation else { return }
                        Task {
                            try? await Task.sleep(nanoseconds: 500_000_000)
                            await weatherManager.getTemperature(for: newLocation)
                        }
                    }
                    .onChange(of: weatherManager.currentTemperature) { _, newTemp in
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
                            feedingData.toggleFeeding(for: selectedDate)
                            let animationId = UUID()
                            animations.append(animationId)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                animations.removeAll { $0 == animationId }
                            }
                        }
                        
                        VStack(spacing: 8) {
                            if case .success(let recommendation) = recommendationState {
                                HStack(alignment: .top, spacing: 12) {
                                    VStack(alignment: .center, spacing: 4) {
                                        Image(systemName: "sparkles")
                                            .font(.system(size: 32))
                                            .foregroundColor(Color.koiOrange)
                                        
                                        VStack(alignment: .center, spacing: 0) {
                                            Text(monthString())
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                            Text(dayString())
                                                .font(.title)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .frame(width: 60)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Today's Recommendation")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                        
                                        Text(recommendation)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .lineSpacing(2)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                    .padding(.trailing, 8)
                                }
                                .padding(.vertical, 16)
                                .padding(.horizontal, 12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            } else if case .loading = recommendationState {
                                HStack(alignment: .center, spacing: 12) {
                                    ProgressView()
                                        .padding(.horizontal, 8)
                                    
                                    Text("Loading recommendation...")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 6)
                                .padding(.horizontal, 6)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            } else {
                                Text("Loading feeding recommendation...")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 6)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 8)
                    }
                    .padding(.horizontal, 4)
                    .padding(.top, -2)
                    
                    CustomCalendarView(selectedDate: $selectedDate, feedingData: feedingData)
                        .padding(.horizontal)
                        .padding(.bottom, -17)
                    
                    // Feeding entries list
                    LazyVStack(spacing: 0) {
                        ForEach(feedingData.getEntries(for: selectedDate)
                            .sorted(by: { $0.date > $1.date })) { entry in
                                FeedingEntryView(entry: entry) {
                                    feedingData.deleteEntry(entry)
                                }
                                .padding(.vertical, 0)
                                
                                if entry != feedingData.getEntries(for: selectedDate)
                                    .sorted(by: { $0.date > $1.date })
                                    .last {
                                    Divider()
                                        .padding(.horizontal)
                                }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Feeding History")
            .navigationBarTitleDisplayMode(.inline)
        }
        .overlay {
            ForEach(animations, id: \.self) { id in
                FallingPelletsView()
            }
        }
    }
    
    private func monthString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: Date()).uppercased()
    }
    
    private func dayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: Date())
    }
    
    func getRecommendation() async {
        guard let temperature = weatherManager.currentTemperature else {
            recommendationState = .error("Unable to get temperature data")
            return
        }
        
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
        
        recommendationState = .loading
        
        do {
            let recommendation = try await xaiService.getRecommendation(
                temperature: temperature,
                fishAge: selectedAgeGroup,
                objective: selectedObjective,
                location: locationManager.cityName,
                feedingHistory: historyText
            )
            await MainActor.run {
                recommendationState = .success(recommendation)
            }
        } catch {
            await MainActor.run {
                recommendationState = .error("Unable to get feeding recommendation")
            }
        }
    }
    
    func formatTemperature(_ fahrenheit: Double) -> String {
        if useCelsius {
            let celsius = (fahrenheit - 32) * 5/9
            return String(format: "%.0f°C", celsius)
        } else {
            return String(format: "%.0f°F", fahrenheit)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

