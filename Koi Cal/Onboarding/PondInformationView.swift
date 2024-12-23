import SwiftUI

struct PondInformationView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var pondVolume = UserDefaults.standard.string(forKey: "pondVolume") ?? ""
    @State private var sunlightHours = UserDefaults.standard.string(forKey: "sunlightHours") ?? ""
    @State private var location = UserDefaults.standard.string(forKey: "location") ?? ""
    @State private var circulationTime = UserDefaults.standard.string(forKey: "circulationTime") ?? ""
    @State private var useMetric = UserDefaults.standard.bool(forKey: "useMetric")
    
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
                    
                    Text("Tell me about your pond.")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Location")
                            .font(.headline)
                        
                        TextField("Enter location", text: $location)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Size")
                            .font(.headline)
                        
                        Text("How many \(volumeLabel.lowercased()) is your pond?")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                        
                        TextField(volumeLabel, text: $pondVolume)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Environment")
                            .font(.headline)
                        
                        Text("How many hours of direct sunlight does your pond get per day?")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                        
                        TextField("Hours", text: $sunlightHours)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        
                        Text("How many seconds does it take your water circulation to fill a \(circulationLabel)?")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                        
                        TextField("Seconds", text: $circulationTime)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
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
            .background(.white)
            
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
        .background(.white)
        .edgesIgnoringSafeArea(.bottom)
        .toolbar(.hidden, for: .navigationBar)
        .onChange(of: location) { _, newValue in
            UserDefaults.standard.set(newValue, forKey: "location")
        }
        .onChange(of: pondVolume) { _, newValue in
            UserDefaults.standard.set(newValue, forKey: "pondVolume")
        }
        .onChange(of: sunlightHours) { _, newValue in
            UserDefaults.standard.set(newValue, forKey: "sunlightHours")
        }
        .onChange(of: circulationTime) { _, newValue in
            UserDefaults.standard.set(newValue, forKey: "circulationTime")
        }
        .onChange(of: useMetric) { _, newValue in
            UserDefaults.standard.set(newValue, forKey: "useMetric")
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

