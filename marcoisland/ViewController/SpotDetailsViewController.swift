//
//  SpotDetailsViewController.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 9/7/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit
import SQLite3

class SpotDetailsViewController: UIViewController {

    var window: UIWindow?
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var topTitle: UILabel!
    @IBOutlet weak var lblDescription: UIWebView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var backgroundScroll: UIScrollView!
    var dashboardID : String?
    var dbHelper : DBHelper?
    var dashObj : DashboardMaster?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        //viewContainer.frame = CGRect(x: 0, y: 0, width: viewContainer.frame.size.width, height: 800)
        //dashObj = DataStore.sharedInstance.getDashboardByID(dashboardID!)
        dbHelper = DBHelper()
        viewContainer.isHidden = true
        
        
        var db: OpaquePointer?
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(DBHelper.DATABASE_NAME)
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        let queryString = "SELECT * FROM '\(DBHelper.TBL_DASHBOARD_MST)' WHERE cms_id = "+dashboardID!
        var stmt:OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        var checkInternet = 0
        while(sqlite3_step(stmt) == SQLITE_ROW){
            checkInternet = 1
            imgBanner.layer.cornerRadius = 10;
            imgBanner.contentMode = .scaleAspectFill
            imgBanner.clipsToBounds = true
            MyUtils.load_image(image_url_string: String(cString: sqlite3_column_text(stmt, 4)), view:imgBanner!)
            lblTitle.text = String(cString: sqlite3_column_text(stmt, 2))
            topTitle.text = String(cString: sqlite3_column_text(stmt, 2))
            //lblDescription.attributedText = String(cString: sqlite3_column_text(stmt, 5)).htmlToAttributedString
            //lblDescription.scrollToBotom()
            var ff = String(cString: sqlite3_column_text(stmt, 5))
            lblDescription.loadHTMLString(String(cString: sqlite3_column_text(stmt, 5)), baseURL: nil)
            backgroundScroll.isUserInteractionEnabled = true
            viewContainer.isUserInteractionEnabled = true
        }
        
        if checkInternet == 0 {
            MyUtils.sharedInstance.showAlertViewDialog(title: "Alert!", msg: "No Internet connection.", controller: self, okClicked: {
            })
        }
        else{
            viewContainer.isHidden = false
        }
        //backgroundScroll.frame = CGRect(x: 0, y: 0, width: viewContainer.frame.size.width, height: 900)
    }

     @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
