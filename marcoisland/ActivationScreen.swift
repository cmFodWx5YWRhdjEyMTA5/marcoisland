//
//  ActivationScreen.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 8/30/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit

class ActivationScreen: UIViewController {

    var window: UIWindow?
    @IBOutlet weak var viewActivation: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtActivationCode: UITextField!
    @IBOutlet weak var btnVerify: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        viewActivation.layer.cornerRadius = 10
        viewActivation.clipsToBounds = true
        btnVerify.layer.cornerRadius = 5
        btnVerify.clipsToBounds = true
        UITextField.appearance().tintColor = UIColor.black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


