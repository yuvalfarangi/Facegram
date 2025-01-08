//
//  entry.swift
//  FaceGram IOS
//
//  Created by Yuval Farangi on 04/01/2025.
//

import SwiftUI

struct entryScreen: View {
    
    @Binding var loggedInUser: User?
    @Binding var isLoggedIn: Bool
    
    @State private var showSigninScreen: Bool = false
    @State private var showLSignupScreen: Bool = false
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.logoColors_lightOrange, .logoColors_orange, .logoColors_pink,]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            VStack(spacing: 10){
                Text("Facegram")
                    .font(Font.custom("Pacifico", size: 40))
                    .foregroundStyle(Color.white)
                    .padding()
                
                Button(action: {showSigninScreen.toggle()}) {
                    Text("Sign In")
                        .frame(width: 150, height: 40)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.white, lineWidth: 2)
                        )
                }
                
                Button(action: {showLSignupScreen.toggle()}) {
                    Text("Sign Up")
                        .frame(width: 150, height: 40)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.PrimaryColor)
                        .background(Color.white)
                        .cornerRadius(10)
                }
            }
        }.sheet(isPresented: $showSigninScreen, content: {
            signinScreen(SignInIsPresented: $showSigninScreen, loggedInUser: $loggedInUser, isLoggedIn: $isLoggedIn)
                .presentationDetents([.large])
        })
        .sheet(isPresented: $showLSignupScreen, content: {
            signupScreen(SignUpIsPresented: $showSigninScreen, isLoggedIn: $isLoggedIn,  loggedInUser: $loggedInUser)
                .presentationDetents([.large])
        })
    }
}

#Preview {
//    entryScreen()
}
