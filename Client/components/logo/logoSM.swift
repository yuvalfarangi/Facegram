//
//  logoSM.swift
//  FaceGram IOS
//
//  Created by Yuval Farangi on 01/12/2024.
//

import SwiftUI

struct logoSM: View {
    
    
    var body: some View {
        HStack {
            Image("facegram_logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30, alignment: .center)
            
            Text("Facegram")
                .font(Font.custom("Pacifico", size: 25))
        }.padding()
    }
}


#Preview(traits: .sizeThatFitsLayout) {
    logoSM()
}
