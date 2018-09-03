//
//  WebServiceResponse.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 9/3/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit

class WebServiceResponse: NSObject {
    var Data :String
    var StatusCode :String
    
    override init() {
        Data = ""
        StatusCode = "-100"
    }
    
    func initWithJsonData(jsonData : [String: Any])->Any{
        Data = jsonData["Data"] as! String
        StatusCode = jsonData["StatusCode"] as! String
        return self
    }
    
    func jsonRepresentation() -> String? {
        let dict = [
            "Data" : Data,
            "StatusCode" : StatusCode,
            ]
        let jsonData: Data? = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        var string: String? = nil
        if let aData = jsonData {
            string = String(data: aData, encoding: .utf8)
        }
        return string
    }
}


