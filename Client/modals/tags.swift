//
//  tags.swift
//  FaceGram IOS
//
//  Created by Yuval Farangi on 29/12/2024.
//

import Foundation

struct Tags: Codable {
    var tags: [String]

    init(tags: [String]) {
        self.tags = tags
    }
    
}

public func getTags(base64Media: String) async -> [String] {
    let requestData = ["image_base64": base64Media]
    if let res = await ServerAPI.shared.postData(endpoint: "/tags", requestData: requestData, responseType: Tags.self) {
        return res.tags
    }
    return [] // Return an empty array if the request fails
}
