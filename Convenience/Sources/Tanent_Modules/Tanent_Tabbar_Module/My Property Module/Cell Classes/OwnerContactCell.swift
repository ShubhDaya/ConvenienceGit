//
//  OwnerContactCell.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 27/04/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class OwnerContactCell: UITableViewCell {
    @IBOutlet weak var imgMyProperty: UIImageView!
      @IBOutlet weak var lblPropertyAddress: UILabel!
      @IBOutlet weak var lblPropertyName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgMyProperty.setImgeRadius()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
