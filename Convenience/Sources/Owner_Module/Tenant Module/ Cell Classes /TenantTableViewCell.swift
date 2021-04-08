//
//  TenantTableViewCell.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 20/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class TenantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgTenantList: UIImageView!
    @IBOutlet weak var lblTenantName: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        imgTenantList.layer.cornerRadius = imgTenantList.layer.frame.size.height/2
        imgTenantList.layer.masksToBounds = true
               imgTenantList.layer.borderWidth = 1
               imgTenantList.layer.borderColor = #colorLiteral(red: 0.1140634629, green: 0.2149929786, blue: 0.3579177461, alpha: 1)    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
