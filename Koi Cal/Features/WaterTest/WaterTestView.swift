import SwiftUI
import MapKit

class LocationSearchCompleter: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var suggestions: [MKLocalSearchCompletion] = []
    private let completer: MKLocalSearchCompleter
    
    override init() {
        completer = MKLocalSearchCompleter()
        super.init()
        completer.delegate = self
        completer.resultTypes = .address
    }
    
    func search(query: String) {
        completer.queryFragment = query
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        suggestions = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Location search failed: \(error.localizedDescription)")
        suggestions = []
    }
}

struct WaterTestView: View {
    @AppStorage("useCelsius") private var useCelsius = false
    @AppStorage("useMetric") private var useMetric = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Order Test Strips Button
                Button(action: {
                    if let url = URL(string: "https://a.co/d/1bkuSDW") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("Order test strips")
                        .font(.system(size: 16))
                        .foregroundColor(.blue)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                }
                .buttonStyle(.borderless)
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 8)
                
                VStack(alignment: .leading, spacing: 24) {
                    // Water Quality Measurements
                    WaterQualityView()
                    
                    // Bottom padding
                    Spacer()
                        .frame(height: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
            }
        }
        .navigationTitle("Water Test")
        .navigationBarTitleDisplayMode(.large)
    }
}


#Preview {
    NavigationView {
        WaterTestView()
    }
}
