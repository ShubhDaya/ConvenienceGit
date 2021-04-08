//
//  PendingMonthCell.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 29/04/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class PendingMonthCell: UITableViewCell {

    @IBOutlet weak var imgSelection: customImage!
    @IBOutlet weak var lblPendingMonth: UILabel!
    @IBOutlet weak var btnSelectPenfingminth: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
