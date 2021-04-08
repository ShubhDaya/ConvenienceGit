//
//  MyPropertyCell.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 10/02/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class MyPropertyCell: UITableViewCell {

    @IBOutlet weak var imgMyProperty: UIImageView!
    @IBOutlet weak var lblPropertyAddress: UILabel!
    @IBOutlet weak var lblPropertyName: UILabel!
    @IBOutlet weak var btnProCancel: customButton!
    @IBOutlet weak var btnLeave: customButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgMyProperty.setImgeRadius()
    }

  
    
    
    @IBAction func btnProCancel(_ sender: UIButton) {
   
    
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
