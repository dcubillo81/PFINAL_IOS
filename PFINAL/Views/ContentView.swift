//
//  ContentView.swift
//  PFINAL
//
//  Created by Daniel Cubillo on 25/3/21.
//

import SwiftUI
import LocalAuthentication
import Amplify
import SCLAlertView

struct ContentView: View {
    
    @AppStorage("status") var logged = false
    
    var body: some View {
        NavigationView{
            if logged == false{
                LoginView()
                .navigationBarHidden(true)
        }else{
            ListView()
            .navigationBarHidden(true)
            
        }
        }//NavigationView
        .onAppear { self.fetchCurrentAuthSession() }
        .navigationBarTitle("Inicio")
    }//View
    
    //VERIFICA QUE ESTA INICIADA LA SESION EN AMPLIFY
    func fetchCurrentAuthSession() {
        Amplify.Auth.fetchAuthSession { result in
            switch result {
            case .success(let session):
                print("Is user signed in - \(session.isSignedIn)")

                if session.isSignedIn {
                    logged = true
                }

            case .failure(let error):
                print("Fetch session failed with error \(error)")
            }
        }
    }//fetchCurrentAuthSession
    
}//ContentView

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
