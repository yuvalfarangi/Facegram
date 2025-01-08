//
//  TextInput.swift
//  FaceGram IOS
//
//  Created by Yuval Farangi on 05/01/2025.
//

import SwiftUI

struct TextInput: View {
    
    var title: String
    @Binding var field: String
    
    var body: some View {
        TextField(title, text: $field)
            .font(.headline)
            .fontWeight(.bold)
            .padding(10)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 2)
            )
            .padding([.leading, .trailing])
    }
}

#Preview {
    @State var fullName: String = ""
    TextInput(title: "Full Name", field: $fullName)
}
