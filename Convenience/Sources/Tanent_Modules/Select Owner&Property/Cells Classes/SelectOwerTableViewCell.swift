//
//  SelectOwerTableViewCell.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 13/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
class SelectOwerTableViewCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
   @IBOutlet weak var imgOwnerImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgOwnerImage.layer.cornerRadius = imgOwnerImage.layer.frame.size.height/2
        imgOwnerImage.layer.masksToBounds = true
               imgOwnerImage.layer.borderWidth = 1
               imgOwnerImage.layer.borderColor = #colorLiteral(red: 0.1140634629, green: 0.2149929786, blue: 0.3579177461, alpha: 1)
               
               imgOwnerImage.layer.shadowPath = UIBezierPath(rect: imgOwnerImage.bounds).cgPath
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
