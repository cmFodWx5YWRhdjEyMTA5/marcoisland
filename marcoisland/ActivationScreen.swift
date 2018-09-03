//
//  ActivationScreen.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 8/30/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit
import Alamofire
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
            if Connectivity.isConnectedToInternet {
                
                var response : Bool = RestcallManager.sharedInstance.getCmsDetails()
                //print("Jasim")
                let url : String = "http://mica.h10testing1.info/wp-api/discountPageContent"
                Alamofire.request(url)
                    .responseJSON { response in
                        //print(response)
                        // check for errors
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling GET on /todos/1")
                            print(response.result.error!)
                            return
                        }
                        
                        // make sure we got some JSON since that's what we expect
                        guard let json = response.result.value as? [String: Any] else {
                            print("didn't get todo object as JSON from API")
                            if let error = response.result.error {
                                print("Error: \(error)")
                            }
                            return
                        }
                        
                        // get and print the title
                        guard let todoTitle = json["Data"] as? String else {
                            print("Could not get todo title from JSON")
                            return
                        }
                        let data = todoTitle.data(using: .utf8)!
                        let decoder = JSONDecoder()
                        
                        do {
                            let people = try decoder.decode([CmsMaster].self, from: data)
                            let arr: NSMutableArray = []
                            //print(people[0].post_title)
                            for i in 0..<people.count {
                                let fund: CmsMaster = people[i]
                                arr.add(fund)
                            }
                            DataStore.sharedInstance.addCms(arr)
                            
                            let dd = DataStore.sharedInstance.getCms()
                            let product: CmsMaster = dd[0] as! CmsMaster
                            print(product.post_id)
                            
                        } catch {
                            print(error.localizedDescription)
                        }
                        
                        /*let data = todoTitle.data(using: .utf8)!
                         do {
                         if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                         {
                         print(jsonArray[0]["post_id"] as! String)
                         //print(jsonArray)
                         
                         } else {
                         print("bad json")
                         }
                         } catch let error as NSError {
                         print(error)
                         }*/
                }
            }
            else{
                showAlertView(title: "Alert!", msg: "No Internet connection.", controller: self, okClicked: {
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
