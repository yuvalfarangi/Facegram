//
//  fileConvertor_Base64.swift
//  FaceGram IOS
//
//  Created by Yuval Farangi on 12/12/2024.
//

import Foundation
import UIKit

func encodeBase64(image: UIImage) -> String? {
    guard let imageData = image.jpegData(compressionQuality: 0.8) else { return nil }
    return imageData.base64EncodedString()
}

func decodeBase64(string: String) -> UIImage? {
    guard let imageData = Data(base64Encoded: string) else { return nil }
    return UIImage(data: imageData)
}
