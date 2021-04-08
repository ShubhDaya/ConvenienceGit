//
//  AlertCell.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 03/02/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class AlertCell: UITableViewCell {

    @IBOutlet weak var viewImgProperty: UIView!
    @IBOutlet weak var imgOwnerProperty: UIImageView!
    @IBOutlet weak var lblOwnerPropertyName: UILabel!
    @IBOutlet weak var lblOwnerPropertyStatus: UILabel!
    @IBOutlet weak var lblTimeOfStatus: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
     
        self.imgOwnerProperty.setImgCircle()
        self.viewImgProperty.setviewCirclewhite()
        self.viewImgProperty.setshadowViewCircle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

