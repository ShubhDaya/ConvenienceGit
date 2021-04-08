//
//  Detailsmodel.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 28/03/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import Foundation
class PropertyDetail: NSObject {
    var name: String = ""
    var address: String = ""
    var due_date: String = ""
    var propertyID: Int
    var property_image: String = ""
    var user_id: Int?
    
    
    var owner_id : String = ""
    var first_name: String = ""
    var last_name: String = ""
    var profile_picture: String = ""
    
    
    init(dict : [String : Any]) {
        let name = dict["name"] as? String ?? ""
        let property_image = dict["property_image"] as? String ?? ""
        let address = dict["address"] as? String ?? ""
        let propertyID = dict["propertyID"] as? Int ?? 0
        let fistname = dict["first_name"] as? String ?? ""
        let last_name = dict["last_name"] as? String ?? ""
        let profile_picture = dict["profile_picture"] as? String ?? ""
        
        if let duedate = dict["due_date"] as? String{
            self.due_date = duedate
        }else if let due_date = dict["due_date"] as? Int{
            self.due_date = "\(due_date)"
        }
        if let ownerid = dict["owner_id"] as? String {
            self.owner_id = ownerid
        }else if let ownerid = dict["owner_id"] as? Int {
            self.owner_id = String(ownerid)
            
        }
        
        self.name = name
        self.address = address
        self.propertyID = propertyID
        self.address = address
        self.property_image = property_image
        self.first_name = fistname
        self.last_name = last_name
        self.profile_picture = profile_picture
        
    }
}



