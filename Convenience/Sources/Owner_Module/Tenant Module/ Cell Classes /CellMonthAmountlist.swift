//
//  CellMonthAmountlist.swift
//  Convenience
//
//  Created by Narendra-macbook on 30/04/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class CellMonthAmountlist: UITableViewCell {

    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblAmountDate: UILabel!
    @IBOutlet weak var lblAmountTime: UILabel!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
