//
//  ListView.swift
//  PFINAL
//
//  Created by Daniel Cubillo on 1/4/21.
//

import SwiftUI
import LocalAuthentication
import Amplify
import AmplifyPlugins
import SCLAlertView

struct ListView: View {
    
    @AppStorage("status") var logged = false
    
    var body: some View {
        Button(action: logOut) {
            HStack(alignment: .center) {
                Spacer()
                Text("Log Out").foregroundColor(Color.white)
                Spacer()
            }
        }
        .padding()
        .background(Color.red)
        .cornerRadius(4.0)
        .onAppear { self.uploadData() }
    }
    
    func logOut(){
        Amplify.Auth.signOut() { result in
            switch result {
            case .success:
                print("Successfully signed out")
                logged = false
            case .failure(let error):
                print("Sign out failed with error \(error)")
                logged = true
                DispatchQueue.main.async {
                    SCLAlertView().showError("Error", subTitle: error.errorDescription) // Error
                }
            }
        }
    }//logout
    
    func uploadData() {
        let dataString = "Example file contents"
        let data = dataString.data(using: .utf8)!
        Amplify.Storage.uploadData(key: "ExampleKey", data: data,
            progressListener: { progress in
                print("Progress: \(progress)")
            }, resultListener: { (event) in
                switch event {
                case .success(let data):
                    print("Completed: \(data)")
                case .failure(let storageError):
                    print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
            }
        })
    }
    
    
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
