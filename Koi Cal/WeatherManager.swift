import Foundation
import WeatherKit
import CoreLocation

@MainActor
class WeatherManager: ObservableObject {
    @Published var currentTemperature: Double?
    @Published var errorMessage: String?
    private let weatherService = WeatherService()
    
    func getTemperature(for location: CLLocation?) async {
        guard let location = location else {
            print("No location available")
            errorMessage = "Location not available"
            return
        }
        
        do {
            let weather = try await weatherService.weather(for: location)
            let temperature = weather.currentWeather.temperature
            currentTemperature = temperature.converted(to: .fahrenheit).value
            errorMessage = nil
            print("Successfully fetched temperature: \(String(describing: currentTemperature))°F")
        } catch {
            print("Error fetching weather: \(error)")
            currentTemperature = nil
            errorMessage = error.localizedDescription
        }
    }
} 