//
//  Connectivity.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 9/3/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
