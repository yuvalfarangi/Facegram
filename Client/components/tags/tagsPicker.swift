import SwiftUI

struct tagsPicker: View {
    @Binding var selectedTags: [String]
    let items: [String]
    var groupedItems: [[String]]
    let screenWidth = UIScreen.main.bounds.width

    init(items: [String], selectedTags: Binding<[String]>) {
        self.items = items
        self._selectedTags = selectedTags
        self.groupedItems = []
        self.groupedItems = createGroupedItems(items) 
    }

    private func createGroupedItems(_ items: [String]) -> [[String]] {
        var groupedItems: [[String]] = []
        var tempItems: [String] = []
        var width: CGFloat = 0

        for word in items {
            let label = UILabel()
            label.text = word
            label.sizeToFit()
            let labelWidth = label.frame.size.width + 32

            if (width + labelWidth) < screenWidth {
                width += labelWidth
                tempItems.append(word)
            } else {
                groupedItems.append(tempItems)
                tempItems = [word]
                width = labelWidth
            }
        }

        if !tempItems.isEmpty {
            groupedItems.append(tempItems)
        }

        return groupedItems
    }

    private func toggleTag(_ tag: String) {
        if selectedTags.contains(tag) {
            selectedTags.removeAll { $0 == tag }
        } else {
            selectedTags.append(tag)
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(groupedItems, id: \.self) { subItems in
                HStack {
                    ForEach(subItems, id: \.self) { word in
                        tagOptionPicker(
                            text: word,
                            isSelected: .constant(selectedTags.contains(word)),
                            onPress: {
                                toggleTag(word)
                            }
                        )
                    }
                }
            }
        }
    }
}
