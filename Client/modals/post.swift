import Foundation
import UIKit

struct Post: Codable {
    
    let _id: String?
    let user: String //user id
    var caption: String?
    var tags: [String]?
    var encodedMedia: String?  // This stores the media as a string 
    var decodedMedia: UIImage? // This stores the decoded image (UIImage)
    var likes: [String]? //user's ids
    var comments: [Comment]?
    var createdAt: String?
    var updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case _id
        case user
        case caption
        case tags
        case encodedMedia
        case likes
        case comments
        case createdAt
        case updatedAt
    }
    
    init(id: String? = "", user: String, caption: String? = "", tags: [String]? = [], encodedMedia: String? = "", likes: [String]? = [], comments: [Comment]? = [], createdAt: String? = "", updatedAt: String? = "", decodedMedia: UIImage? = UIImage()) {
        self._id = id
        self.user = user
        self.caption = caption
        self.tags = tags
        self.encodedMedia = encodedMedia
        self.likes = likes
        self.comments = comments
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.decodedMedia = decodedMedia
    }
    
    // A simple function to handle the media if necessary
    func processDatabaseRespons() -> Post {
        return Post(
            id: self._id ?? "",
            user: self.user,
            caption: self.caption ?? "",
            tags: self.tags ?? [],
            encodedMedia: self.encodedMedia ?? "",
            likes: self.likes ?? [],
            comments: self.comments ?? [],
            createdAt: self.createdAt ?? "",
            updatedAt: self.updatedAt ?? "",
            decodedMedia: decodeBase64(string: self.encodedMedia ?? "") ?? UIImage()
        )
    }
    
    func upload(){
        Task{
            await ServerAPI.shared.postData(endpoint: "/post", requestData: self, responseType: serverResponse.self)
        }
    }
    
    func isLogedUserAuthor() -> Bool {
        if let userSession = SessionManager.shared.retrieveUserSession() {
            return self.user == userSession._id
        }
        else {return false}
    }
    
    func isLikedByUser(user: User) -> Bool {
        guard let userId = user._id else {
            print("Error: User ID is nil")
            return false
        }
        
        if let likes = self.likes {
            return likes.contains(userId)
        } else {
            return false
        }
    }
    
    
    func update(actionType: String){
        Task {
            let response = await ServerAPI.shared.patchData(
                endpoint: "/post/\(String(describing: self._id!))/\(actionType)",
                requestData: self,
                responseType: serverResponse.self
            )
            print("Update successful: \(String(describing: response))")
        }
    }
    
    mutating func toggleLike(user: User) {
        guard let userId = user._id else {
            print("Error: User ID is nil")
            return
        }
        var actionType: String = ""
        
        // Ensure likes is not nil before proceeding
        if var likes = self.likes {
            if self.isLikedByUser(user: user) {
                likes.remove(at: likes.firstIndex(of: userId)!) // safely unwrap the index
                actionType = "unlike"
            } else {
                likes.append(userId)
                actionType = "like"
            }
            self.likes = likes // Update the array back to the original variable
        } else {
            print("Error: Likes array is nil")
        }
        
        self.update(actionType: actionType);
    }
}

func getPostsByTag(tag: String) async -> [String] {
    let fetchedPosts: [String]
    
    fetchedPosts = await ServerAPI.shared.fetchData(
        endpoint: "/post/tag/\(tag)",
        responseType: [String].self
    ) ?? []
    
    return fetchedPosts
}

func getPostByID(postID: String) async -> Post? {
    if let response: Post = await ServerAPI.shared.fetchData(
        endpoint: "/post/\(postID)",
        responseType: Post.self
    ) {
        return response.processDatabaseRespons()
    } else {
        print("Error fetching post with ID \(postID): Failed to fetch data")
        return nil
    }
}
