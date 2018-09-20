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
    
    // Check User Default exist or not
    static func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
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
    
    static func customLoader(_ mainWindow: UIWindow?) -> UIView? {
        
        let loadingView = UIView(frame: CGRect(x: 100, y: 400, width: 80, height: 80))
        loadingView.center = CGPoint(x: (mainWindow?.frame.size.width ?? 0.0) / 2, y: (mainWindow?.frame.size.height ?? 0.0) / 2)
        loadingView.backgroundColor = UIColor(white: 0.0, alpha: 1.0)
        loadingView.layer.cornerRadius = 5
        
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.center = CGPoint(x: loadingView.frame.size.width / 2.0, y: 35)
        activityView.startAnimating()
        activityView.tag = 100
        loadingView.addSubview(activityView)
        
        let lblLoading = UILabel(frame: CGRect(x: 0, y: 48, width: 80, height: 30))
        lblLoading.text = "Loading..."
        lblLoading.textColor = UIColor.white
        if let aSize = UIFont(name: lblLoading.font.fontName, size: 15) {
            lblLoading.font = aSize
        }
        lblLoading.textAlignment = .center
        loadingView.addSubview(lblLoading)
        
        return loadingView
    }
    
    
    static func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 5, y: 5)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    
    static func load_image(image_url_string:String, view:UIImageView)
    {
        let img_encoded_url = image_url_string.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let image_url: NSURL = (NSURL(string: img_encoded_url!))!
        let image_from_url_request: NSURLRequest = NSURLRequest(url: image_url as URL)
        
        NSURLConnection.sendAsynchronousRequest(
            image_from_url_request as URLRequest, queue: OperationQueue.main,
            completionHandler: {(response: URLResponse!,
                data: Data!,
                error: Error!) -> Void in
                if error == nil && data != nil {
                    view.image = UIImage(data: data)
                }
        })

        //        let request = URLRequest(url: URL(string: image_url_string)!)
        //        let session = URLSession.shared
        //        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
        //
        //            do {
        //                if error == nil && data != nil {
        //                    view.image = UIImage(data: data!)
        //                }
        //            } catch {
        //                print("error")
        //            }
        //
        //        })
        
        //       task.resume()
        
    }
}
