//
//  GlobalVariable.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 9/3/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit

class GlobalVariable: NSObject {
    static var globalVariable: String?
    static var deviceToken: String?
    
    static func setGlobalMessage(message:String) {
        globalVariable = message
    }
    static func getGlobalMessage()->String {
        return globalVariable!
    }
    static func setDeviceToken(message:String) {
        globalVariable = message
    }
    static func getDeviceToken()->String {
        return globalVariable!
    }
}
