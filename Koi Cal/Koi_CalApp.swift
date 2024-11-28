//
//  Koi_CalApp.swift
//  Koi Cal
//
//  Created by Aaron Heine on 11/14/24.
//

import SwiftUI

@main
struct Koi_CalApp: App {
    @State private var showingSplash = true
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    init() {
        // Force portrait orientation
        AppDelegate.orientationLock = .portrait
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .preferredColorScheme(.light)
                
                if showingSplash {
                    SplashScreenView(isPresented: $showingSplash)
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.all
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
}
