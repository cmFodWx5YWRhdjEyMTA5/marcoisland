//
//  DiaryViewController.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 9/5/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit

class DiaryViewController: UIViewController, UIWebViewDelegate {

    var window: UIWindow?
    var loadingView : UIView?
    @IBOutlet weak var webViewDiary: UIWebView!
     @IBOutlet weak var lblTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.window = UIWindow(frame: UIScreen.main.bounds)
        loadingView = MyUtils.customLoader(self.window)
        lblTitle.isHidden = true
        webViewDiary.isHidden = true
        let url = URL (string: "http://mica.h10testing1.info/diary.html")
        let requestObj = URLRequest(url: url!)
        webViewDiary.loadRequest(requestObj)
        
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
        self.view.addSubview(loadingView!)
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        lblTitle.isHidden = false
        webViewDiary.isHidden = false
        loadingView?.removeFromSuperview()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        loadingView?.removeFromSuperview()
        MyUtils.sharedInstance.showAlertViewDialog(title: "Oops!!!", msg: "No Internet connection. Please try again.", controller: self, okClicked: {
        })
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
