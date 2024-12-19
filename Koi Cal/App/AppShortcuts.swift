import SwiftUI

enum AppShortcut: String {
    case contactUs = "ContactUs"
}

class AppShortcutHandler {
    static let shared = AppShortcutHandler()
    
    func configureShortcuts() {
        let contactIcon = UIApplicationShortcutIcon(systemImageName: "envelope")
        let contactItem = UIApplicationShortcutItem(
            type: AppShortcut.contactUs.rawValue,
            localizedTitle: "Deleting? Tell us why.",
            localizedSubtitle: "Send feedback before you delete.",
            icon: contactIcon,
            userInfo: nil
        )
        
        UIApplication.shared.shortcutItems = [contactItem]
    }
    
    func handleShortcut(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        guard let shortcutType = AppShortcut(rawValue: shortcutItem.type) else { return false }
        
        switch shortcutType {
        case .contactUs:
            if let url = createEmailUrl() {
                UIApplication.shared.open(url)
            }
        }
        
        return true
    }
    
    private func createEmailUrl() -> URL? {
        let emailTo = "aaronheine@gmail.com"
        let subject = "Koi Cal Feedback"
        let urlString = "mailto:\(emailTo)?subject=\(subject)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: urlString)
    }
} 