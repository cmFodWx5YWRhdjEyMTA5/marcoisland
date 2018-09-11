//
//  HomeViewController.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 9/4/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit
import Alamofire
import SQLite3

class HomeViewController: BaseViewController {

    var window: UIWindow?
    @IBOutlet weak var viewProtectingIsland: UIView!
    @IBOutlet weak var imgTopImg: UIImageView!
    var loadingView : UIView?
    var dbHelper : DBHelper?
    @IBOutlet var viewCollectionMenu: Array<UIView>?
    @IBOutlet var viewCollectionTitle:Array<UIView>?
    @IBOutlet var imgCollectionMenu: Array<UIImageView>?
    @IBOutlet var lblCollectionMenu: Array<UILabel>?
    
    @IBOutlet weak var lblScrollingText: UILabel!
    @IBOutlet weak var viewScrollingText: UIView!
    @IBOutlet weak var viewContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        viewProtectingIsland.layer.cornerRadius = 10
        viewProtectingIsland.clipsToBounds = true
        loadingView = MyUtils.customLoader(self.window)
        viewProtectingIsland.isHidden = true
        viewContainer.isHidden = true
        viewScrollingText.isHidden = true
        dbHelper = DBHelper()
        dbHelper?.initializeDatabase()
        self.populateDashboard()
    }

    func populateDashboard(){
        if Connectivity.isConnectedToInternet {
            self.view.addSubview(loadingView!)
            let baseURL :String = RestcallManager.sharedInstance.getBaseUrl()
            let strURL : String = baseURL + "homePage"
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
                            let dataArray = try decoder.decode([DashboardMaster].self, from: responseData!)
                            DataStore.sharedInstance.addDashboard(dataArray as NSArray)
                            self.populateData()
                        } catch {
                            print(error)
                        }
                    }
                    else if webResponse != nil && (webResponse?.StatusCode != "0") && webResponse?.Data != nil {
                        self.showAlertView(title: "Oops!!!", msg: (webResponse?.Data)!, controller: self, okClicked: {
                        })
                    }
                    else{
                        self.showAlertView(title: "Oops!!!", msg: "We are having an issue connecting to server. Please try again after some time.", controller: self, okClicked: {
                        })
                    }
            }
        }
        else{
            commonDashboardOnlineOffline()
            /*showAlertView(title: "Alert!", msg: "No Internet connection.", controller: self, okClicked: {
            })*/
        }
    }
    
    func populateData(){
        
        let dashboard = DataStore.sharedInstance.getDashboard()
       
       var res :Bool = (dbHelper?.truncateTable(TABLE_NAME: DBHelper.TBL_DASHBOARD_MST))!
        
        for i in 0..<(dashboard.count) {
            let dashboardObj = dashboard[i] as? DashboardMaster
            let result: Bool = (dbHelper?.insertDataIntoDashboardmaster(rowId: 0, cms_id: (dashboardObj?.id)!, cms_title: (dashboardObj?.cms_title)!, cms_image_thumb: (dashboardObj?.cms_image_thumb)!, cms_image_large: (dashboardObj?.cms_image_large)!, cms_des: (dashboardObj?.cms_des)!, top_image: (dashboardObj?.top_image)!, scroll_text: (dashboardObj?.scroll_text)!))!
            //print(result)
        }
        
        commonDashboardOnlineOffline()
    }
    
    @objc func handleTap(_ sender: CustomTapGesture) {
        print(sender.dasboardID)
        let viewController = SpotDetailsViewController(nibName: "SpotDetailsViewController", bundle: nil)
        viewController.dashboardID = sender.dasboardID
        self.present(viewController, animated: true, completion: nil)
    }
    
    
    
    func setGradientBackground(titleView:UIView) {
        let colorTop =  UIColor.clear.cgColor
        let colorBottom = UIColor.black.cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = titleView.bounds
        titleView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func commonDashboardOnlineOffline(){
        
        var db: OpaquePointer?
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(DBHelper.DATABASE_NAME)
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        let queryString = "SELECT * FROM '\(DBHelper.TBL_DASHBOARD_MST)' "
        var stmt:OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        var i = 0
        var checkInternet = 0
        while(sqlite3_step(stmt) == SQLITE_ROW){
            checkInternet = 1
            if i == 0{
                /*imgTopImg.contentMode = .scaleAspectFill
                imgTopImg.clipsToBounds = true
                AsyncImageLoader.shared().cancelLoadingImages(forTarget: imgTopImg)
                AsyncImageLoader.shared().cache = nil
                imgTopImg.image = UIImage(named: "loader_thumb_full")
                imgTopImg.imageURL = URL(string: String(cString: sqlite3_column_text(stmt, 6)))*/
                MyUtils.load_image(image_url_string: String(cString: sqlite3_column_text(stmt, 6)), view:(imgTopImg))
                lblScrollingText.text = String(cString: sqlite3_column_text(stmt, 7)).htmlToString
                UIView.animate(withDuration: 12.0, delay: 1, options: ([.curveLinear, .repeat]), animations: {() -> Void in
                    self.lblScrollingText.center = CGPoint(x: 0 - self.lblScrollingText.bounds.size.width / 2, y: self.lblScrollingText.center.y)
                }, completion:  { _ in })
            }else{
                
            }
            viewCollectionMenu?[i].layer.cornerRadius = 10
            viewCollectionMenu?[i].clipsToBounds = true
            setGradientBackground(titleView: viewCollectionTitle![i])
            lblCollectionMenu?[i].text = String(cString: sqlite3_column_text(stmt, 2))
            imgCollectionMenu?[i].contentMode = .scaleAspectFill
            imgCollectionMenu?[i].clipsToBounds = true
            MyUtils.load_image(image_url_string: String(cString: sqlite3_column_text(stmt, 3)), view:(imgCollectionMenu?[i])!)
            let tap = CustomTapGesture(target: self, action: #selector(self.handleTap(_:)))
            tap.dasboardID = String(cString: sqlite3_column_text(stmt, 1))
            viewCollectionMenu?[i].addGestureRecognizer(tap)
            
           i += 1
        }
        
        if checkInternet == 0 {
            showAlertView(title: "Alert!", msg: "No Internet connection.", controller: self, okClicked: {
            })
        }
        else{
            loadingView?.removeFromSuperview()
            viewProtectingIsland.isHidden = false
            viewContainer.isHidden = false
            viewScrollingText.isHidden = false
        }
    
        /*let dashObj: DashboardMaster = dashboard[0] as! DashboardMaster
        
        imgTopImg.contentMode = .scaleAspectFill
        imgTopImg.clipsToBounds = true
        AsyncImageLoader.shared().cancelLoadingImages(forTarget: imgTopImg)
        AsyncImageLoader.shared().cache = nil
        imgTopImg.image = UIImage(named: "profile")
        imgTopImg.imageURL = URL(string: dashObj.top_image!)
        
        for i in 0..<(dashboard.count) {
            let dashObj: DashboardMaster = dashboard[i] as! DashboardMaster
            viewCollectionMenu?[i].layer.cornerRadius = 10
            viewCollectionMenu?[i].clipsToBounds = true
            setGradientBackground(titleView: viewCollectionTitle![i])
            lblCollectionMenu?[i].text = dashObj.cms_title
            imgCollectionMenu?[i].contentMode = .scaleAspectFill
            imgCollectionMenu?[i].clipsToBounds = true
            MyUtils.load_image(image_url_string: dashObj.cms_image_thumb!, view:(imgCollectionMenu?[i])!)
            
            let tap = CustomTapGesture(target: self, action: #selector(self.handleTap(_:)))
            tap.dasboardID = dashObj.id!
            viewCollectionMenu?[i].addGestureRecognizer(tap)
        }*/
        //lblScrollingText.text = dashObj.scroll_text!
        //        UIView.animate(withDuration: 12.0, delay: 1, options: ([.curveLinear, .repeat]), animations: {() -> Void in
        //            self.lblScrollingText.center = CGPoint(x: 0 - self.lblScrollingText.bounds.size.width / 2, y: self.lblScrollingText.center.y)
        //        }, completion:  { _ in })
    }
    
    
    func convertImageToBase64String(urlString: String) -> String {
        // Put Your Image URL
        let url:NSURL = NSURL(string : urlString)!
        // It Will turn Into Data
        let imageData : NSData = NSData.init(contentsOf: url as URL)!
        // Data Will Encode into Base64
        /*let str64 = imageData.base64EncodedData(options: .lineLength64Characters)*/
        // Data Will Encode into Base64 String
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    func convertBase64ToImage(imageString: String) -> UIImage {
        let imageData = Data(base64Encoded: imageString, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        return UIImage(data: imageData)!
    }
}
