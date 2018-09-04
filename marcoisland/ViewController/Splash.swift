//
//  Splash.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 7/31/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit

class Splash: UIViewController {

    var initialViewController :UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if MyUtils.isKeyPresentInUserDefaults(key: "memberID"){
                let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = mainStoryBoard.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController
                self.present(newViewController, animated: true, completion: nil)
        }
        else{
            let viewController = ActivationScreen(nibName: "ActivationScreen", bundle: nil)
            self.present(viewController, animated: true, completion: nil)
        }
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
