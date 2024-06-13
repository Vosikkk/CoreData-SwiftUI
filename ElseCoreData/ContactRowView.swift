//
//  ContactRowView.swift
//  ElseCoreData
//
//  Created by Саша Восколович on 30.05.2024.
//

import SwiftUI

struct ContactRowView: View {
    
    @Environment(\.managedObjectContext) private var context
    
    @ObservedObject var contact: Contact
    
    let provider: CoreDataProvider
    
    init(_ contact: Contact, with provider: CoreDataProvider) {
        self.contact = contact
        self.provider = provider
    }
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            Text(contact.formattedName)
                .font(.system(size: 26, design: .rounded).bold())
            
            Text(contact.email)
                .font(.callout.bold())
            
            Text(contact.phoneNumber)
                .font(.callout.bold())
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(alignment: .topTrailing) {
            Button {
                toogleFave()
            } label: {
                Image(systemName: "star")
                    .font(.title3)
                    .symbolVariant(.fill)
                    .foregroundStyle(contact.isFavourite ? .yellow : .gray.opacity(0.3))
            }
            .buttonStyle(.plain)
        }
    }
}

private extension ContactRowView {
    func toogleFave() {
        contact.isFavourite.toggle()
        Task {
            do {
                try await provider.persist(in: context)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ContactRowView(.preview(context: Contact.previewProvider.context), with: Contact.previewProvider)
}
