//
//  NoContactView.swift
//  ElseCoreData
//
//  Created by Саша Восколович on 31.05.2024.
//

import SwiftUI

struct NoContactView: View {
    var body: some View {
        VStack {
            Text("💀 No contacts")
                .font(.largeTitle.bold())
            Text("It's seems a lil empty here to create some contact 👆🏻")
                .font(.callout)
               
        }
    }
}

#Preview {
    NoContactView()
}

