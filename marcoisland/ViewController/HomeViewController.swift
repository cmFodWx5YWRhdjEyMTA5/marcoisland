//
//  HomeViewController.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 9/4/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: BaseViewController {

    var window: UIWindow?
    @IBOutlet weak var viewProtectingIsland: UIView!
    @IBOutlet weak var imgTopImg: UIImageView!
    var loadingView : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        viewProtectingIsland.layer.cornerRadius = 10
        viewProtectingIsland.clipsToBounds = true
        loadingView = MyUtils.customLoader(self.window)
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
            showAlertView(title: "Alert!", msg: "No Internet connection.", controller: self, okClicked: {
            })
        }
    }
    
    func populateData(){
        loadingView?.removeFromSuperview()
        let dashboard = DataStore.sharedInstance.getDashboard()
        let dashObj: DashboardMaster = dashboard[0] as! DashboardMaster
        
        imgTopImg.contentMode = .scaleAspectFill
        imgTopImg.clipsToBounds = true
        //cancel loading previous image for cell
        AsyncImageLoader.shared().cancelLoadingImages(forTarget: imgTopImg)
        AsyncImageLoader.shared().cache = nil
        //set placeholder image or cell won't update when image is loaded
        imgTopImg.image = UIImage(named: "profile")
        //load the image
        imgTopImg.imageURL = URL(string: dashObj.top_image!)
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
