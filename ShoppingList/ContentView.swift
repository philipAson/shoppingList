//
//  ContentView.swift
//  ShoppingList
//
//  Created by Philip Andersson on 2023-04-17.
//

import SwiftUI
import Firebase

struct ContentView : View{
    
    @State var signedIn : Bool = false
    
    var body: some View {
        if !signedIn {
            SignIngView(signedIn: $signedIn)
        } else {
            ShoppingListView()
        }
    }
}

struct SignIngView : View {
    
    @Binding var signedIn : Bool
    var auth = Auth.auth()
    
    var body: some View {
        Button(action: {
            auth.signInAnonymously { result, error in
                if let error = error {
                    print("error signing in")
                } else {
                    signedIn = true
                }
            }
        }) {
            Text("Sign In")
        }
    }
}


struct ShoppingListView: View {
    
    @StateObject var shoppingListVM = ShoppingListVM()
    @State var showingAddAlert = false
    @State var newItemName = ""
    
    var body: some View {
        VStack {
            List {
                ForEach(shoppingListVM.items) { item in
                    RowView(item: item, vm: shoppingListVM)
                }
                .onDelete() { IndexSet in
                    for index in IndexSet {
                        shoppingListVM.delete(index: index)
                    }
                }
            }
            Button(action: {
                showingAddAlert = true
            }) {
                Text("Add")
            }
            .alert("Lägg till", isPresented: $showingAddAlert) {
                TextField("Lägg till", text: $newItemName)
                Button("Add", action: {
                    shoppingListVM.saveToFirestore(itemName: newItemName)
                    newItemName = ""
                })
            }
        }.onAppear() {
            //            saveToFirestore(itemName: "Morötter")
            //            saveToFirestore(itemName: "Gurka")
            //            saveToFirestore(itemName: "Bananer")
            shoppingListVM.listenToFirestore()
        }
    }
    
    
    
    
    struct RowView: View {
        let item : Item
        let vm : ShoppingListVM
        
        var body: some View {
            HStack {
                Text(item.name)
                Spacer()
                Button(action: {
                    vm.toggle(item: item)
                }) {
                    Image(systemName: item.done ? "checkmark.square" :
                            "square")
                }
                
            }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
