//
//  Item.swift
//  Todoey
//
//  Created by Ali KINU on 28.03.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false                   //note :  Array<Int>() == [Int]()
    @objc dynamic var dateCreated : Date?
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")   // for realtionship items cehck it out!
}
