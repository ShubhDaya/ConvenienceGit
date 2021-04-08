//
//  OwnerModel.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 20/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import Foundation


class OwnerModel: NSObject {
    
    var currentLocation: String?
    var profileimg: String?
    var firstName : String?
    var lastName : String?
    var owner_id : Int?
    var email : String?
    
    init(dict : [String : Any]) {
        let current_location = dict["current_location"] as? String ?? ""
        let email = dict["email"] as? String ?? ""
        let first_name = dict["first_name"] as? String ?? ""
        let last_name = dict["last_name"] as? String ?? ""
        let profile_picture = dict["profile_picture"] as? String ?? ""
        let owner_id = dict["owner_id"] as? Int ?? 0

        self.currentLocation = current_location
        self.email = email
        self.firstName = first_name
        self.lastName = last_name
        self.profileimg = profile_picture
        self.owner_id = owner_id

    }
}

class PropertyTenantModel: NSObject {
    
    var user_id: Int?
    var property_id: Int?
    var status : Int?
    var first_name : String?
    var last_name : String?
    var profile_picture : String?
    
    init(dict : [String : Any]) {
        let userid = dict["user_id"] as? Int ?? 0
        let propertyid  = dict["property_id"] as? Int ?? 0
        let status = dict["status"] as? Int ?? 0
        let first_name = dict["first_name"] as? String ?? ""
        let last_name = dict["last_name"] as? String ?? ""
        let profile_picture = dict["profile_picture"] as? String ?? ""

        self.user_id = userid
        self.property_id = propertyid
        self.status = status
        self.first_name = first_name
        self.last_name = last_name
        self.profile_picture = profile_picture

    }
}
