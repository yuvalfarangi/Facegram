//
//  primaryButton.swift
//  FaceGram IOS
//
//  Created by Yuval Farangi on 05/12/2024.
//

import SwiftUI

struct primaryButton: View {
    let onPress: () -> Void
    let text: String
    let symbolName: String? // Optional SF Symbol name

    var body: some View {
        Button(action: { onPress() }) {
            HStack(spacing: 10) {
                // Add SF Symbol if provided
                if let symbolName = symbolName {
                    Image(systemName: symbolName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(.white)
                }
                Text(text)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.PrimaryColor)
            .cornerRadius(50)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    primaryButton(onPress: {print("Button Pressed")}, text: "Button Text", symbolName:"heart")
}
