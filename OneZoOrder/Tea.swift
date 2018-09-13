//
//  Tea.swift
//  OneZoOrder
//
//  Created by Jason Hsu on 2018/8/26.
//  Copyright © 2018 junchoon. All rights reserved.
//

import Foundation

struct TeaData {
    var id: String
    var name: String
    var password: String
    var teaName: String
    var price: String
    var cup: String
    var sugar: String
    var ice: String
    var note: String
    var editable: String
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? String, let name = json["name"] as? String, let password = json["password"] as? String, let teaName = json["teaName"] as? String, let price = json["price"] as? String, let cup = json["cup"] as? String, let sugar = json["sugar"] as? String, let ice = json["ice"] as? String, let note = json["note"] as? String, let editable = json["editable"] as? String else {
            return nil
        }
        self.id = id
        self.name = name
        self.password = password
        self.teaName = teaName
        self.price = price
        self.cup = cup
        self.sugar = sugar
        self.ice = ice
        self.note = note
        self.editable = editable
    }
}


struct DrinkList {
    
    var drinkName: String
    var drinkPrice: String
   
}
