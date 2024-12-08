//
//  FeedingHistoryView.swift
//  Koi Cal
//
//  Created by Aaron Heine on 12/7/24.
//

import SwiftUI
import WeatherKit
import CoreLocation

struct FeedingHistoryView: View {
    @State private var selectedDate = Date()
    @StateObject private var feedingData = FeedingData()
    @State private var animations: [UUID] = []
    @StateObject private var weatherManager = WeatherManager()
    @StateObject private var locationManager = LocationManager()
    @AppStorage("useCelsius") private var useCelsius = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                // Top Bar
                HStack {
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
                    await weatherManager.getTemperature(for: locationManager.location)
                }
                .onChange(of: locationManager.location) { _, newLocation in
                    guard let newLocation else { return }
                    Task {
                        await weatherManager.getTemperature(for: newLocation)
                    }
                }
                
                // Food Image Button
                VStack(spacing: 12) {
                    GeometryReader { geometry in
                        Image("fishFood")
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
        .overlay {
            ForEach(animations, id: \.self) { id in
                FallingPelletsView()
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

#Preview {
    FeedingHistoryView()
}

