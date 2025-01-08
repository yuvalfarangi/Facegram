//
//  signinScreen.swift
//  FaceGram IOS
//
//  Created by Yuval Farangi on 04/01/2025.
//

import SwiftUI

struct signinScreen: View {
    
    @Binding var SignInIsPresented: Bool
    @Binding var loggedInUser: User?
    @Binding var isLoggedIn: Bool
    
    @State var username: String = ""
    @State var password: String = ""
    @State private var user: User?
    @State var errorMsg: String = ""
    
    var body: some View {
        VStack{
            Text("Sign In to Facegram!")
                .padding()
                .font(.title)
                .fontWeight(.black)
                .foregroundStyle(
                    LinearGradient(gradient: Gradient(colors: [.logoColors_lightOrange, .logoColors_orange, .logoColors_pink]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                )
            
            TextField("User Name", text: $username)
                .font(.headline)
                .fontWeight(.bold)
                .padding(10)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 2)
                )
                .padding([.leading, .trailing], 70)
            
            TextField("Password", text: $password)
                .font(.headline)
                .fontWeight(.bold)
                .padding(10)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 2)
                )
                .padding([.leading, .trailing], 70)
                
            
            Text(errorMsg)
                .foregroundColor(Color.red)
                .fontWeight(.bold)
            
            primaryButton(
                onPress: {submitSignIn()},
                text: "Sign In",
                symbolName: "arrow.right.circle.fill"
            )
            .padding()
        }
    }
    func submitSignIn(){
    
        print("Username: \(username), Password: \(password)") //prints the value properly
        
        Task{
           user = await login(username: username, password: password)
            if(user != nil){
                errorMsg = ""
                SignInIsPresented.toggle()
                loggedInUser = user
                isLoggedIn = true
            }else{
                errorMsg = "Invalid username or password"
            }
            
            username = ""
            password = ""
        }
    }
}

//#Preview {
//    @State var visible = true
//    signinScreen(isPresented: $visible, isLoggedIn:  $visible)
//}
