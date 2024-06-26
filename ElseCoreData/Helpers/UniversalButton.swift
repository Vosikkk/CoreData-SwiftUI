//
//  UniversalButton.swift
//  ElseCoreData
//
//  Created by Саша Восколович on 01.06.2024.
//

import SwiftUI

struct UniversalButton: View {
   
    var title: String? = nil
    var systemImage: String? = nil
    var role: ButtonRole?
    let action: () -> Void
    
    
    init(title: String? = nil, systemImage: String? = nil, role: ButtonRole? = nil, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.role = role
        self.action = action
    }
    
    
    var body: some View {
        Button(role: role) {
            action()
        } label: {
            if let title, let systemImage {
                Label(title, systemImage: systemImage)
            } else if let title {
                Text(title)
            } else if let systemImage {
                Image(systemName: systemImage)
            }
        }
    }
}


