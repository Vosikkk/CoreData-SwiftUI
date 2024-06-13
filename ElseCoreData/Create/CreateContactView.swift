//
//  CreateContactView.swift
//  ElseCoreData
//
//  Created by Саша Восколович on 30.05.2024.
//

import SwiftUI

struct CreateContactView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var vm: EditContactViewModel
    
    @State private var hasError: Bool = false
    
    var body: some View {
        List {
            Section("General") {
                
                nameTextField
                
                emailTextField
                
                phonenumberTextField
                
                datePicker
                
                Toggle("Favourite", isOn: $vm.contact.isFavourite)
            }
            
            Section("Notes") {
                notesTextField
            }
        }
        .navigationTitle(vm.isNew ? "New Contact" : "Update Contact")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done", action: validate)
            }
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .alert("Something aren't right", isPresented: $hasError, actions: {}) {
            Text("It looks like your form is invalid")
        }
    }
    
    
    private var nameTextField: some View {
        TextField("Name", text: $vm.contact.name)
            .keyboardType(.numberPad)
    }
    
    private var emailTextField: some View {
        TextField("Email", text: $vm.contact.email)
            .keyboardType(.emailAddress)
    }
    
    private var phonenumberTextField: some View {
        TextField("Phone Number", text: $vm.contact.phoneNumber)
            .keyboardType(.phonePad)
    }
    
    private var notesTextField: some View {
        TextField("", text: $vm.contact.notes, axis: .vertical)
    }
    
    private var datePicker: some View {
        DatePicker("Birthday",
                   selection: $vm.contact.dob,
                   displayedComponents: [.date])
        .datePickerStyle(.compact)
    }
}


private extension CreateContactView {
    func validate() {
        if vm.contact.isValid {
            Task {
                do {
                    try await vm.save()
                    dismiss()
                } catch {
                    print(error.localizedDescription)
                }
            }
        } else {
            hasError = true
        }
    }
}

#Preview {
    NavigationStack {
        let preview = Contact.previewProvider
        CreateContactView(vm: .init(provider: preview))
            .environment(\.managedObjectContext, preview.context)
    }
}
