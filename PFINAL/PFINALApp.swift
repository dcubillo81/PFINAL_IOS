//
//  PFINALApp.swift
//  PFINAL
//
//  Created by Daniel Cubillo on 1/4/21.
//

import SwiftUI
import Amplify
import AmplifyPlugins

@main
struct PFINALApp: App {
    
    init() {
            configureAmplify()
        }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    private func configureAmplify(){
        do {
            Amplify.Logging.logLevel = .verbose
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSS3StoragePlugin())
            try Amplify.configure()
            
            print("Amplify configured with auth plugin")
        } catch {
            print("An error occurred setting up Amplify: \(error)")
        }
    }
    
    
}
