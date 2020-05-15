//
//  Category.swift
//  TodoList-IOS
//
//  Created by Dewesh Sunuwar on 15/5/20.
//  Copyright © 2020 Dewesh Sunuwar. All rights reserved.
//

import UIKit
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
