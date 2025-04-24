import Foundation
import SwiftUI
import os

// Initialize a logger for debugging
private let logger = Logger(subsystem: "com.koical.app", category: "UserPreferences")

// A model class to store all user preferences centrally
public class UserPreferences: ObservableObject {
    // MARK: - Pond Information
    @AppStorage("location") public var location: String = ""
    @AppStorage("pondVolume") public var pondVolume: String = ""
    @AppStorage("sunlightHours") public var sunlightHours: String = ""
    @AppStorage("circulationTime") public var circulationTime: String = ""
    @AppStorage("useMetric") public var useMetric: Bool = false
    
    // MARK: - Fish Information
    @AppStorage("currentFoodType") public var currentFoodType: String = ""
    @AppStorage("fishSize") public var fishSize: String = ""
    @AppStorage("selectedAgeGroup") public var selectedAgeGroup: String = ""
    @AppStorage("fishCount") public var fishCount: Int = 0
    
    // MARK: - Fish Problems
    @AppStorage("improveColor") public var improveColor: Bool = false
    @AppStorage("growthAndBreeding") public var growthAndBreeding: Bool = false
    @AppStorage("improvedBehavior") public var improvedBehavior: Bool = false
    
    @AppStorage("sicknessOrDeath") public var sicknessOrDeath: Bool = false
    @AppStorage("lowEnergy") public var lowEnergy: Bool = false
    @AppStorage("stuntedGrowth") public var stuntedGrowth: Bool = false
    @AppStorage("lackOfAppetite") public var lackOfAppetite: Bool = false
    @AppStorage("obesity") public var obesity: Bool = false
    @AppStorage("constantHiding") public var constantHiding: Bool = false
    
    @AppStorage("waterClarity") public var waterClarity: Int = 0
    
    // MARK: - Onboarding State
    @AppStorage("hasCompletedOnboarding") public var hasCompletedOnboarding: Bool = false
    
    public init() {
        logger.debug("UserPreferences initialized")
    }
    
    // Helper method to reset all preferences
    public func resetAll() {
        logger.debug("Resetting all user preferences")
        location = ""
        pondVolume = ""
        sunlightHours = ""
        circulationTime = ""
        useMetric = false
        currentFoodType = ""
        fishSize = ""
        selectedAgeGroup = ""
        fishCount = 0
        improveColor = false
        growthAndBreeding = false
        improvedBehavior = false
        sicknessOrDeath = false
        lowEnergy = false
        stuntedGrowth = false
        lackOfAppetite = false
        obesity = false
        constantHiding = false
        waterClarity = 0
        hasCompletedOnboarding = false
    }
} 