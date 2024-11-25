//
//  ContentView.swift
//  Koi Cal
//
//  Created by Aaron Heine on 11/14/24.
//

import SwiftUI
import WeatherKit
import CoreLocation

// Add this enum at the top level
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
    let location = CLLocation(latitude: 33.7490, longitude: -84.3880) // Atlanta coordinates
    @AppStorage("lastRecommendationDate") private var lastRecommendationDate = Date().timeIntervalSince1970
    @State private var selectedAgeGroup = "Mixed"
    @State private var selectedObjective = "General Health"
    @StateObject private var locationManager = LocationManager()
    
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
                            Text(String(format: "%.0f°F", temp))
                                .font(.title)
                        } else {
                            Text("--°F")
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
                    try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
                    await weatherManager.getTemperature(for: locationManager.location)
                    checkForNewRecommendation()
                }
                .onChange(of: locationManager.location) { _, newLocation in
                    guard let newLocation else { return }
                    print("Location changed to: \(newLocation.coordinate)")
                    Task {
                        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
                        await weatherManager.getTemperature(for: newLocation)
                    }
                }
                
                // Add recommendation view below the top bar
                recommendationView
                    .padding(.vertical, 5)
                
                // Food Image (stable position)
                VStack(spacing: 12) {
                    Image("fishsFood")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 240)
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
                    
                    if case .success(let recommendation) = recommendationState {
                        Text(recommendation)
                            .font(.headline)
                    } else if case .loading = recommendationState {
                        ProgressView()
                    } else {
                        Text("Loading feeding recommendation...")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                .padding(.top, -10)
                
                CustomCalendarView(selectedDate: $selectedDate, feedingData: feedingData)
                    .padding(.horizontal)
                    .padding(.top, -10)
                
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(feedingData.feedingEntries.sorted(by: { $0.date > $1.date })) { entry in
                            FeedingEntryView(entry: entry) {
                                feedingData.deleteEntry(entry)
                            }
                            
                            Divider()
                                .padding(.horizontal)
                        }
                    }
                }
                .frame(maxHeight: 200)  // Limit the height of the scroll view
                .padding(.top, -10)  // Add negative top padding to move it closer to calendar
                
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
                            weatherManager: weatherManager
                        )
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom)
            }
            .zIndex(0)
            
            // Show all active falling animations
            ForEach(animations, id: \.self) { id in
                FallingPelletsView()
                    .onAppear { print("Pellets view appeared for: \(id)") }
            }
            .zIndex(1)
            
            // Feeding guide overlay
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
            recommendationState = .error("Unable to get temperature data")
            return
        }
        
        recommendationState = .loading
        
        do {
            let recommendation = try await xaiService.getRecommendation(
                temperature: temperature,
                fishAge: selectedAgeGroup,
                objective: selectedObjective,
                foodType: feedingData.currentFoodType,
                location: "Atlanta, Georgia"
            )
            
            await MainActor.run {
                recommendationState = .success(recommendation)
            }
        } catch {
            print("Error getting recommendation: \(error)")
            await MainActor.run {
                recommendationState = .error("Unable to get feeding recommendation")
            }
        }
    }
    
    private func checkForNewRecommendation() {
        let calendar = Calendar.current
        let lastDate = Date(timeIntervalSince1970: lastRecommendationDate)
        if !calendar.isDate(lastDate, inSameDayAs: Date()) {
            Task {
                await getRecommendation()
                lastRecommendationDate = Date().timeIntervalSince1970
            }
        }
    }
    
    var recommendationView: some View {
        switch recommendationState {
        case .loading:
            return AnyView(
                ProgressView()
                    .padding(.vertical)
            )
        case .success(let recommendation):
            return AnyView(
                Text(recommendation)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
            )
        case .error(let message):
            return AnyView(
                VStack(spacing: 4) {
                    Text(message)
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        Task {
                            await getRecommendation()
                        }
                    }) {
                        Label("Try Again", systemImage: "arrow.clockwise")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
            )
        case .none:
            return AnyView(EmptyView())
        }
    }
}

#Preview {
    ContentView()
}
