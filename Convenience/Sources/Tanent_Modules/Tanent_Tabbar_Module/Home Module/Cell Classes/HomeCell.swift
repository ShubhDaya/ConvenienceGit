//
//  HomeCell.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 10/02/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {

   
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblaccountDeatail: UILabel!

    @IBOutlet weak var lblTransactionTime: UILabel!
    //@IBOutlet weak var lblStatus: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
