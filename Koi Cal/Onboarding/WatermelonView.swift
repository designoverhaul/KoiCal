import SwiftUI

struct WatermelonView: View {
    @Environment(\.dismiss) private var dismiss
    
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
                    
                    Text("Make your fish less fearful and more interactive")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text("New foods and hand feeding can bring out their personality. ")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Image("watermelon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
                        .cornerRadius(10)
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
    }
}

#Preview {
    NavigationStack {
        WatermelonView()
    }
} 