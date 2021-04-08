//
//  BetterPropertyCell.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 13/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

//1. delegate method

//1. delegate method
protocol MyCellDelegate: AnyObject {
    func btnCloseTapped(cell: BetterPropertyCell)
}

class BetterPropertyCell: UITableViewCell {
    
    @IBOutlet weak var imgPropertyImage: UIImageView!
    @IBOutlet weak var lblPropertyName: UILabel!
    @IBOutlet weak var lblPropertyAddress: UILabel!
    @IBOutlet weak var btnDeleteRow: UIButton!
    @IBOutlet weak var imgDeleteRow: UIImageView!
    
    //weak var delegate: MyCellDelegate?
   //var indexPath:IndexPath!

    var buttonPressed : (() -> ()) = {}

    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgDeleteRow.tintColor = UIColor.blue
        imgPropertyImage.clipsToBounds = true
        imgPropertyImage.layer.cornerRadius = 5
        imgPropertyImage.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
    
    @IBAction func btnDeleteRow(_ sender: UIButton) {
   
    buttonPressed()

    }
    

     
    
//    @IBAction func btnDeleterow(_ sender: UIButton) {
//        let buttonTag =  sender.tag
//
//    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

