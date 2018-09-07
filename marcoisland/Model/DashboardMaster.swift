//
//  CmsMaster.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 8/31/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit

class DashboardMaster: Decodable {
    var id :String?
    var cms_title :String?
    var cms_image_thumb :String?
    var cms_image_large :String?
    var cms_des :String?
    var top_image :String?
    var scroll_text :String?
    
    init() {
        id = ""
        cms_title = ""
        cms_image_thumb = ""
        cms_image_large = ""
        cms_des = ""
        top_image = ""
        scroll_text = ""
    }
    
    func initWithJsonData(jsonData : NSDictionary){
        id = jsonData["id"] as? String
        cms_title = jsonData["cms_title"] as? String
        cms_image_thumb = jsonData["cms_image_thumb"] as? String
        cms_image_large = jsonData["cms_image_large"] as? String
        cms_des = jsonData["cms_des"] as? String
        top_image = jsonData["top_image"] as? String
        scroll_text = jsonData["scroll_text"] as? String
    }
    
    func jsonRepresentation() -> String? {
        let dict = [
            "id" : id,
            "cms_title" : cms_title,
            "cms_image_thumb" : cms_image_thumb,
            "cms_image_large" : cms_image_large,
            "cms_des" : cms_des,
            "top_image" : top_image,
            "scroll_text" : scroll_text,
            
        ]
        let jsonData: Data? = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        
        var string: String? = nil
        if let aData = jsonData {
            string = String(data: aData, encoding: .utf8)
        }
        return string
    }
}
