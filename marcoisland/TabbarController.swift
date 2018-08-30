//
//  TabbarController.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 7/30/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit

class TabbarController: UITabBarController {
    
    @IBOutlet weak var tabBarVC: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        
        
        
        //**************************************** Increase the Hight of the Tab Bar
        /*var newTabBarFrame = tabBarVC.frame
         let newTabBarHeight: CGFloat = 50
         newTabBarFrame.size.height = newTabBarHeight
         newTabBarFrame.origin.y = self.view.frame.size.height - newTabBarHeight
         
         tabBarVC.frame = newTabBarFrame*/
    }
    func setupTabBarSeparators() {
        let itemWidth = floor(self.tabBarVC.frame.size.width / CGFloat(self.tabBarVC.items!.count))
        
        // Add background color to middle tabBarItem
        let itemIndex = 2
        let bgColor = UIColor.red
        
        let bgView = UIView(frame: CGRect(x: itemWidth *  CGFloat(itemIndex) , y: itemWidth, width: CGFloat(itemWidth), height: self.tabBarVC.frame.size.height+10))
        bgView.backgroundColor = bgColor
        tabBarVC.insertSubview(bgView, at: 0)
        
        
        // this is the separator width.  0.5px matches the line at the top of the tab bar
        let separatorWidth: CGFloat = 0.5
        
        // iterate through the items in the Tab Bar, except the last one
        for i in 0...(self.tabBarVC.items!.count - 1) {
            // make a new separator at the end of each tab bar item
            let separator = UIView(frame: CGRect(x: itemWidth * CGFloat(i + 1) - CGFloat(separatorWidth / 2), y: 0, width: CGFloat(separatorWidth), height: self.tabBarVC.frame.size.height+10))
            
            // set the color to light gray (default line color for tab bar)
            separator.backgroundColor = UIColor.lightGray
            
            self.tabBarVC.addSubview(separator)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
