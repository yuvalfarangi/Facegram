//
//  user.swift
//  FaceGram IOS
//
//  Created by Yuval Farangi on 13/12/2024.
//

import Foundation
import UIKit

struct User: Codable, Hashable {
    let _id: String?
    var firstName: String
    var lastName: String
    var email: String
    var phoneNumber: String
    var username: String
    var password: String
    let posts: [String]? //posts ids
    var followers: [String]? //user's ids
    var following: [String]? //user's ids
    var profilePic: String?
    var bio: String?
    var tags: [String]?
    var createdAt: String?
    var updatedAt: String?
    var decodedProfilePic: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case _id
        case firstName
        case lastName
        case email
        case phoneNumber
        case username
        case password
        case posts
        case followers
        case following
        case profilePic
        case bio
        case tags
        case createdAt
        case updatedAt
    }
    
    
    init(id: String? = "", firstName: String, lastName: String, email: String, phoneNumber: String, username: String, password: String, posts: [String]? = nil, followers: [String]? = nil, following: [String]? = nil, profilePic: String? = nil, bio: String? = "", createdAt: String? = "", updatedAt: String? = "", tags: [String]? = nil, decodedProfilePic:UIImage){
        
        self._id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
        self.username = username
        self.password = password
        self.posts = posts
        self.followers = followers
        self.following = following
        self.bio = bio
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.tags = tags
        self.decodedProfilePic = decodedProfilePic
    }
    
    
    mutating func create() async -> (message: String, isCreatedSuccessfully: Bool) {
        guard firstName != "" || lastName != "" || email != "" || phoneNumber != "" || username != "" || password != "" else {
            print("one or more fields are empty")
            return ("one or more fields are empty", false)
        }

        encodeProfilePic()

        // Send data to the server
        let response = await ServerAPI.shared.postData(
            endpoint: "/user",
            requestData: self,
            responseType: serverResponse.self
        )

        let isCreatedSuccessfully = response?.status == 200
        print(response?.message ?? "")
        
        return (response?.message ?? "Error", isCreatedSuccessfully)
    }
    
    func processDatabaseRespons()->User{
        let user = User(
            id: self._id ?? "",
            firstName: self.firstName,
            lastName: self.lastName,
            email: self.email,
            phoneNumber: self.phoneNumber,
            username: self.username,
            password: self.password,
            posts: self.posts ?? [],
            followers: self.followers ?? [],
            following: self.following ?? [],
            profilePic: self.profilePic ?? "",
            bio: self.bio ?? "",
            createdAt: self.createdAt ?? "",
            updatedAt: self.updatedAt ?? "",
            tags: self.tags ?? [],
            decodedProfilePic: decodeBase64(string: self.profilePic ?? "") ?? UIImage()
        )
        return user
    }
    
    mutating func encodeProfilePic() {
        self.profilePic = encodeBase64(image: self.decodedProfilePic ?? UIImage())
    }
    
    mutating func decodeProfilePic() {
        self.decodedProfilePic = decodeBase64(string: self.profilePic ?? "")
    }
    
    mutating func toggleFollow(user: inout User) {
        guard let userId = user._id else {
            print("Error: User ID is nil")
            return
        }
        
        var actionType: String = ""
        
        // Ensure `following` is not nil
        if self.following == nil { self.following = [] }
        
        if let index = self.following?.firstIndex(of: userId) {
            self.following?.remove(at: index) // Unfollow the user
            print("Unfollowed \(userId)")
            
            actionType = "unfollow"
            
            if let followerIndex = user.followers?.firstIndex(of: self._id ?? "") {
                user.followers?.remove(at: followerIndex)
            }
        } else {
            self.following?.append(userId) // Follow the user
            print("Followed \(userId)")
            
            actionType = "follow"
            
            if user.followers == nil { user.followers = [] }
            user.followers?.append(self._id ?? "")
        }
        
        self.uploadChangesToDataBase(actionType: actionType){ message in
            print("Response message: \(message)")
        }
        user.uploadChangesToDataBase(actionType: actionType){ message in
            print("Response message: \(message)")
        }
    }
    
    func isFollowing(user: User) -> Bool {
        guard let userId = user._id else {
            print("Error: User ID is nil")
            return false
        }
        
        return self.following?.contains(userId) ?? false
    }
    
    func uploadChangesToDataBase(actionType: String, completion: @escaping (String) -> Void) {
        var response: serverResponse?
        Task {
            response = await ServerAPI.shared.patchData(
                endpoint: "/user/\(String(describing: self._id!))/\(actionType)",
                requestData: self,
                responseType: serverResponse.self
            )
            SessionManager.shared.clearUserSession()
            SessionManager.shared.saveUserSession(user: self)
            
            // Call the completion closure with the response message
            completion(response?.message ?? "")
        }
    }
    
    mutating func update(
        firstName: String?,
        lastName: String?,
        email: String?,
        phoneNumber: String?,
        username: String?,
        newPassword: String? = "",
        confirmPassword: String?,
        decodedProfilePic: UIImage? = nil,
        bio: String? = "",
        completion: @escaping (String) -> Void // Adding completion closure here
    ) {
        self.firstName = firstName!
        self.lastName = lastName!
        self.email = email!
        self.phoneNumber = phoneNumber!
        self.username = username!
        self.bio = bio!
        self.decodedProfilePic = decodedProfilePic
        
        if let decodedProfilePic = decodedProfilePic {
            self.profilePic = encodeBase64(image: decodedProfilePic)
        }
        
        if newPassword == confirmPassword && !newPassword!.isEmpty {
            self.password = newPassword!
        }
        
        
        self.uploadChangesToDataBase(actionType: "all") { message in
            
            print("Received message: \(message)")
            completion(message)
        }
    }
    
    func isTagExist(tag: String) -> Bool {
        guard let tags = self.tags else {
            print("Error: Tags are nil")
            return false
        }
        
        return tags.contains(tag)
    }
    
    mutating func toggleTag(tag: String) {
        var actionType: String = ""
        if (self.isTagExist(tag: tag)){
            self.tags?.removeAll(where: { $0 == tag })
            actionType = "tagRemoved"
        }
        else {
            self.tags?.append(tag)
            actionType = "tagAdded"
        }
        self.uploadChangesToDataBase(actionType: actionType){ message in
            print("Response message: \(message)")
        };
    }
    
    func getFollowers() -> [User] {
        var fetchedFollowers: [User] = []
        
        for userID in self.followers!{
            Task{
                if let user: User = await getUserByID(userID: userID){
                    fetchedFollowers.append(user)
                }
            }
        }
        return fetchedFollowers
    }
    
    func getFollowing() async -> [User] {
        var fetchedFollowing: [User] = []
        
        guard let following = self.following else {
            return []
        }
        
        for userID in following {
            if let user: User = await getUserByID(userID: userID) {
                fetchedFollowing.append(user)
            }
        }
        
        return fetchedFollowing
    }
    
    func getRecentPosts(days: Int) async -> [Post] {
        var fetchedPosts: [Post] = []
        
        guard let postIDs = self.posts else {
            print("No post IDs found.")
            return []
        }
        
        for postID in postIDs {
            if let post = await getPostByID(postID: postID) {
                fetchedPosts.append(post)
            } else {
                print("Post with ID \(postID) could not be fetched.")
            }
        }
        
        // Create and configure ISO8601DateFormatter
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        // Filter posts by date
        let filteredPosts = fetchedPosts.filter { post in
            guard let createdAtString = post.createdAt else {
                print("Post \(post._id ?? "unknown ID") has no creation date.")
                return false
            }
            
            // Parse date from string
            guard let createdAtDate = isoFormatter.date(from: createdAtString) else {
                print("Failed to parse date: \(createdAtString) for post \(post._id ?? "unknown ID").")
                return false
            }
            
            // Calculate the cutoff date
            let daysAgo = Calendar.current.date(byAdding: .day, value: -days, to: Date())!
            return createdAtDate >= daysAgo
        }
        
        if filteredPosts.isEmpty {
            print("No posts found within the last \(days) days.")
        }
        
        return filteredPosts
    }
    
    func isLoggedIn() -> Bool {
        return (self._id == SessionManager.shared.retrieveUserSession()?._id)
    }
}

