//
//  ElseCoreDataApp.swift
//  ElseCoreData
//
//  Created by Саша Восколович on 30.05.2024.
//

import SwiftUI

@main
struct ElseCoreDataApp: App {
    
    let provider: ContactsProvider = ContactsProvider()
    
    var body: some Scene {
        WindowGroup {
            ContentView(provider: provider)
                .environment(\.managedObjectContext, provider.context)
        }
    }
}
