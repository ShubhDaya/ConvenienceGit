//
//  PendingMonthCellAlertRedirection.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 02/06/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class PendingMonthCellAlertRedirection: UITableViewCell {

     @IBOutlet weak var lblPendingMonth: UILabel!
     @IBOutlet weak var btnSelectPenfingminth: UIButton!
    @IBOutlet weak var imgSelection: UIImageView!
    override func awakeFromNib() {
         super.awakeFromNib()
         // Initialization code
     }

     override func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)

         // Configure the view for the selected state
     }

}
