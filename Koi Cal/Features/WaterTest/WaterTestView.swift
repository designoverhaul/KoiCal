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
    @EnvironmentObject private var waterQualityManager: WaterQualityManager
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Warning message
                Text("Recording your water levels isn't mandatory, but it is useful for diagnosing issues and suggesting treatments for your fish and pond.")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 34)
                    .padding(.top, 8)
                    .padding(.bottom, -8)
                    .padding(.leading, 16)
                
                // Order Test Strips Button
                HStack(alignment: .center, spacing: 8) {
                    Button(action: {
                        if let url = URL(string: "https://a.co/d/1bkuSDW") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack(spacing: 4) {
                            Text("Order test strips")
                                .font(.system(size: 16))
                                .foregroundColor(.blue)
                            
                            Image(systemName: "chevron.forward.circle")
                                .foregroundColor(.blue)
                                .font(.system(size: 16))
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 18)
                        .padding(.leading, 12)
                    }
                    .buttonStyle(.borderless)
                    
                    Image("TestStrip")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 42)
                }
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
                .padding(.top, -4)
            }
        }
        .navigationTitle("💧Water Test")
        .navigationBarTitleDisplayMode(.large)
    }
}


#Preview {
    NavigationView {
        WaterTestView()
            .environmentObject(WaterQualityManager())
    }
}
