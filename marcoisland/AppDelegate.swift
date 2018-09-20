//
//  AppDelegate.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 7/30/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var initialViewController :UIViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //TODO: - Enter your credentials
        /*PayPalMobile .initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: "YOUR_CLIENT_ID_FOR_PRODUCTION",
                                                                PayPalEnvironmentSandbox: "AZz0FFGGBbu9Fe5DAsLzP5AW1Tymuht_2egG4QfwbAy4rJ2vxvrxgY8_jzzBQNqYf-vUu8V1LfLIgnWx"])*/
        
        PayPalMobile .initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: "",
                                                                PayPalEnvironmentSandbox: "AamAMLBqL-xfxNkoMBfdp82j9T20N34f-4yBrMXGmnsHryDWpwtWsakpe0ceh5OATbqJjFuq0C_1L0I6"])
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        //        let vc = Splash()
        //        let navigationController = UINavigationController(rootViewController: vc)
        //        self.window?.rootViewController = navigationController
        //        self.window?.makeKeyAndVisible()
        //        navigationController.setNavigationBarHidden(true, animated: false)
        
        initialViewController  = Splash(nibName:"Splash",bundle:nil)
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

