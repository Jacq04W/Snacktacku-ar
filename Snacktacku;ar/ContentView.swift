//
//  LoginView.swift
//  Snacktacku;ar
//
//  Created by Jacquese Whitson  on 4/24/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseCore
struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var buttonsDisabled = false
    @State private var path = NavigationPath()
    @FocusState private var focusFiel : Field?

    

    enum Field{
        case email,password
    }
    @FocusState private var focusField: Field?
    var body: some View {
        NavigationStack(path:$path){
            Image("logo")
                .resizable()
                .scaledToFit()
                .padding()
            Group{
                TextField("Email", text: $email)
                    .keyboardType (.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
                    .focused($focusField, equals: .email)
                    .onSubmit{
                      focusField = .password
                    }
                    .onChange(of: email){ _ in
                        enablebuttons()
                    }
                
                
                
                SecureField("password", text: $password)
                    .textInputAutocapitalization(.never)
                    .submitLabel(.done)
                    .focused($focusField, equals: .password)
                    .onSubmit{
                        focusField = nil
                        
                    }
                    .onChange(of: password){ _ in
                        enablebuttons()
                    }
                
            }
            .textFieldStyle(.roundedBorder)
            .overlay{
                RoundedRectangle(cornerRadius: 5)
                .stroke(.gray.opacity(0.5),lineWidth:2)
            }
            .padding(.horizontal)
            HStack{
                Button{
                    register()
                } label : {
                    Text("Sign Up")
                }
                .padding(.trailing)
                Button{
                    login()
                    
                } label : {
                    Text("Log in")
                }
                .padding(.leading)
            }//Hstsack
            .disabled(buttonsDisabled)
            .buttonStyle(.borderedProminent)
            .tint(Color("snackColor"))
            .font(.title2)
            .padding(.top)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: String.self){ view in
                if view == "ListView"{
                    ListView()
                }
            }
        }// nav stack
        .alert(alertMessage, isPresented: $showingAlert){
            Button("OK",role:.cancel){
                 
            }
        }// alert
        
        .onAppear{
            // if logged in when the app runs, navigate to the new screen
            if Auth.auth().currentUser != nil {
                print ("🪵 Login successful !")
                path.append("ListView")
                
            }
        }
        
    }
    
    
    
    // fucntion
    
    
    func enablebuttons(){
        let emailIsGood = email.count >= 6 && email.contains("@")
        let passwordIsGood = password.count >= 6
        buttonsDisabled = !(emailIsGood && passwordIsGood)
    }
    func register(){
        Auth.auth().createUser(withEmail:email,password:password){
            result,error in
            if let error = error {
                print("🤬 Error: SIGN-UP Error:\(error.localizedDescription)")
                alertMessage = "SIGN-UP Error:\(error.localizedDescription)"
                showingAlert = true
            }
            else{
                print ("😎 Registration success!")
                /// load list view
            }
        }
    }
    
    func login(){
        Auth.auth().signIn(withEmail:email,password:password){
            result,error in
            if let error = error {
                print("🤬 Error: Login Error:\(error.localizedDescription)")
                alertMessage = "Login Error:\(error.localizedDescription)"
                showingAlert = true
            }
            else{
                print ("🪵 Login successful !")
                path.append("ListView")
                /// load list view
            }
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
