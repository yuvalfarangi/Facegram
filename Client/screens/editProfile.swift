//
//  editProfile.swift
//  FaceGram IOS
//
//  Created by Yuval Farangi on 03/01/2025.
//

import SwiftUI

struct editProfile: View {
    
    @Binding var isPresented: Bool
    
    var userID: String
    @State private var user: User?
    @State private var profilePic: UIImage = UIImage()
    @State private var username: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var bio: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var isLoading: Bool = true
    @State private var showAlert = false
    @State private var alertTitle: String = ""
    
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    if (isLoading){
                        ProgressView("Loading...").progressViewStyle(CircularProgressViewStyle())
                    }else{
                        mediaPicker(selectedImage: $profilePic)
                            .padding(.horizontal, 60)
                        
                        
                        
                        HStack{
                            TextField("First Name", text: $firstName)
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(10)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            
                            TextField("Last Name", text: $lastName)
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(10)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                        }.padding()
                        
                        
                        TextField("User Name", text: $username)
                            .font(.subheadline)
                            .padding(10)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal, 10)
                        
                        TextField("Bio", text: $bio)
                            .font(.subheadline)
                            .padding(10)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal, 10)
                        
                        TextField("Email", text: $email)
                            .font(.subheadline)
                            .padding(10)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal, 10)
                        
                        TextField("Phone Number", text: $phoneNumber)
                            .font(.subheadline)
                            .padding(10)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal, 10)
                        
                        
                        TextField("New Password", text: $newPassword)
                            .font(.subheadline)
                            .padding(10)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal, 10)
                        
                        TextField("Confirm New Password", text: $confirmPassword)
                            .font(.subheadline)
                            .padding(10)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal, 10)
                        
                        primaryButton(
                            onPress:{updateProfile()},
                            text: "Save Changes",
                            symbolName: "person.fill.checkmark"
                        ).alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Edit Profile"),
                                message: Text(alertTitle),
                                dismissButton: .default(
                                    Text("Back to Profile"),
                                    action: {isPresented.toggle()}
                                )
                            )
                        }
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .onAppear {
                Task {
                    if let fetchedUser = await getUserByID(userID: userID) {
                        user = fetchedUser
                        isLoading = false
                        
                        if let profilePicData = user?.profilePic, !profilePicData.isEmpty {
                            profilePic = decodeBase64(string: profilePicData) ?? UIImage(named: "profilePicture")!
                        } else {
                            profilePic = user?.decodedProfilePic ?? UIImage(named: "profilePicture")!
                        }

                        username = user!.username
                        firstName = user!.firstName
                        lastName = user!.lastName
                        bio = user!.bio!
                        email = user!.email
                        phoneNumber = user!.phoneNumber
                    } else {
                        isLoading = false
                    }
                }
            }
        }
    }
    func updateProfile() {
        user?.update(
            firstName: firstName,
            lastName: lastName,
            email: email,
            phoneNumber: phoneNumber,
            username: username,
            newPassword: newPassword,
            confirmPassword: confirmPassword,
            decodedProfilePic: profilePic,
            bio: bio
        ) { message in
            // This block will be executed when the async function completes.
            print("Received message: \(message)")
            alertTitle = message // Set the message to be displayed in the alert
            showAlert.toggle()   // Trigger the alert
        }
    }
}

//#Preview {
//    if let sessionUser = SessionManager.shared.retrieveUserSession() {
//        editProfile(userID: sessionUser._id ?? "")
//    }
//}
