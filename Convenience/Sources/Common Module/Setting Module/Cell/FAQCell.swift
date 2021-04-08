//
//  FAQCell.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 05/02/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class FAQCell: UITableViewCell {

    
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblAnswer: UILabel!
    @IBOutlet weak var imgColappes: UIImageView!
    @IBOutlet weak var imgExpandes: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func btnExpand(_ sender: Any) {
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
