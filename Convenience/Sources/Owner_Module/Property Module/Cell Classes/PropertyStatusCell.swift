//
//  PropertyStatusCell.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 29/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class PropertyStatusCell: UITableViewCell {

    @IBOutlet weak var imgProperty: UIImageView!
    @IBOutlet weak var lblPropertyName: UILabel!
    @IBOutlet weak var lblPropertyAddress: UILabel!
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
               imgProperty.layer.cornerRadius = 5
                imgProperty.clipsToBounds = true
               imgProperty.layer.borderWidth = 0.3
               imgProperty.layer.borderColor = #colorLiteral(red: 0.876841807, green: 0.876841807, blue: 0.876841807, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
