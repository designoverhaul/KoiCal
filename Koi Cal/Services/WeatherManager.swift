import Foundation
import WeatherKit
import CoreLocation
import SwiftUI

@MainActor
class WeatherManager: ObservableObject {
    @Published var currentTemperature: Double?
    @Published var errorMessage: String?
    @AppStorage("location") private var pondLocation = ""
    private let weatherService = WeatherService()
    private let geocoder = CLGeocoder()
    
    func updateTemperature() async {
        guard !pondLocation.isEmpty else {
            print("No pond location set")
            errorMessage = "Please set your pond location"
            return
        }
        
        do {
            // Convert address to coordinates
            let placemarks = try await geocoder.geocodeAddressString(pondLocation)
            guard let location = placemarks.first?.location else {
                print("Could not find coordinates for location: \(pondLocation)")
                errorMessage = "Could not find location"
                return
            }
            
            // Get weather for coordinates
            let weather = try await weatherService.weather(for: location)
            let temperature = weather.currentWeather.temperature
            currentTemperature = temperature.converted(to: .fahrenheit).value
            errorMessage = nil
            print("Successfully fetched temperature for \(pondLocation): \(String(describing: currentTemperature))°F")
        } catch {
            print("Error fetching weather: \(error)")
            currentTemperature = nil
            errorMessage = error.localizedDescription
        }
    }
} 