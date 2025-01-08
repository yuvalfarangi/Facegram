//
//  counter.swift
//  FaceGram IOS
//
//  Created by Yuval Farangi on 05/12/2024.
//

import SwiftUI

struct counter: View {
    let name:String
    let count:Int
    var body: some View {
        VStack{
            Text(String(count))
                .font(.title2)
                .fontWeight(.bold)
                
            Text(name)
                .font(.footnote)
                
        }.padding()
    }
}

#Preview {
    counter(name: "Followers", count: 1043)
}
