//
//  IconGeneratorApp.swift
//  IconGenerator
//
//  Created by Henry David Lie on 04/04/22.
//

import SwiftUI

@main
struct IconGeneratorApp: App {
    var body: some Scene {
        WindowGroup {
            #if targetEnvironment(macCatalyst)
            MainView()
                .onAppear {
                    guard let scenes = UIApplication.shared.connectedScenes as? Set<UIWindowScene> else { return }
                    for window in scenes {
                        window.title = "App Icon Generator"
                        guard let sizeRestrictions = window.sizeRestrictions else { continue }
                        sizeRestrictions.minimumSize = CGSize(width: 400, height: 800)
                        sizeRestrictions.maximumSize = sizeRestrictions.minimumSize
                    }
                }
            #else
            NavigationView {
                MainView()
                    .navigationTitle("Icon Generator")
            }
            .navigationViewStyle(StackNavigationViewStyle())
            #endif
        }
    }
}
