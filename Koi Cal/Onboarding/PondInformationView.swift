import SwiftUI

struct PondInformationView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var searchCompleter = LocationSearchCompleter()
    @AppStorage("pondVolume") private var pondVolume = ""
    @AppStorage("sunlightHours") private var sunlightHours = ""
    @AppStorage("location") private var savedLocation = ""
    @AppStorage("circulationTime") private var circulationTime = ""
    @State private var searchText = ""
    @FocusState private var isVolumeFieldFocused: Bool
    @FocusState private var isSunlightFieldFocused: Bool
    @FocusState private var isLocationFieldFocused: Bool
    @FocusState private var isCirculationFieldFocused: Bool
    @AppStorage("useMetric") private var useMetric = false
    
    private var volumeLabel: String {
        useMetric ? "Liters" : "Gallons"
    }
    
    private var circulationLabel: String {
        useMetric ? "liter" : "gallon"
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    // Back Button
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.title2)
                            .padding(12)
                            .background(Color.gray.opacity(0.8))
                            .clipShape(Circle())
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Title and Subtitle
                    Text("Tell me about your pond.")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Location")
                            .font(.headline)
                        
                        TextField("Enter location", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocorrectionDisabled()
                            .focused($isLocationFieldFocused)
                            .onChange(of: searchText) { oldValue, newValue in
                                if newValue.count > 2 {
                                    searchCompleter.search(query: newValue)
                                }
                                savedLocation = newValue
                            }
                        
                        if !searchCompleter.suggestions.isEmpty && searchText.count > 2 && isLocationFieldFocused {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(searchCompleter.suggestions, id: \.self) { suggestion in
                                    Button(action: {
                                        savedLocation = suggestion.title
                                        searchText = suggestion.title
                                        isLocationFieldFocused = false
                                    }) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(suggestion.title)
                                                .foregroundColor(.primary)
                                            Text(suggestion.subtitle)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .contentShape(Rectangle())
                                    }
                                    .buttonStyle(.plain)
                                    .padding(.vertical, 8)
                                    
                                    if suggestion != searchCompleter.suggestions.last {
                                        Divider()
                                    }
                                }
                            }
                            .padding(8)
                            .background(Color(.systemBackground))
                            .cornerRadius(8)
                            .shadow(radius: 2)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Size")
                            .font(.headline)
                        
                        Text("How many \(volumeLabel.lowercased()) is your pond?")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "565656"))
                        
                        TextField(volumeLabel, text: $pondVolume)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .focused($isVolumeFieldFocused)
                            .onChange(of: pondVolume) { oldValue, newValue in
                                let filtered = newValue.filter { $0.isNumber }
                                if filtered != newValue {
                                    pondVolume = filtered
                                }
                                if let number = Int(filtered) {
                                    pondVolume = number.formatted(.number)
                                }
                            }
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Environment")
                            .font(.headline)
                        
                        Text("How many hours of direct sunlight does your pond get per day?")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "565656"))
                        
                        TextField("Hours", text: $sunlightHours)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .focused($isSunlightFieldFocused)
                        
                        Text("How many seconds does it take your water circulation to fill a \(circulationLabel)?")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "565656"))
                        
                        TextField("Seconds", text: $circulationTime)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .focused($isCirculationFieldFocused)
                            .onChange(of: circulationTime) { oldValue, newValue in
                                let filtered = newValue.filter { $0.isNumber }
                                if filtered != newValue {
                                    circulationTime = filtered
                                }
                            }
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Units")
                            .font(.headline)
                        
                        Picker("Measurement System", selection: $useMetric) {
                            Text("Imperial").tag(false)
                            Text("Metric").tag(true)
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                        .frame(height: 100)
                }
            }
            
            NavigationLink {
                FishInformationView()
            } label: {
                Text("Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 34)
            }
            .background(Color.white.edgesIgnoringSafeArea(.bottom))
        }
        .edgesIgnoringSafeArea(.bottom)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            searchText = savedLocation
        }
        .onChange(of: useMetric) { oldValue, newValue in
            if !pondVolume.isEmpty {
                let cleanVolume = pondVolume.replacingOccurrences(of: ",", with: "")
                if let volume = Double(cleanVolume) {
                    let converted: Double
                    if newValue {
                        converted = volume * 3.78541
                    } else {
                        converted = volume / 3.78541
                    }
                    pondVolume = Int(converted).formatted(.number)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PondInformationView()
    }
} 

