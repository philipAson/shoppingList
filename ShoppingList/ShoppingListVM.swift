//
//  ShoppingListVM.swift
//  ShoppingList
//
//  Created by Philip Andersson on 2023-04-17.
//

import Foundation
import Firebase

class ShoppingListVM : ObservableObject {
    let db = Firestore.firestore()
    let auth = Auth.auth()
    
    @Published var items = [Item]()
    
    func toggle(item :Item) {
        guard let user = auth.currentUser else {return}
        let itemsRef = db.collection("Users").document(user.uid).collection("Items")
        
        if let id = item.id {
            itemsRef.document(id).updateData(
                ["done" : !item.done])
        }
    }
    
    func saveToFirestore(itemName: String) {
        guard let user = auth.currentUser else {return}
        let itemsRef = db.collection("Users").document(user.uid).collection("Items")
        
        let item = Item(name: itemName)
        
        do {
            try itemsRef.addDocument(from: item)
        } catch {
            print("Error saving to db")
        }
    }
    
    func delete(index : Int) {
        guard let user = auth.currentUser else {return}
        let itemsRef = db.collection("Users").document(user.uid).collection("Items")
        
        let item = items[index]
        if let id = item.id {
            itemsRef.document(id).delete()
        }
    }
    
    func listenToFirestore() {
        guard let user = auth.currentUser else {return}
        let itemsRef = db.collection("Users").document(user.uid).collection("Items")
        
        itemsRef.addSnapshotListener() {
            snapshot, err in
            
            guard let snapshot = snapshot else {return}
            
            if let err = err {
                print("error getting document \(err)")
            } else {
                self.items.removeAll()
                for document in snapshot.documents {
                    
                    do{
                        let item = try document.data(as : Item.self)
                        self.items.append(item)
                    } catch {
                        print("Error reding from db")
                    }
                    
                }
            }
        }
        
    }
}
