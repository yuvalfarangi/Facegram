import SwiftUI

struct resizeableSymbol: View {
    let symbolName: String
    let size: CGFloat
    let onPress: () -> Void
    let color: Color

    // Default initializer makes `onPress` optional
    init(symbolName: String, size: CGFloat, onPress: @escaping () -> Void = {}, color: Color = .primary) {
        self.symbolName = symbolName
        self.size = size
        self.onPress = onPress
        self.color=color
    }

    var body: some View {
        Button(action: {
            onPress()
        }) {
            Image(systemName: symbolName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size)
                .foregroundStyle(color)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    resizeableSymbol(symbolName: "heart.fill", size: 20)
}
