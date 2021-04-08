//
//  PendingListCell.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 24/03/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class PendingListCell: UITableViewCell {

   
    @IBOutlet weak var lblSeparator: UILabel!
    @IBOutlet weak var vwPending: UIView!
    @IBOutlet weak var imgPendingTenant: UIImageView!
    @IBOutlet weak var lblPendingTenantName: UILabel!
    @IBOutlet weak var btnAcceptRequest: UIButton!
    @IBOutlet weak var btncancelRequest: UIButton!

    @IBAction func btnAcceptRequest(_ sender: Any) {
        
    }
  @IBAction func btnCancelRequest(_ sender: Any) {
    
  }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgPendingTenant.setImageFream()
               self.vwPending.setviewCircle()
               self.vwPending.setshadowViewCircle()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
