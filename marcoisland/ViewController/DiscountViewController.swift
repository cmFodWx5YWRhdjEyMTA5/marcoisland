//
//  DiscountViewController.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 9/5/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit
import Alamofire

class DiscountViewController: UIViewController, UIWebViewDelegate {

    var window: UIWindow?
    var loadingView : UIView?
    @IBOutlet weak var webViewDiscount: UIWebView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        loadingView = MyUtils.customLoader(self.window)
        lblTitle.isHidden = true
        webViewDiscount.isHidden = true
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
            MyUtils.sharedInstance.showAlertViewDialog(title: "Alert!", msg: "No Internet connection.", controller: self, okClicked: {
            })
        }
    }
    
    func populateData(){
        loadingView?.removeFromSuperview()
        let dashboard = DataStore.sharedInstance.getCms()
        let cmsObj: CmsMaster = dashboard[0] as! CmsMaster
        lblTitle.text = cmsObj.post_title
        let myHTML = cmsObj.post_content
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
