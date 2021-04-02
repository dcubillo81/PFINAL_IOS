//
//  LoginView.swift
//  PFINAL
//
//  Created by Daniel Cubillo on 1/4/21.
//

import SwiftUI
import LocalAuthentication
import Amplify
import SCLAlertView

struct LoginView: View {
    @AppStorage("status") var logged = false
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        NavigationView{
            VStack{
                Image("cenfotec")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200, alignment: .center)
            
                TextField("Username", text: $username)
                    .padding()
                    .cornerRadius(4.0)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
                    .autocapitalization(.none)
            
                SecureField("Password", text: $password)
                    .padding()
                    .cornerRadius(4.0)
                    .padding(.bottom, 10)
                    .autocapitalization(.none)
            
                Button(action: signIn) {
                    HStack(alignment: .center) {
                        Spacer()
                        Text("Ingresar").foregroundColor(Color.white)
                        Spacer()
                    }
                }.padding().background(Color.purple).cornerRadius(4.0)
            
                HStack{
                    Text("Primera vez que ingresa?")
                        .foregroundColor(.gray)
                    NavigationLink(destination: newuserView()) {
                        Text("Registrarse Aquí")
                        .foregroundColor(.blue)
                    }//NavigationLink
                }//HStack
            }//VStack
            .navigationBarTitle("Bienvenido")
            
        }//navigationview
        
    }//View
    
    func signIn() {
        
        if username == "" {
            SCLAlertView().showError("Error", subTitle: "Falta el nombre de usuario") // Error
        }else{
            if password == ""{
                SCLAlertView().showError("Error", subTitle: "Falta el password") // Error
            }else{
                Amplify.Auth.signIn(username: username, password: password) { result in
                    switch result {

                    case .success:
                        print("\(username) signed in")
                        DispatchQueue.main.async {
                            logged = true
                            print("Login In")
                        }

                    case .failure(let error):
                        print(error)
                        DispatchQueue.main.async {
                            SCLAlertView().showError("Error", subTitle: error.errorDescription) // Error
                        }
                    }
                }
            }
        }
    }//signIn
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
