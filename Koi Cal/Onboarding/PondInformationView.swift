import SwiftUI

struct PondInformationView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var pondVolume = UserDefaults.standard.string(forKey: "pondVolume") ?? ""
    @State private var sunlightHours = UserDefaults.standard.string(forKey: "sunlightHours") ?? ""
    @State private var location = UserDefaults.standard.string(forKey: "location") ?? ""
    @State private var circulationTime = UserDefaults.standard.string(forKey: "circulationTime") ?? ""
    @State private var useMetric = UserDefaults.standard.bool(forKey: "useMetric")
    @FocusState private var focusedField: Field?
    
    enum Field {
        case volume, sunlight, location, circulation
    }
    
    private func convertVolume(_ volume: String, toMetric: Bool) -> String {
        guard !volume.isEmpty else { return volume }
        let cleanVolume = volume.replacingOccurrences(of: ",", with: "")
        guard let value = Double(cleanVolume) else { return volume }
        let converted = toMetric ? value * 3.78541 : value / 3.78541
        return Int(converted).formatted(.number)
    }
    
    private func saveToUserDefaults<T>(_ value: T, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    private var backButton: some View {
        Button(action: { dismiss() }) {
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
    }
    
    private var titleSection: some View {
        Text("Tell me about your pond.")
            .font(.title)
            .fontWeight(.bold)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Location")
                .font(.headline)
            TextField("Enter location", text: $location)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($focusedField, equals: .location)
        }
        .padding(.horizontal, 20)
    }
    
    private var sizeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Size")
                .font(.headline)
            Text("How many \(useMetric ? "liters" : "gallons") is your pond?")
                .font(.system(size: 16))
                .foregroundColor(.gray)
            TextField(useMetric ? "Liters" : "Gallons", text: $pondVolume)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .focused($focusedField, equals: .volume)
        }
        .padding(.horizontal, 20)
    }
    
    private var environmentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Environment")
                .font(.headline)
            Text("How many hours of direct sunlight does your pond get per day?")
                .font(.system(size: 16))
                .foregroundColor(.gray)
            TextField("Hours", text: $sunlightHours)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .focused($focusedField, equals: .sunlight)
            Text("How many seconds does it take your water circulation to fill a \(useMetric ? "liter" : "gallon")?")
                .font(.system(size: 16))
                .foregroundColor(.gray)
            TextField("Seconds", text: $circulationTime)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .focused($focusedField, equals: .circulation)
        }
        .padding(.horizontal, 20)
    }
    
    private var unitsSection: some View {
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
    }
    
    private var nextButton: some View {
        NavigationLink(destination: WatermelonView()) {
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
    
    private var mainContent: some View {
        VStack(alignment: .leading, spacing: 32) {
            backButton
            titleSection
            locationSection
            sizeSection
            environmentSection
            unitsSection
            Spacer().frame(height: 100)
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                mainContent
            }
            
            nextButton
        }
        .background(.white)
        .edgesIgnoringSafeArea(.bottom)
        .toolbar(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    focusedField = nil
                }
            }
        }
        .onChange(of: location) { _, newValue in
            saveToUserDefaults(newValue, forKey: "location")
        }
        .onChange(of: pondVolume) { _, newValue in
            saveToUserDefaults(newValue, forKey: "pondVolume")
        }
        .onChange(of: sunlightHours) { _, newValue in
            saveToUserDefaults(newValue, forKey: "sunlightHours")
        }
        .onChange(of: circulationTime) { _, newValue in
            saveToUserDefaults(newValue, forKey: "circulationTime")
        }
        .onChange(of: useMetric) { _, newValue in
            saveToUserDefaults(newValue, forKey: "useMetric")
            pondVolume = convertVolume(pondVolume, toMetric: newValue)
        }
    }
}

#Preview {
    NavigationStack {
        PondInformationView()
    }
} 

