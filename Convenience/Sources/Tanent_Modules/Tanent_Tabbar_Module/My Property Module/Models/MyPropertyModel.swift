//
//  MyPropertyCell.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 12/02/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import Foundation

class MyPropertyModel : NSObject {
        
        var propertyName : String?
        var propertyAddress : String?
        var propertyImage : String?
        
        init(propertyName:String,propertyAddress:String,propertyImage:String) {
            self.propertyName = propertyName
            self.propertyAddress = propertyAddress
            self.propertyImage = propertyImage
 
    }
}
