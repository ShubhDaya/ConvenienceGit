//
//  TanantDetailsCell.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 28/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class TanantDetailsCell: UITableViewCell {

    
    @IBOutlet weak var imgProperty: UIImageView!
    @IBOutlet weak var lblPropertyName: UILabel!
    @IBOutlet weak var lblPropertyAddress: UILabel!
    @IBOutlet weak  var viewNotify: UIView!
    @IBOutlet weak var btnNotify : UIButton!
     
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
         imgProperty.layer.cornerRadius = 5
               imgProperty.clipsToBounds = true
        imgProperty.layer.borderWidth = 0.3
        imgProperty.layer.borderColor = #colorLiteral(red: 0.876841807, green: 0.876841807, blue: 0.876841807, alpha: 1)
        
        
        
        self.viewNotify.layer.cornerRadius = 10
        imgProperty.clipsToBounds = true

        self.viewNotify.layer.borderWidth = 0.5
        self.viewNotify.layer.borderColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
        imgProperty.layer.borderColor = UIColor.lightGray.cgColor


        
        
        // Initialization code
    }
    @IBAction func btnNotify(_ sender: Any) {
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
