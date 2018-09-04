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
    var userDict: NSMutableDictionary = [:]
    var dashboardDict: NSMutableDictionary = [:]
    
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
    
    func addUser(_ userArray: NSArray) {
        userDict.removeAllObjects()
        if userArray.count > 0 {
            for i in 0..<(userArray.count ) {
                let fund = userArray[i] as? UserMaster
                if let anId = fund?.id {
                    userDict[anId] = fund
                }
            }
        }
    }
    
    func getUser() -> NSArray {
        return userDict.allValues as NSArray
    }
    
    func addDashboard(_ dashboardArray: NSArray) {
        dashboardDict.removeAllObjects()
        if dashboardArray.count > 0 {
            for i in 0..<(dashboardArray.count ) {
                let fund = dashboardArray[i] as? DashboardMaster
                if let anId = fund?.id {
                    dashboardDict[anId] = fund
                }
            }
        }
    }
    
    func getDashboard() -> NSArray {
        return dashboardDict.allValues as NSArray
    }
}
