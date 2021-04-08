//
//  ConfirmListCell.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 24/03/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class ConfirmListCell: UITableViewCell {

    
    @IBOutlet weak var vwImg: UIView!
    @IBOutlet weak var imgConTenant: UIImageView!
    @IBOutlet weak var lblConTenantName: UILabel!
    @IBOutlet weak var btnLeaveTenant: UIButton!
    @IBOutlet weak var viewbtnAcceptReject: UIView!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnreject: UIButton!
    
    @IBOutlet weak var lblSeparator: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgConTenant.setImageFream()
        self.vwImg.setviewCircle()
        self.vwImg.setshadowViewCircle()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
