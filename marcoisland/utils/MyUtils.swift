//
//  MyUtils.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 8/30/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit

class MyUtils: NSObject {
    
        
    static let sharedInstance = MyUtils()
    private override init() {}
    
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
    
    // Set User Default
    static func setUserDefault(key: String, value: String) {
        UserDefaults.standard.set(value, forKey: key) //String
    }
    // Get User Default
    static func getUserDefault(key: String) -> String {
        return UserDefaults.standard.string(forKey: key)!
    }
    
    // remove a particular User Default
    static func removeUserDefault(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    // Get color using Hex code
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    //*****************************************************************************************
    //*The send the value red , green and blue return me color as you want.
    //******************************************************************************************
    
    static func UIColorFromRGB(red: float_t, green: float_t, blue: float_t) -> UIColor {
        return UIColor(
            red: CGFloat (red / 255.0),
            green: CGFloat (green / 255.0),
            blue: CGFloat (blue / 255.0),
            alpha: CGFloat(1.0)
        )
    }
    
    //*************************************************************************************
    //*The method gives us color after send hex color
    //*************************************************************************************
    
    static func colorFromRGBA(fromHex: Int, alpha: CGFloat) -> UIColor {
        let red =   CGFloat((fromHex & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((fromHex & 0x00FF00) >> 8) / 0xFF
        let blue =  CGFloat(fromHex & 0x0000FF) / 0xFF
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func showAlertViewDialog(title : String, msg :String, controller:UIViewController, okClicked : @escaping ()->()){
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
            print("You've pressed Ok");
        }
        alertController.addAction(actionOk)
        controller.present(alertController, animated: true, completion: nil)
    }
}
