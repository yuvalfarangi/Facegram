//
//  tagOptionPicker.swift
//  FaceGram IOS
//
//  Created by Yuval Farangi on 12/12/2024.
//


import SwiftUI

struct tagOptionPicker: View {
    let text: String
    @Binding var isSelected: Bool
    let onPress: (() -> Void)?

    init(text: String, isSelected: Binding<Bool>, onPress: (() -> Void)? = nil) {
        self.text = text
        self._isSelected = isSelected
        self.onPress = onPress
    }

    var body: some View {
        Button(action: {
            isSelected.toggle()
            onPress?()
        }) {
            Text(text)
                .font(.system(size: 15))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(isSelected ? Color.PrimaryColor : Color.gray.opacity(0.3))
                .foregroundColor(isSelected ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 100))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    @State var isSelected: Bool = false
    tagOptionPicker(text: "Programming", isSelected: $isSelected)
}
