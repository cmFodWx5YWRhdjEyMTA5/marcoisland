//
//  DataStore.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 8/31/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit

class DataStore: NSObject {
    var cmsDict: NSMutableDictionary = [:]
    
    static let sharedInstance = DataStore()
    
    
    func addCms(_ driverArray: NSArray) {
        cmsDict.removeAllObjects()
        if driverArray.count > 0 {
            for i in 0..<(driverArray.count ) {
                let fund = driverArray[i] as? CmsMaster
                if let anId = fund?.post_id {
                    cmsDict[anId] = fund
                }
            }
        }
    }
    
    func getCms() -> NSArray {
        return cmsDict.allValues as NSArray
    }
}
