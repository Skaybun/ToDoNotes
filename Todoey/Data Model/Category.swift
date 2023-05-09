//
//  Category.swift
//  Todoey
//
//  Created by Ali KINU on 28.03.2023.


import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var colour : String = ""
    let items = List<Item>()
}
