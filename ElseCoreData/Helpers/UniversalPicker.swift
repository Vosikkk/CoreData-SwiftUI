//
//  UniversalPicker.swift
//  ElseCoreData
//
//  Created by Саша Восколович on 01.06.2024.
//

import SwiftUI

struct UniversalPicker<T: Hashable, L: View, Content: View>: View {
    
    @Binding var selection: T
    var items: [T]
    var label: () -> L
    var content: (T) -> Content
    
    var body: some View {
        Picker(selection: $selection, label: label()) {
            ForEach(items, id: \.self) { item in
                   content(item)
                    .tag(item)
            }
        }
    }
}
