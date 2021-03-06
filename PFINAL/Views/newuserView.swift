//
//  newuserView.swift
//  Tarea7
//
//  Created by Daniel Cubillo on 25/3/21.
//

import SwiftUI
import SCLAlertView
import Amplify

struct newuserView: View {
    
    @State private var username = ""
    @State private var password = ""
    @State private var email = ""
    @State var logged = false
    
    var body: some View {
        VStack{
            Image("cenfotec2")
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
            
            TextField("Correo", text: $email)
                .padding()
                .cornerRadius(4.0)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
                .autocapitalization(.none)
            
            
            Button(action: registro) {
                HStack(alignment: .center) {
                    Spacer()
                    Text("Registrar nuevo usuario").foregroundColor(Color.white)
                    Spacer()
                }
            }.padding().background(Color.purple).cornerRadius(4.0)
        }//VStack
    }//View
    
    func registro(){
        if username==""{
            SCLAlertView().showError("Error", subTitle: "Falta el nombre de usuario") // Error
        }else{
            if password == ""{
                SCLAlertView().showError("Error", subTitle: "Falta el password") // Error
            }else{
                if email==""{
                    SCLAlertView().showError("Error", subTitle: "Falta el correo") // Error
                }else{
                    signUp()
                }
            }
        }
    }//registro
    
    func signUp() {
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        
        Amplify.Auth.signUp(
            username: username,
            password: password,
            options: options
        ) { result in
            switch result {
            case .success(let signUpResult):
                
                switch signUpResult.nextStep {
                case .confirmUser(let details, let info):
                    print(details ?? "no details", info ?? "no additional info")
                    
                    DispatchQueue.main.async {
                     
                        let alert = SCLAlertView(
                        )
                        let txt = alert.addTextField("N??mero de confirmaci??n")
                        alert.addButton("Confirmaci??n") {
                            confirmSignUp(emailCode: txt.text!)
                            print("Facilitar Codigo")
                        }
                        alert.showEdit("SMS", subTitle: "Ingrese el c??digo recibido en su correo", closeButtonTitle: "Cancelar")
                    }
                    
                case .done:
                    print("Sign up complete")
                }
                
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    SCLAlertView().showError("Error", subTitle: error.errorDescription) // Error

                }

            }
        }
    }
    func confirmSignUp(emailCode: String) {
        Amplify.Auth.confirmSignUp(for: username, confirmationCode: emailCode) { result in
            
            switch result {
            
            case .success(let confirmSignUpResult):
                
                switch confirmSignUpResult.nextStep {
                case .confirmUser(let details, let info):
                    print(details ?? "no details", info ?? "no additional info")
                    
                    
                case .done:
                    print("\(username) confirmed their email")
                    username = ""
                    password = ""
                    email = ""
                    DispatchQueue.main.async {
                        SCLAlertView().showInfo("Listo", subTitle: "Email Confirmado") // Info
                    }
                
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

struct newuserView_Previews: PreviewProvider {
    static var previews: some View {
        newuserView()
    }
}
