//
//  PaymentMethodCell.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 11/02/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

//1. delegate method
//1. delegate method

class PaymentMethodCell: UITableViewCell {

   
    @IBOutlet weak var imgCardDetail: UIImageView!
    @IBOutlet weak var viewDefault: UIView!

    @IBOutlet weak var lblCardName: UILabel!
    @IBOutlet weak var lblCardNumbers: UILabel!
    @IBOutlet weak var btnMakeCardDefult: customButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgCardDetail.setImgCircle()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    @IBAction func btnMakeDefaultCard(_ sender: customButton) {
    }
}
