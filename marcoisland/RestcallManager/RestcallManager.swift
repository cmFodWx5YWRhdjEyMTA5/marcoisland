//
//  RestcallManager.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 8/31/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit
import Alamofire

class RestcallManager: NSObject {
    static let sharedInstance = RestcallManager()
    
    func getBaseUrl() -> String {
        return "https://mica2.wpengine.com/wp-api/"
    }
    
    //pragma mark restcall Methods
    
    func getCallWithUrl(FeedUrl: String) -> WebServiceResponse {
        var webresponse: WebServiceResponse? = nil
        if Connectivity.isConnectedToInternet{
            let url : String = FeedUrl
            
            Alamofire.request(url)
                .responseJSON { response in
                    // check for errors
                    guard response.result.error == nil else {
                        // got an error in getting the data, need to handle it
                        print("error calling GET on /todos/1")
                        print(response.result.error!)
                        return
                    }
                    // make sure we got some JSON since that's what we expect
                    guard let json = response.result.value as? [String: Any] else {
                        print("didn't get todo object as JSON from API")
                        if let error = response.result.error {
                            print("Error: \(error)")
                        }
                        return
                    }
                    webresponse = WebServiceResponse().initWithJsonData(jsonData: json) as? WebServiceResponse
            }
        }
        else{
            webresponse = WebServiceResponse()
            webresponse?.Data = "Connect to the Internet to use GoEva";
            webresponse?.StatusCode="-200";
        }
        return webresponse!
    }
    
    func getCmsDetails() -> Bool {
        let baseURL :String = RestcallManager.sharedInstance.getBaseUrl()
        let strURL : String = "\(baseURL)discountPageContent"
        //var url : String = baseURL+"discountPageContent"
        let webResponse: WebServiceResponse? = getCallWithUrl(FeedUrl: strURL)
        if webResponse != nil && (webResponse?.StatusCode == "0") && webResponse?.Data != nil {
            let data = webResponse?.Data.data(using: .utf8)!
        }
        else if webResponse != nil && (webResponse?.StatusCode != "0") && webResponse?.Data != nil {
            GlobalVariable.setGlobalMessage(message: "We are having an issue connecting to server. Please try again after some time.")
        }
        return false
    }
    
}
