import CoreLocation
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var cityName: String = "Loading location..."
    @Published var errorMessage: String?
    
    override init() {
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1000
    }
    
    func requestPermission() {
        print("Requesting location permission")
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        print("Authorization status changed to: \(authorizationStatus.rawValue)")
        
        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            errorMessage = nil
        case .denied:
            errorMessage = "Location access denied. Please enable in Settings."
            cityName = "Location access denied"
        case .restricted:
            errorMessage = "Location access restricted."
            cityName = "Location restricted"
        case .notDetermined:
            errorMessage = nil
            cityName = "Location not determined"
        @unknown default:
            errorMessage = "Unknown location authorization status."
            cityName = "Unknown location status"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        
        // Update city name using reverse geocoding
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                self.errorMessage = "Unable to determine location name"
                return
            }
            
            if let placemark = placemarks?.first {
                let city = placemark.locality ?? "Unknown City"
                let state = placemark.administrativeArea ?? ""
                self.cityName = "\(city), \(state)"
                self.errorMessage = nil
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
        errorMessage = "Unable to determine location"
    }
} 