func getUserByID(userID: String) async -> User? {
    if let response: User = await ServerAPI.shared.fetchData(
        endpoint: "/user/id/\(userID)",
        responseType: User.self
    ){
        return response.processDatabaseRespons()
    }else{
        print( "Error fetching user with ID \(userID): Failed to fetch data")
        return nil
    }
}

func getUserByUsername(username: String) async -> User? {
    if let response: User = await ServerAPI.shared.fetchData(
        endpoint: "/user/username/\(username)",
        responseType: User.self
    ){
        return response.processDatabaseRespons()
    }else{
        print( "Error fetching user with user name \(username): Failed to fetch data")
        return nil
    }
}

func getAllUsers() async -> [User]? {
    if let response: [User] = await ServerAPI.shared.fetchData(
        endpoint: "/user/id/all",
        responseType: [User].self
    ){
        return response
    }else{
        print( "Error fetching users")
        return nil
    }
}

func login(username: String, password: String) async -> User? {
    
    struct userInfo: Codable {
        let username: String
        let password: String
    }
    
    if let res: User = await ServerAPI.shared.postData(
        endpoint: "/user/login",
        requestData: userInfo(username: username, password: password),
        responseType: User.self
    ) {
        let user = res.processDatabaseRespons()
        SessionManager.shared.saveUserSession(user: user)
        print("loggin in user: ", SessionManager.shared.retrieveUserSession()!)
        return user
    }
    
    return nil
}
