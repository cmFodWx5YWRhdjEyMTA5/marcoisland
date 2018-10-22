//
//  AppDelegate.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 7/30/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate  {

    var window: UIWindow?
    var initialViewController :UIViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //TODO: - Enter your credentials
        /*PayPalMobile .initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: "YOUR_CLIENT_ID_FOR_PRODUCTION",
                                                                PayPalEnvironmentSandbox: "AZz0FFGGBbu9Fe5DAsLzP5AW1Tymuht_2egG4QfwbAy4rJ2vxvrxgY8_jzzBQNqYf-vUu8V1LfLIgnWx"])*/
        
        /*PayPalMobile .initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: "",
                                                                PayPalEnvironmentSandbox: "AamAMLBqL-xfxNkoMBfdp82j9T20N34f-4yBrMXGmnsHryDWpwtWsakpe0ceh5OATbqJjFuq0C_1L0I6"])*/
        
        PayPalMobile .initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: "AeZx_PZFoz8nVmMrih7mhclYQksPP6xHKbyGkM0Y7uAAhwhwZ_jXpakx_MwoIb60BIX5nqVEocOGJMWN",
        PayPalEnvironmentSandbox: ""])
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in
                // Enable or disable features based on authorization.
            }
        }
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        UIApplication.shared.registerForRemoteNotifications()
        
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
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        GlobalVariable.setDeviceToken(message: token)
        //print(token)
    }
    
    //Called if unable to register for APNS.
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //print("APNs registration failed: \(error)")
    }

    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //print("Recived: \(userInfo)")
        //Parsing userinfo:
        /*if let info = userInfo["aps"] as? Dictionary<String, AnyObject>
        {
            let alertMsg = info["alert"] as! String
            let alertController = UIAlertController(title: "Message!!!", message: alertMsg, preferredStyle: UIAlertControllerStyle.alert)
            let actionOk = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
                print("You've pressed Ok");
            }
            alertController.addAction(actionOk)
            self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }*/
        
        
        if let info = userInfo["aps"] as? Dictionary<String, AnyObject>
        {
            var topWindow: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
            topWindow?.rootViewController = UIViewController()
            topWindow?.windowLevel = UIWindowLevelAlert + 1
            let alertMsg = info["alert"] as! String
            let alert = UIAlertController(title: "Message!!!", message: alertMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "confirm"), style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            topWindow?.isHidden = true
            topWindow = nil
        }))
        topWindow?.makeKeyAndVisible()
        topWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
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

