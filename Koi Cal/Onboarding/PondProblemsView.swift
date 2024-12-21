import SwiftUI

struct PondProblemsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("location") private var location = ""
    @AppStorage("pondVolume") private var pondVolume = ""
    @AppStorage("sunlightHours") private var sunlightHours = ""
    @AppStorage("circulationTime") private var circulationTime = ""
    
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
                    
                    // Title and Subtitle
                    VStack(alignment: .center, spacing: 16) {
                        Text("Tell me about your pond!")
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text("The more I know the more accurate the advice will be.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    
                    // Form Fields
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Where is your pond located?")
                                .font(.system(size: 16))
                                .foregroundColor(Color(hex: "565656"))
                            TextField("Enter location", text: $location)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocorrectionDisabled()
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("How many gallons is your pond?")
                                .font(.system(size: 16))
                                .foregroundColor(Color(hex: "565656"))
                            TextField("Enter gallons", text: $pondVolume)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
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
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("How many hours of direct sunlight does your pond get per day?")
                                .font(.system(size: 16))
                                .foregroundColor(Color(hex: "565656"))
                            TextField("Enter hours", text: $sunlightHours)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("How many seconds does it take your water circulation to fill a gallon?")
                                .font(.system(size: 16))
                                .foregroundColor(Color(hex: "565656"))
                            TextField("Enter seconds", text: $circulationTime)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .onChange(of: circulationTime) { oldValue, newValue in
                                    let filtered = newValue.filter { $0.isNumber }
                                    if filtered != newValue {
                                        circulationTime = filtered
                                    }
                                }
                        }
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
    }
}

#Preview {
    NavigationStack {
        PondProblemsView()
    }
}
