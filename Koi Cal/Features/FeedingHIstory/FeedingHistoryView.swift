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
    @AppStorage("useMetric") private var useMetric = false
    @AppStorage("hasSeenFeedTooltip") private var hasSeenFeedTooltip = false
    
    private var sortedEntries: [FeedingEntry] {
        feedingData.getEntries(for: selectedDate)
            .sorted(by: { $0.date > $1.date })
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Logo and Temperature in same HStack
                HStack {
                    Image("logoSVG")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                    
                    Spacer()
                    
                    // Temperature section
                    VStack(alignment: .trailing) {
                        Text("Water Temp")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        if let temp = weatherManager.currentTemperature {
                            Text(formatTemperature(temp - 4))
                                .font(.title)
                        } else {
                            Text(useMetric ? "--°C" : "--°F")
                                .font(.title)
                        }
                    }
                    .task {
                        await weatherManager.updateTemperature()
                    }
                }
                .padding(.horizontal)
                
                // Food Image Button
                feedingButton
                
                // Calendar
                CustomCalendarView(selectedDate: $selectedDate, feedingData: feedingData)
                    .padding(.horizontal)
                    .padding(.bottom, -17)
                
                // Feeding entries list
                feedingEntriesList
            }
            .padding(.top, 16)
            .onAppear { hasSeenFeedTooltip = false }
        }
        .overlay {
            ForEach(animations, id: \.self) { id in
                FallingPelletsView()
            }
        }
    }

    private var feedingButton: some View {
        ZStack(alignment: .top) {
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
                    hasSeenFeedTooltip = true
                    let animationId = UUID()
                    animations.append(animationId)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        animations.removeAll { $0 == animationId }
                    }
                }
            }
            
            if !hasSeenFeedTooltip {
                Text("Tap to Feed")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.orange)
                    .cornerRadius(16)
                    .offset(y: -25)
                    .transition(.opacity)
            }
        }
        .padding(.horizontal, 4)
        .padding(.top, -2)
    }
    
    private var feedingEntriesList: some View {
        LazyVStack(spacing: 0) {
            ForEach(sortedEntries) { entry in
                FeedingEntryView(entry: entry) {
                    feedingData.deleteEntry(entry)
                }
                .padding(.vertical, 0)
                
                if entry != sortedEntries.last {
                    Divider()
                        .padding(.horizontal)
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func formatTemperature(_ fahrenheit: Double) -> String {
        if useMetric {
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

