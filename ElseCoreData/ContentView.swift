//
//  ContentView.swift
//  ElseCoreData
//
//  Created by Саша Восколович on 30.05.2024.
//

import SwiftUI

struct ContentView: View {
    
    @FetchRequest(fetchRequest: Contact.all()) private var contacts
    
    @State private var contactToEdit: Contact?
    @State private var searchConfig: SearchConfig = .init()
    @State private var sort: Sort = .asc
    
    let provider: CoreDataProvider
    
    var body: some View {
        NavigationStack {
            ZStack {
                if contacts.isEmpty {
                    NoContactView()
                } else {
                    List {
                        ForEach(contacts) { contact in
                            ZStack(alignment: .leading) {
                                NavigationLink(destination: ContactDetailView(contact)) {
                                    EmptyView()
                                }
                                .opacity(0)
                                ContactRowView(contact, with: provider)
                                    .swipeActions(allowsFullSwipe: true) {
                                        SwipeButtons(contact: contact)
                                    }
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchConfig.query)
            .navigationTitle("Contacts")
            .toolbar {
                leadingToolbarItem
                trailingToolbarItem
            }
            .sheet(item: $contactToEdit, onDismiss: {
                contactToEdit = nil
            }, content: { contact in
                NavigationStack {
                    CreateContactView(vm: .init(provider: provider,
                                                contact: contact))
                }
            })
            .onChange(of: searchConfig) { _, newConfig in
                contacts.nsPredicate = Contact.filter(with: newConfig)
            }
            .onChange(of: sort) { _, newSort in
                contacts.nsSortDescriptors = Contact.sort(order: newSort)
            }
        }
    }
}

private extension ContentView {
    
    @ViewBuilder
    private func SwipeButtons(contact: Contact) -> some View {
        UniversalButton(title: "Delete", systemImage: "trash", role: .destructive) {
            do {
                try provider.delete(contact, in: provider.newContext)
            } catch {
                print(error.localizedDescription)
            }
        }
        .tint(.red)
        
        UniversalButton(title: "Edit", systemImage: "pencil") {
            contactToEdit = contact
        }
        .tint(.orange)
    }
    
   
    private var menu: some View {
        Menu {
            Section {
                Text("Filter")
                UniversalPicker(
                    selection: $searchConfig.filter,
                    items: SearchConfig.Filter.allCases
                ) { Text("Filter Faves") }
            content: { filter in
                Text(filter.displayName)
              }
            }
            Section {
                Text("Sort")
                UniversalPicker(
                    selection: $sort,
                    items: Sort.allCases) { Text("Sort By") }
            content: { sort in
                    Label(sort.displayName, systemImage: sort.systemImage)
                }
            }
        } label: {
            Image(systemName: "ellipsis")
                .symbolVariant(.circle)
                .font(.title2)
        }
    }
    
    private var leadingToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            UniversalButton(systemImage: "plus") {
                contactToEdit = .empty(context: provider.newContext)
            }
            .font(.title2)
        }
    }
    
    private var trailingToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            menu
        }
    }
}


#Preview {
    ContentView(provider: Contact.previewProvider)
        .environment(\.managedObjectContext, Contact.previewProvider.context)
        .previewDisplayName("Contacts With Data")
        .onAppear {
            Contact.makePreview(count: 10, in: Contact.previewProvider.context)
        }
}

#Preview {
    ContentView(provider: Contact.previewProvider)
        .environment(\.managedObjectContext, Contact.previewProvider.context)
    .previewDisplayName("Contacts With No Data")
}
