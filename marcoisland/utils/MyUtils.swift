//
//  MyUtils.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 8/30/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit

class MyUtils: NSObject {
    
    static func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    static func validateMobile(enteredMobile: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        return phoneTest.evaluate(with: enteredMobile)
    }
    
    static func setUserDefault(key: String, value: String) -> Void {
        UserDefaults.standard.set(value, forKey: key) //String
    }
    
    static func getUserDefault(key: String) -> String {
        return UserDefaults.standard.string(forKey: key)!
    }
    
    static func removeUserDefault(key: String) -> Void {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
