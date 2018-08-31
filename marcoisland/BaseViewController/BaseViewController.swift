//
//  BaseViewController.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 8/31/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit

//******************************************************************************************************
//*All the HEXCOLOR VARIABLE
//*IT IS COMMON COLOR FOR ALL THE BUTTON , TEXT TITLE , AND PRAGRAPH
//******************************************************************************************************

let HEXCOLOR_TINT = 0xFF6F6D
let HEXCOLOR_TITLE = 0x14474E
let HEXCOLOR_PAGAGRAPH = 0xB4B4B4
let HEXCOLOR_DARKGRAY = 0x50646E
let HEXCOLOR_BLUE = 0x507486

//******************************************************************************************************
//*WE ARE CREAETE HERE A VARIABLE OF STORYBOARD
//******************************************************************************************************
let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)


class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.setValue(false, forKey:"_UIConstraintBasedLayoutLogUnsatisfiable")
        
    }
    
    
    
    //*****************************************************************************************
    //*The send the value red , green and blue return me color as you want.
    //******************************************************************************************
    
    func UIColorFromRGB(red: float_t, green: float_t, blue: float_t) -> UIColor {
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
    
    func colorFromRGBA(fromHex: Int, alpha: CGFloat) -> UIColor {
        let red =   CGFloat((fromHex & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((fromHex & 0x00FF00) >> 8) / 0xFF
        let blue =  CGFloat(fromHex & 0x0000FF) / 0xFF
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /*
     @ UIAlertView PopUp Method
     */
    func showAlertView(title : String, msg :String, controller:UIViewController, okClicked : @escaping ()->()){
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
            print("You've pressed Ok");
        }
        alertController.addAction(actionOk)
        self.present(alertController, animated: true, completion: nil)
    }
}

