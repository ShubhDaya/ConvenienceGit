//
//  SelectedDateHistoryCell.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 01/06/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class SelectedDateHistoryCell: UITableViewCell {

    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblPropertyName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
