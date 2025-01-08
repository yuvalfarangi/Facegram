//
//  upload.swift
//  FaceGram IOS
//
//  Created by Yuval Farangi on 29/11/2024.
//

import SwiftUI

struct uploadScreen: View {
    
    @State private var image: UIImage = UIImage(imageLiteralResourceName: "PostDemoImage")
    @State private var postCaption: String = ""
    @State private var selectedTags: [String] = []
    @State private var avaliableTags:[String] = []
    @State private var isLoading: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                mediaPicker(selectedImage: $image)
                
                TextField("Post Caption", text: $postCaption)
                    .padding()
                    .font(.headline)

                if(isLoading){
                    ProgressView("Loading Tags...").progressViewStyle(CircularProgressViewStyle()).padding()
                }else{
                    tagsPicker(items: avaliableTags, selectedTags: $selectedTags)
                }

                primaryButton(
                    onPress: {
                        // Upload the new post only if an image is selected
                        if image != UIImage(imageLiteralResourceName: "PostDemoImage") {
                            let newPost = Post(
                                user: (SessionManager.shared.retrieveUserSession()?._id)!,
                                caption: postCaption,
                                tags: selectedTags,
                                encodedMedia: encodeBase64(image: image)
                            )
                            newPost.upload()
                        }

                        // Reset the upload screen
                        image = UIImage(imageLiteralResourceName: "PostDemoImage")
                        postCaption = ""
                        selectedTags = []
                    },
                    text: "Upload", symbolName: "arrow.up.circle.fill"
                )
            }
            .navigationTitle("Upload")
            .onChange(of: image) { _ in
                isLoading = true
                Task{
                    avaliableTags = await getTags(base64Media: encodeBase64(image: image) ?? "")
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    uploadScreen()
}
