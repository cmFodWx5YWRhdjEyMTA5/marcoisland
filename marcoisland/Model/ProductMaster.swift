//
//  CmsMaster.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 8/31/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit

class ProductMaster: Decodable {
    var id :String?
    var item_name :String?
    var item_des :String?
    var item_price :String?
    var item_image1 :String?
    var item_image2 :String?
    
    init() {
        id = ""
        item_name = ""
        item_des = ""
        item_price = ""
        item_image1 = ""
        item_image2 = ""
    }
    
    func initWithJsonData(jsonData : NSDictionary){
        id = jsonData["id"] as? String
        item_name = jsonData["item_name"] as? String
        item_des = jsonData["item_des"] as? String
        item_price = jsonData["item_price"] as? String
        item_image1 = jsonData["item_image1"] as? String
        item_image2 = jsonData["item_image2"] as? String
    }
    
    func jsonRepresentation() -> String? {
        let dict = [
            "id" : id,
            "item_name" : item_name,
            "item_des" : item_des,
            "item_price" : item_price,
            "item_image1" : item_image1,
            "item_image2" : item_image2,
        ]
        let jsonData: Data? = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        
        var string: String? = nil
        if let aData = jsonData {
            string = String(data: aData, encoding: .utf8)
        }
        return string
    }
}
