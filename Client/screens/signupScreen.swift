//
//  signupScreen.swift
//  FaceGram IOS
//
//  Created by Yuval Farangi on 04/01/2025.
//

import SwiftUI

struct signupScreen: View {
    
    @Binding var SignUpIsPresented: Bool
    @Binding var isLoggedIn: Bool
    @Binding var loggedInUser: User?
    
    @State var isCreatedSuccessfully: Bool = false
    
    @State private var profilePic: UIImage = UIImage(named: "profilePicture")!
    @State private var username: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var bio: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert = false
    @State private var alertTitle: String = ""
    
    var body: some View {
        VStack{
            Text("Sign Up")
                .font(.title)
                .fontWeight(.black)
                .foregroundColor(.gray)
            Text("and Start Exploring!")
                .font(.title)
                .fontWeight(.black)
                .foregroundStyle(
                    LinearGradient(gradient: Gradient(colors: [.logoColors_lightOrange, .logoColors_orange, .logoColors_pink]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                )
        }.frame(maxWidth: .infinity, maxHeight: 100, alignment: .center)
        TabView{
            
            //Tab 1
            VStack{
                TextInput(title: "First Name", field: $firstName)
                TextInput(title: "Last Name", field: $lastName)
                TextInput(title: "User Name", field: $username)
                TextInput(title: "Email", field: $email)
                TextInput(title: "Phone Number", field: $phoneNumber)
                TextInput(title: "Bio", field: $bio)
            }
            
            //Tab 2
            VStack{
                mediaPicker(selectedImage: $profilePic)
                    .padding()
            }
            
            //Tab 3
            VStack{
                TextInput(title: "Password", field: $password)
                TextInput(title: "Confirm Password", field: $confirmPassword)
                
                
                primaryButton(
                    onPress: {cofirmCreateUser()},
                    text: "Create Account",
                    symbolName: "person.fill.checkmark"
                ).padding()
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Sign Up"),
                            message: Text(alertTitle),
                            dismissButton: .default(
                                Text("Dismiss"),
                                action: {
                                    if(isCreatedSuccessfully){
                                        SignUpIsPresented.toggle()}
                                }
                            )
                        )
                    }
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(maxWidth: .infinity, maxHeight: 500, alignment: .center)
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = .black // Active dot
            UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.3) // Inactive dots
        }
    }
    func cofirmCreateUser(){
        if(password != confirmPassword){
            alertTitle = "Passwords Mismatch"
        }else{
            var user = User(
                firstName: firstName,
                lastName: lastName,
                email: email,
                phoneNumber: phoneNumber,
                username: username,
                password: password,
                bio: bio,
                decodedProfilePic: profilePic
            )
            Task{
                let res = await user.create()
                alertTitle = res.message
                isCreatedSuccessfully = res.isCreatedSuccessfully
                
                if (isCreatedSuccessfully){
                    SessionManager.shared.saveUserSession(user: user)
                    loggedInUser = user
                    isLoggedIn = true
                }
            }
        }
        showAlert.toggle()
    }
}


//#Preview {
//    @State var visible = true
//    signupScreen(SignUpIsPresented: $visible, isLoggedIn: $visible)
//}
