//
//  logoMD.swift
//  FaceGram IOS
//
//  Created by Yuval Farangi on 29/11/2024.
//

import SwiftUI

struct logoMD: View {
    
    
    var body: some View {
        HStack {
            Image("facegram_logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40, alignment: .center)
            
            Text("Facegram")
                .font(Font.custom("Pacifico", size: 30))
        }.padding()
    }
}


#Preview(traits: .sizeThatFitsLayout) {
    logoMD()
}
