//
//  ActivationScreen.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 8/30/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit

class ActivationScreen: BaseViewController,UITextFieldDelegate {

    var window: UIWindow?
    @IBOutlet weak var viewActivation: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtActivationCode: UITextField!
    @IBOutlet weak var viewTxtEmail: UIView!
    @IBOutlet weak var viewTxtActivationCode: UIView!
    @IBOutlet weak var btnVerify: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        viewActivation.layer.cornerRadius = 10
        viewActivation.clipsToBounds = true
        btnVerify.layer.cornerRadius = 5
        btnVerify.clipsToBounds = true
        UITextField.appearance().tintColor = colorFromRGBA(fromHex: HEXCOLOR_TINT, alpha: 1)
    }
    
    //MARK: TextField Delegate Method:-☞🙂
    /*
     @ The function is called first time when user write the text.
     @ It is a textfield delegate method.
     */
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        switch textField.tag {
        case 1:
            viewTxtEmail.backgroundColor = colorFromRGBA(fromHex: HEXCOLOR_TINT, alpha: 1)
            viewTxtActivationCode.backgroundColor = UIColor.black
        case 2:
            viewTxtEmail.backgroundColor = UIColor.black
            viewTxtActivationCode.backgroundColor = colorFromRGBA(fromHex: HEXCOLOR_TINT, alpha: 1)
            
        default:
            DefaultColor()
        }
    }
    
    /*
     @ The function is used for the textfield return
     @ It is a textfield delegate method
     */
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        DefaultColor()
        
        switch textField.tag {
        case 1:
            txtEmail.resignFirstResponder()
            txtActivationCode.becomeFirstResponder()
        case 2:
            txtActivationCode.resignFirstResponder()
        default:
            txtActivationCode.resignFirstResponder()
        }
        return true
    }
    
    /*
     @ The function is set color for all separation view
     @ It is a Default Color
     */
    func DefaultColor () {
        viewTxtEmail.backgroundColor = UIColor.black
        viewTxtActivationCode.backgroundColor = UIColor.black
    }
    
    /*
     @ The Method is called when user going to login button click
     @ it is a Button Action
     */
    @IBAction func btnVerifyAction(_ sender: Any) {
        
        if txtEmail.text!.isEmpty {
            showAlertView(title: "Alert!", msg: "Please Enter a Email id.", controller: self, okClicked: {
            })
            
        }
        else if !MyUtils.validateEmail(enteredEmail: txtEmail.text!){
            showAlertView(title: "Alert!", msg: "Enter valid email address.", controller: self, okClicked: {
            })
        }
        else if txtActivationCode.text!.isEmpty{
            showAlertView(title: "Alert!", msg: "Enter Activation code", controller: self, okClicked: {
            })
        }
        else
        {
    
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


