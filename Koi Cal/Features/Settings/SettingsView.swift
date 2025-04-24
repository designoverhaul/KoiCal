var body: some View {
    NavigationView {
        Form {
            // Add Pond and Fish Information section
            Section(header: Text("Pond & Fish Information")) {
                // Pond Location
                NavigationLink(destination: PondLocationEditView()) {
                    HStack {
                        Text("Pond Location")
                        Spacer()
                        Text(userPreferences.location.isEmpty ? "Not Set" : userPreferences.location)
                            .foregroundColor(.gray)
                    }
                }
                
                // Pond Volume
                NavigationLink(destination: PondVolumeEditView()) {
                    HStack {
                        Text("Pond Size")
                        Spacer()
                        if !userPreferences.pondVolume.isEmpty {
                            Text("\(userPreferences.pondVolume) \(userPreferences.useMetric ? "liters" : "gallons")")
                                .foregroundColor(.gray)
                        } else {
                            Text("Not Set")
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                // Fish Count
                NavigationLink(destination: FishCountEditView()) {
                    HStack {
                        Text("Fish Count")
                        Spacer()
                        Text(userPreferences.fishCount.isEmpty ? "Not Set" : userPreferences.fishCount)
                            .foregroundColor(.gray)
                    }
                }
                
                // Fish Size
                NavigationLink(destination: FishSizeEditView()) {
                    HStack {
                        Text("Average Fish Size")
                        Spacer()
                        Text(userPreferences.fishSize)
                            .foregroundColor(.gray)
                    }
                }
                
                // Food Type
                NavigationLink(destination: FoodTypeEditView()) {
                    HStack {
                        Text("Current Food Type")
                        Spacer()
                        Text(userPreferences.currentFoodType)
                            .foregroundColor(.gray)
                    }
                }
                
                // Units Preference
                Picker("Measurement Units", selection: $userPreferences.useMetric) {
                    Text("Imperial").tag(false)
                    Text("Metric").tag(true)
                }
            }
            
            // ... existing settings sections ...
            
            // Add this at the bottom of your Form
            Section {
                Link(destination: URL(string: "https://weatherkit.apple.com/legal-attribution.html")!) {
                    HStack {
                        Spacer()
                        Text("Weather")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Settings")
    }
}

// Helper edit views

struct PondLocationEditView: View {
    @EnvironmentObject private var userPreferences: UserPreferences
    @Environment(\.presentationMode) private var presentationMode
    @State private var location = ""
    
    var body: some View {
        Form {
            TextField("Pond Location", text: $location)
            
            Button("Save") {
                userPreferences.location = location
                presentationMode.wrappedValue.dismiss()
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .navigationTitle("Edit Pond Location")
        .onAppear {
            location = userPreferences.location
        }
    }
}

struct PondVolumeEditView: View {
    @EnvironmentObject private var userPreferences: UserPreferences
    @Environment(\.presentationMode) private var presentationMode
    @State private var volume = ""
    
    var body: some View {
        Form {
            TextField("Pond Volume (\(userPreferences.useMetric ? "liters" : "gallons"))", text: $volume)
                .keyboardType(.numberPad)
            
            Button("Save") {
                userPreferences.pondVolume = volume
                presentationMode.wrappedValue.dismiss()
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .navigationTitle("Edit Pond Size")
        .onAppear {
            volume = userPreferences.pondVolume
        }
    }
}

struct FishCountEditView: View {
    @EnvironmentObject private var userPreferences: UserPreferences
    @Environment(\.presentationMode) private var presentationMode
    @State private var count = ""
    
    var body: some View {
        Form {
            TextField("Number of Fish", text: $count)
                .keyboardType(.numberPad)
            
            Button("Save") {
                userPreferences.fishCount = count
                presentationMode.wrappedValue.dismiss()
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .navigationTitle("Edit Fish Count")
        .onAppear {
            count = userPreferences.fishCount
        }
    }
}

struct FishSizeEditView: View {
    @EnvironmentObject private var userPreferences: UserPreferences
    @Environment(\.presentationMode) private var presentationMode
    @State private var selectedSize = ""
    
    private let fishSizes = ["Small (< 12 inches)", "Medium (12-18 inches)", "Large (> 18 inches)"]
    
    var body: some View {
        Form {
            Picker("Fish Size", selection: $selectedSize) {
                ForEach(fishSizes, id: \.self) { size in
                    Text(size).tag(size)
                }
            }
            .pickerStyle(.inline)
            
            Button("Save") {
                userPreferences.fishSize = selectedSize
                presentationMode.wrappedValue.dismiss()
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .navigationTitle("Edit Fish Size")
        .onAppear {
            selectedSize = userPreferences.fishSize
        }
    }
}

struct FoodTypeEditView: View {
    @EnvironmentObject private var userPreferences: UserPreferences
    @Environment(\.presentationMode) private var presentationMode
    @State private var selectedFood = ""
    
    private let foodTypes = ["High Protein", "Cool Season"]
    
    var body: some View {
        Form {
            Picker("Food Type", selection: $selectedFood) {
                ForEach(foodTypes, id: \.self) { food in
                    Text(food).tag(food)
                }
            }
            .pickerStyle(.inline)
            
            Button("Save") {
                userPreferences.currentFoodType = selectedFood
                presentationMode.wrappedValue.dismiss()
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .navigationTitle("Edit Food Type")
        .onAppear {
            selectedFood = userPreferences.currentFoodType
        }
    }
} 