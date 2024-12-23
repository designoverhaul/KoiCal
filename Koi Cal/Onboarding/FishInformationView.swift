import SwiftUI

struct FishInformationView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("currentFoodType") private var currentFoodType = "High Protein"
    @AppStorage("fishSize") private var fishSize = "Medium"
    @AppStorage("selectedAgeGroup") private var selectedAgeGroup = "Mixed"
    @AppStorage("fishCount") private var fishCount = ""
    @FocusState private var isFishCountFieldFocused: Bool
    
    private let foodTypes = ["High Protein", "Cool Season"]
    private let fishSizes = ["Small", "Medium", "Large"]
    private let ageGroups = ["Juvenile", "Adult", "Mixed"]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
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
                VStack(alignment: .center, spacing: 16) {
                    Text("Let's learn about your fish.")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("The more I know the more accurate the advice will be.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Form
                Form {
                    Section("Food") {
                        Picker("Current Food Type", selection: $currentFoodType) {
                            ForEach(foodTypes, id: \.self) { food in
                                Text(food).tag(food)
                            }
                        }
                    }
                    
                    Section("Fish Information") {
                        Picker("Average fish size", selection: $fishSize) {
                            ForEach(fishSizes, id: \.self) { size in
                                Text(size).tag(size)
                            }
                        }
                        
                        Picker("Age of Fish", selection: $selectedAgeGroup) {
                            ForEach(ageGroups, id: \.self) { age in
                                Text(age).tag(age)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("How many fish are in your pond?")
                                .font(.system(size: 16))
                                .foregroundColor(Color(hex: "565656"))
                            
                            TextField("Number of fish", text: $fishCount)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .focused($isFishCountFieldFocused)
                                .onChange(of: fishCount) { oldValue, newValue in
                                    let filtered = newValue.filter { $0.isNumber }
                                    if filtered != newValue {
                                        fishCount = filtered
                                    }
                                    if let number = Int(filtered) {
                                        fishCount = number.formatted(.number)
                                    }
                                }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
            
            NavigationLink {
                MainTabView()
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
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isFishCountFieldFocused = false
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        FishInformationView()
    }
} 