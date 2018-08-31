//
//  RestcallManager.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 8/31/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit
import Alamofire

class RestcallManager: NSObject {
    static let sharedInstance = RestcallManager()
    
    func getBaseUrl() -> String {
        return "http://mica.h10testing1.info/wp-api/"
    }
}
