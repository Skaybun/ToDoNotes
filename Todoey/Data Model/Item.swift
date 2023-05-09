//
//  Item.swift
//  Todoey
//
//  Created by Ali KINU on 28.03.2023.

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false                
    @objc dynamic var dateCreated : Date?
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")   
}
