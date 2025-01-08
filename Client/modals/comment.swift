//
//  comment.swift
//  FaceGram IOS
//
//  Created by Yuval Farangi on 13/12/2024.
//

import Foundation

struct Comment: Codable, Hashable {
    let _id: String? //comment id
    let user: String //user id
    let post: String //post id
    let commentText: String
    var createdAt: String?
    var updatedAt: String?
    let likes: [String]? //user's ids
    
    init(
        _id:String?="", user: String, post: String, commentText: String, createdAt: String? = "", updatedAt: String? = "", likes: [String] = []
    ){
        self._id = _id
        self.user = user
        self.post = post
        self.commentText = commentText
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.likes = likes
    }
    
    func isLoogedUserLiked() -> Bool{
        likes?.contains(SessionManager.shared.retrieveUserSession()?._id ?? "") ?? false
    }
    func add (){
        Task{
            await ServerAPI.shared.postData(endpoint: "/comment", requestData: self, responseType: serverResponse.self)
        }
    }
    func delete (){
        Task{
            await ServerAPI.shared.deleteData(endpoint: "/comment/\(self.post)/\(String(describing: self._id!))", responseType: serverResponse.self)
        }
    }
    func toogleLike(userID: String){
        struct data: Codable{
            let userID: String
            let postID: String
        }
        let reqData = data(userID: userID, postID: self.post)
        Task{
            await ServerAPI.shared.postData(endpoint: "/comment/like/\(String(describing: self._id!))", requestData: reqData, responseType: serverResponse.self)
        }
    }
    
    func isLogedUserAuthor() -> Bool {
        if let userSession = SessionManager.shared.retrieveUserSession() {
            return self.user == userSession._id
        }
        else {return false}
    }

}
