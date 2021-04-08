//
//  PaymentCell.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 10/02/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class PaymentCell: UITableViewCell {

    @IBOutlet weak var imgSelectedCell: UIImageView!
    @IBOutlet weak var imgproperty: UIImageView!
    @IBOutlet weak var lblPropertyName: UILabel!
    @IBOutlet weak var lblPropertyAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgproperty.layer.cornerRadius = 5
               imgproperty.clipsToBounds = true
        imgproperty.layer.borderWidth = 0.3
        imgproperty.layer.borderColor = #colorLiteral(red: 0.876841807, green: 0.876841807, blue: 0.876841807, alpha: 1)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
