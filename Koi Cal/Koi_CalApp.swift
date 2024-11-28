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
