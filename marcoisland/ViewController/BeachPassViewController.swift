//
//  BeachPassViewController.swift
//  marcoisland
//
//  Created by Jasimuddin Ansari on 04/09/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit
import Alamofire
import SQLite3

class BeachPassViewController: UIViewController {

    var window: UIWindow?
    @IBOutlet weak var viewRounded: UIView!
    @IBOutlet weak var viewTopProfile: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblValidFrom: UILabel!
    @IBOutlet weak var lblValidTo: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var imgQRCode: UIImageView!
    @IBOutlet weak var imgCheckProfile: UIImageView!
    var dbHelper : DBHelper?
    var loadingView : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        loadingView = MyUtils.customLoader(self.window)
        viewTopProfile.isHidden = true
        imgQRCode.isHidden = true
        dbHelper = DBHelper()
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
            commonProfileOnlineOffline()
        }
    }
    
    func populateData(){
        
        let dashboard = DataStore.sharedInstance.getUser()
        let userObj: UserMaster = dashboard[0] as! UserMaster
        
        var res :Bool = (dbHelper?.truncateTable(TABLE_NAME: DBHelper.TBL_USER_MST))!
        
        for i in 0..<(dashboard.count) {
            let userObj = dashboard[i] as? UserMaster
            let result: Bool = (dbHelper?.insertDataIntoUsermaster(rowId: 0, member_id: (userObj?.id)!, mr_email: (userObj?.mr_email)!, mr_full_name: (userObj?.mr_full_name)!, mr_profile_image: (userObj?.mr_profile_image)!, mr_activation_code: (userObj?.mr_activation_code)!, mr_valid_from: (userObj?.mr_valid_from)!, mr_valid_to: (userObj?.mr_valid_to)!, checkstatus: (userObj?.checkstatus)!))!
            print(result)
        }
        commonProfileOnlineOffline()
    }
    
    func commonProfileOnlineOffline(){
        
        var db: OpaquePointer?
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(DBHelper.DATABASE_NAME)
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        let queryString = "SELECT * FROM '\(DBHelper.TBL_USER_MST)'"
        var stmt:OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        var checkInternet = 0
        while(sqlite3_step(stmt) == SQLITE_ROW){
            checkInternet = 1
            lblUserName.text = String(cString: sqlite3_column_text(stmt, 3))
            lblValidFrom.text = String(cString: sqlite3_column_text(stmt, 6))
            lblValidTo.text = String(cString: sqlite3_column_text(stmt, 7))
            
            imgUser.layer.borderWidth = 3
            imgUser.layer.masksToBounds = false
            imgUser.layer.cornerRadius = imgUser.frame.height/2
            imgUser.clipsToBounds = true
            
            if String(cString: sqlite3_column_text(stmt, 8)) == "n"{
                lblStatus.text = "Inactive"
                imgCheckProfile.image = UIImage(named: "close_sign")
                imgUser.layer.borderColor = MyUtils.colorFromRGBA(fromHex: 0x04b031, alpha: 1).cgColor
            }
            else{
                lblStatus.text = "Active"
                imgCheckProfile.image = UIImage(named: "check_sign")
                imgUser.layer.borderColor = MyUtils.colorFromRGBA(fromHex: 0xfd010c, alpha: 1).cgColor
            }
             MyUtils.load_image(image_url_string: String(cString: sqlite3_column_text(stmt, 4)), view:(imgUser))
            let image = MyUtils.generateQRCode(from: "http://mica.h10testing1.info/member-verification/?mid="+String(cString: sqlite3_column_text(stmt, 1)))
            imgQRCode.image = image
        }
        
        if checkInternet == 0 {
            MyUtils.sharedInstance.showAlertViewDialog(title: "Alert!", msg: "No Internet connection.", controller: self, okClicked: {
            })
        }
        else{
            loadingView?.removeFromSuperview()
            viewTopProfile.isHidden = false
            imgQRCode.isHidden = false
        }
        /*
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
        
        let image = MyUtils.generateQRCode(from: "http://mica.h10testing1.info/member-verification/?mid="+userObj.id!)
        imgQRCode.image = image*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
