//
//  Item.swift
//  ShoppingList
//
//  Created by Philip Andersson on 2023-04-17.
//

import Foundation
import FirebaseFirestoreSwift

struct Item : Codable, Identifiable {
    
    @DocumentID var id : String?
    var name : String
    var category : String = ""
    var done : Bool = false
    
}
