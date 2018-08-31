//
//  CmsMaster.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 8/31/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit

class CmsMaster: NSObject {
    var post_id :String
    var post_title :String
    var post_content :String
    
    override init() {
        post_id = ""
        post_title = ""
        post_content = ""
    }
    
    func initWithJsonData(jsonData : NSDictionary){
        post_id = jsonData["post_id"] as! String
        post_title = jsonData["post_title"] as! String
        post_content = jsonData["post_content"] as! String
    }
    
    func jsonRepresentation() -> String? {
        let dict = [
            "post_id" : post_id,
            "post_title" : post_title,
            "post_content" : post_content,
        ]
        let jsonData: Data? = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        
        var string: String? = nil
        if let aData = jsonData {
            string = String(data: aData, encoding: .utf8)
        }
        return string
    }
}
