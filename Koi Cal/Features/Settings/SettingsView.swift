import MessageUI

struct SettingsView: View {
    @State private var showMailError = false

    func sendFeatureRequest() {
        let email = "aaronheine@gmail.com"
        let subject = "Koi Cal Feature Request"
        
        if let url = URL(string: "mailto:\(email)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                showMailError = true
            }
        }
    }

    var body: some View {
        // Other settings views

        // Add to the bottom of the settings list
        Section {
            Button(action: sendFeatureRequest) {
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(Color(hex: "F18833"))
                    Text("Request a Feature")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                }
            }
        }
        .alert("Email Not Available", isPresented: $showMailError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your device is not configured to send emails. Please check your email settings and try again.")
        }
    }
}