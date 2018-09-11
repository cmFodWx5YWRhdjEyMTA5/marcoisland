//
//  UITextView+scrolls.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 9/11/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit

extension UITextView {
    
    func scrollToBotom() {
        let range = NSMakeRange(1, text.characters.count - 1);
        scrollRangeToVisible(range);
    }
    
}
