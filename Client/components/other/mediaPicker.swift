//
//  mediaPicker.swift
//  FaceGram IOS
//
//  Created by Yuval Farangi on 10/12/2024.
//

import SwiftUI
import PhotosUI

struct mediaPicker: View {
    
    @Binding var selectedImage: UIImage
    @State private var PhotosPickerItem: PhotosPickerItem?
    
    var body: some View {
        VStack {
            
            HStack{
                PhotosPicker(selection: $PhotosPickerItem, matching: .any(of: [.images])) {
                    HStack{
                        Image(systemName: "photo.stack")
                            .font(.title2)
                        
                        Text("Select from gallery")
                    }
                    .foregroundColor(.PrimaryColor)
                }
                .onChange(of: PhotosPickerItem) { _, _ in
                    Task {
                        if let PhotosPickerItem {
                            do {
                                // Attempt to load the image data
                                if let data = try await PhotosPickerItem.loadTransferable(type: Data.self),
                                   let pickedImage = UIImage(data: data) {
                                    // Update the binding property with the new image
                                    selectedImage = pickedImage
                                }
                            } catch {
                                print("Error loading image: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
            Image(uiImage: selectedImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(20)
                .padding()
        }
    }
}

#Preview {
    @Previewable @State var uiImage: UIImage = UIImage(imageLiteralResourceName: "PostDemoImage")
    mediaPicker(selectedImage: $uiImage)
}
