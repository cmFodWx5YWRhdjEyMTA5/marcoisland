//
//  DiscountViewController.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 9/5/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit
import Alamofire
import SQLite3

class DiscountViewController: UIViewController, UIWebViewDelegate {

    var window: UIWindow?
    var loadingView : UIView?
    @IBOutlet weak var webViewDiscount: UIWebView!
    @IBOutlet weak var lblTitle: UILabel!
    var dbHelper : DBHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        loadingView = MyUtils.customLoader(self.window)
        lblTitle.isHidden = true
        webViewDiscount.isHidden = true
        dbHelper = DBHelper()
        self.retrieveData()
    }

    func retrieveData(){
        if Connectivity.isConnectedToInternet {
            self.view.addSubview(loadingView!)
            let baseURL :String = RestcallManager.sharedInstance.getBaseUrl()
            let strURL : String = baseURL + "discountPageContent"
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
                            let dataArray = try decoder.decode([CmsMaster].self, from: responseData!)
                            DataStore.sharedInstance.addCms(dataArray as NSArray)
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
            commonCMSOnlineOffline()
        }
    }
    
    func populateData(){
        
        let dashboard = DataStore.sharedInstance.getCms()
        let cmsObj: CmsMaster = dashboard[0] as! CmsMaster
        var res :Bool = (dbHelper?.truncateTable(TABLE_NAME: DBHelper.TBL_CMS_MST))!
        let result: Bool = (dbHelper?.insertDataIntoCMSmaster(rowId: 0, post_id: cmsObj.post_id, post_title: cmsObj.post_title, post_content: cmsObj.post_content))!
        if result == true{
            commonCMSOnlineOffline()
        }
    }
    
    func commonCMSOnlineOffline(){
        
        loadingView?.removeFromSuperview()
        
        var db: OpaquePointer?
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(DBHelper.DATABASE_NAME)
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        let queryString = "SELECT * FROM '\(DBHelper.TBL_CMS_MST)'"
        var stmt:OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        var checkInternet = 0
        while(sqlite3_step(stmt) == SQLITE_ROW){
            checkInternet = 1
            lblTitle.text = String(cString: sqlite3_column_text(stmt, 2))
            let myHTML = String(cString: sqlite3_column_text(stmt, 3))
            let myDescriptionHTML = """
            <html> \n\
            <head> \n\
            <style type="text/css"> \n\
            body {font-family: "\("helvetica")"; font-size: \(18);}\n\
            </style> \n\
            </head> \n\
            <body>\(myHTML)</body> \n\
            </html>
            """
            webViewDiscount.loadHTMLString(myDescriptionHTML, baseURL: nil)
        }
        if checkInternet == 0 {
            MyUtils.sharedInstance.showAlertViewDialog(title: "Alert!", msg: "No Internet connection.", controller: self, okClicked: {
            })
        }
        
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        lblTitle.isHidden = false
        webViewDiscount.isHidden = false
        let fontSize = 80
        let jsString = String(format: "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", fontSize )
        webViewDiscount.stringByEvaluatingJavaScript(from: jsString)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
