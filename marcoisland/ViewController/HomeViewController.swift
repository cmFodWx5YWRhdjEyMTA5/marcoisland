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
        viewProtectingIsland.isHidden = false
        viewContainer.isHidden = false
        viewScrollingText.isHidden = false
        let dashboard = DataStore.sharedInstance.getDashboard()
        let dashObj: DashboardMaster = dashboard[0] as! DashboardMaster
        
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
        }
        //lblScrollingText.text = dashObj.scroll_text!
//        UIView.animate(withDuration: 12.0, delay: 1, options: ([.curveLinear, .repeat]), animations: {() -> Void in
//            self.lblScrollingText.center = CGPoint(x: 0 - self.lblScrollingText.bounds.size.width / 2, y: self.lblScrollingText.center.y)
//        }, completion:  { _ in })

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
