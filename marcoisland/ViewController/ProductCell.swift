//
//  ProductCell.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 9/5/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {

    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductDesc: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var btnBuyNow: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnBuyNow.layer.cornerRadius=10
        viewCell.layer.cornerRadius=10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
