//
//  SpotDetailsViewController.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 9/7/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit

class SpotDetailsViewController: UIViewController {

    var window: UIWindow?
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var backgroundScroll: UIScrollView!
    var dashboardID : String?
    var dashObj : DashboardMaster?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        viewContainer.frame = CGRect(x: 0, y: 0, width: viewContainer.frame.size.width, height: 800)
        dashObj = DataStore.sharedInstance.getDashboardByID(dashboardID!)
        imgBanner.layer.cornerRadius = 10;
        imgBanner.contentMode = .scaleAspectFill
        imgBanner.clipsToBounds = true
        MyUtils.load_image(image_url_string: (dashObj?.cms_image_large)!, view:imgBanner!)
        lblTitle.text = dashObj?.cms_title
        lblDescription.text = dashObj?.cms_des
        backgroundScroll.isUserInteractionEnabled = true
        viewContainer.isUserInteractionEnabled = true
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
