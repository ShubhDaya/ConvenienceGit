//
//  KeyConstant.swift
//  Hoggz
//
//  Created by MACBOOK-SHUBHAM V on 27/12/19.
//  Copyright © 2019 MACBOOK-SHUBHAM V. All rights reserved.
//
//
//  KeyConstant.swift
//  Mualab
//
//  Created by MINDIII on 10/16/17.
//  Copyright © 2017 MINDIII. All rights reserved.
//

import Foundation
import UIKit


//let userDefaults =  UserDefaults.standard
let objAppShareData : AppShareData  = AppShareData.sharedObject()

extension UserDefaults {
    
    enum Keys {
        static let strVenderId = "udid"
        static let strAuthToken = "token"
        static let strStep = "next_step"
        static let userInfo = "userInfo"
        static let user_type = "user_type"
        static let UserProfileimg = "profile_picture"
        static let last_name = "last_name"
        static let first_name = "first_name"

       // static let userID = "userID"
        static let email = "email"

    }
}

//extension UserDefaults {
//
//    enum Keys {
//
//    static let user_type = "user_type"
//    static let OwnerProfileImage = "avatar"
//    static let OwnerName = "name"
//    static let userID = "userID"
//
//    }
//}
