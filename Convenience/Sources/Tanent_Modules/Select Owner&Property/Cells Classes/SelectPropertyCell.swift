//
//  SelectPropertyCell.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 13/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class SelectPropertyCell: UITableViewCell {

    @IBOutlet weak var imgPropertyImage: UIImageView!
    @IBOutlet weak var lblPropertyName: UILabel!
    @IBOutlet weak var lblPropertyAddress: UILabel!
   @IBOutlet weak var imgPropertySelection: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgPropertyImage.clipsToBounds = true
                  imgPropertyImage.layer.cornerRadius = 5
        imgPropertyImage.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        
//
//        imgPropertyImage.layer.cornerRadius = imgPropertyImage.layer.frame.size.height/2
//               imgPropertyImage.layer.masksToBounds = true
//                      imgPropertyImage.layer.borderWidth = 1
//                      imgPropertyImage.layer.borderColor = #colorLiteral(red: 0.1140634629, green: 0.2149929786, blue: 0.3579177461, alpha: 1)
//
//                      imgPropertyImage.layer.shadowPath = UIBezierPath(rect: imgPropertyImage.bounds).cgPath
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    

}
