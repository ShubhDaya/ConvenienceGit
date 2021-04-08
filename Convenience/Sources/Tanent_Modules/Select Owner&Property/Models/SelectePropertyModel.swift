//
//  SelectePropertyModel.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 06/02/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import Foundation
class SelectePropertyModel: NSObject {
    
     var PropertyName: String?
     var PropertyImage: String?
     var PropertyAddress: String?
     var isSelected: Bool

    init(PropertyName:String,PropertyImage:String,PropertyAddress:String,isSelected:Bool) {
         self.PropertyName = PropertyName
         self.PropertyImage = PropertyImage
         self.PropertyAddress = PropertyAddress
        self.isSelected = isSelected
     }
}

