import SwiftUI

struct FishInformationView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentFoodType = UserDefaults.standard.string(forKey: "currentFoodType") ?? "High Protein"
    @State private var fishSize = UserDefaults.standard.string(forKey: "fishSize") ?? FishSize.medium.rawValue
    @State private var selectedAgeGroup = UserDefaults.standard.string(forKey: "selectedAgeGroup") ?? "Mixed"
    @State private var fishCount = UserDefaults.standard.string(forKey: "fishCount") ?? ""
    
    private let foodTypes = ["High Protein", "Cool Season"]
    private let ageGroups = ["Juvenile", "Adult", "Mixed"]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
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
                    
                    Text("Let's learn about your fish.")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 24) {
                        HStack {
                            Text("Current Food Type")
                                .font(.body)
                            
                            Spacer()
                            
                            Menu {
                                Picker("Current Food Type", selection: $currentFoodType) {
                                    ForEach(foodTypes, id: \.self) { food in
                                        Text(food).tag(food)
                                    }
                                }
                            } label: {
                                Text(currentFoodType)
                                    .foregroundColor(.orange)
                                    + Text(" ⌵")
                                    .foregroundColor(.orange)
                            }
                        }
                        
                        HStack {
                            Text("Average fish size")
                                .font(.body)
                            
                            Spacer()
                            
                            Menu {
                                Picker("Average fish size", selection: $fishSize) {
                                    ForEach(FishSize.allCases, id: \.rawValue) { size in
                                        Text(size.rawValue).tag(size.rawValue)
                                    }
                                }
                            } label: {
                                Text(fishSize)
                                    .foregroundColor(.orange)
                                    + Text(" ⌵")
                                    .foregroundColor(.orange)
                            }
                        }
                        
                        HStack {
                            Text("Age of Fish")
                                .font(.body)
                            
                            Spacer()
                            
                            Menu {
                                Picker("Age of Fish", selection: $selectedAgeGroup) {
                                    ForEach(ageGroups, id: \.self) { age in
                                        Text(age).tag(age)
                                    }
                                }
                            } label: {
                                Text(selectedAgeGroup)
                                    .foregroundColor(.orange)
                                    + Text(" ⌵")
                                    .foregroundColor(.orange)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("How many fish are in your pond?")
                                .font(.body)
                            
                            TextField("Number of fish", text: $fishCount)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
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
                    .padding(.horizontal, 20)
                    
                    Spacer()
                        .frame(height: 100)
                }
            }
            .background(.white)
            
            NavigationLink {
                MainTabView()
                    .navigationBarBackButtonHidden()
            } label: {
                Text("FINISH")
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
        .onChange(of: currentFoodType) { _, newValue in
            UserDefaults.standard.set(newValue, forKey: "currentFoodType")
        }
        .onChange(of: fishSize) { _, newValue in
            UserDefaults.standard.set(newValue, forKey: "fishSize")
        }
        .onChange(of: selectedAgeGroup) { _, newValue in
            UserDefaults.standard.set(newValue, forKey: "selectedAgeGroup")
        }
        .onChange(of: fishCount) { _, newValue in
            UserDefaults.standard.set(newValue, forKey: "fishCount")
        }
    }
}

#Preview {
    NavigationStack {
        FishInformationView()
    }
} 