//
//  BeachPassViewController.swift
//  marcoisland
//
//  Created by Jasimuddin Ansari on 04/09/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit
import Alamofire

class BeachPassViewController: UIViewController {

    var window: UIWindow?
    @IBOutlet weak var viewRounded: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblValidFrom: UILabel!
    @IBOutlet weak var lblValidTo: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var imgQRCode: UIImageView!
    
    var loadingView : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        imgUser.layer.borderWidth = 3
        imgUser.layer.masksToBounds = false
        imgUser.layer.borderColor = MyUtils.colorFromRGBA(fromHex: 0xFF6F6D, alpha: 1).cgColor
        imgUser.layer.cornerRadius = imgUser.frame.height/2
        imgUser.clipsToBounds = true
        loadingView = MyUtils.customLoader(self.window)
        self.retrieveData()
    }

    func retrieveData(){
        if Connectivity.isConnectedToInternet {
            self.view.addSubview(loadingView!)
            let baseURL :String = RestcallManager.sharedInstance.getBaseUrl()
            let strURL : String = baseURL + "showProfile?member_id="+MyUtils.getUserDefault(key: "memberID")
            Alamofire.request(strURL)
                .responseJSON { response in
                    
                    guard response.result.error == nil else {
                        print(response.result.error!)
                        return
                    }
                    
                    guard let json = response.result.value as? [String: Any] else {
                        print("didn't get todo object as JSON from API")
                        if let error = response.result.error {
                            print("Error: \(error)")
                        }
                        return
                    }
                    
                    var webResponse: WebServiceResponse? = nil
                    webResponse = WebServiceResponse().initWithJsonData(jsonData: json) as? WebServiceResponse
                    if webResponse != nil && (webResponse?.StatusCode == "0") && webResponse?.Data != nil {
                        let responseData = webResponse?.Data.data(using: .utf8)!
                        let decoder = JSONDecoder()
                        
                        do {
                            let dataArray = try decoder.decode([UserMaster].self, from: responseData!)
                            DataStore.sharedInstance.addUser(dataArray as NSArray)
                            self.populateData()
                        } catch {
                            print(error)
                        }
                    }
                    else if webResponse != nil && (webResponse?.StatusCode != "0") && webResponse?.Data != nil {
                        MyUtils.sharedInstance.showAlertViewDialog(title: "Oops!!!", msg: (webResponse?.Data)!, controller: self, okClicked: {
                        })
                    }
                    else{
                        MyUtils.sharedInstance.showAlertViewDialog(title: "Oops!!!", msg: "We are having an issue connecting to server. Please try again after some time.", controller: self, okClicked: {
                        })
                    }
            }
        }
        else{
            MyUtils.sharedInstance.showAlertViewDialog(title: "Alert!", msg: "No Internet connection.", controller: self, okClicked: {
            })
        }
    }
    
    func populateData(){
        loadingView?.removeFromSuperview()
        let dashboard = DataStore.sharedInstance.getUser()
        let userObj: UserMaster = dashboard[0] as! UserMaster
        lblUserName.text = userObj.mr_full_name
        lblValidFrom.text = userObj.mr_valid_from
        lblValidTo.text = userObj.mr_valid_to
        if userObj.checkstatus == "n"{
            lblStatus.text = "Inactive"
        }
        else{
            lblStatus.text = "Active"
        }
        imgUser.contentMode = .scaleAspectFill
        imgUser.clipsToBounds = true
        //cancel loading previous image for cell
        AsyncImageLoader.shared().cancelLoadingImages(forTarget: imgUser)
        AsyncImageLoader.shared().cache = nil
        //set placeholder image or cell won't update when image is loaded
        imgUser.image = UIImage(named: "user")
        //load the image
        imgUser.imageURL = URL(string: userObj.mr_profile_image!)
        
        let image = MyUtils.generateQRCode(from: "Hacking with Swift is the best iOS coding tutorial I've ever read!")
        imgQRCode.image = image
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
