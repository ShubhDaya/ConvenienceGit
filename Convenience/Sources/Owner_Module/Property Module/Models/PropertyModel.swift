//
//  PropertyModel.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 30/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import Foundation
class PropertyModel: NSObject {
     var address: String?
     var image: String
    var profile_picture : String = ""
     var name: String?
     var propertyID: Int
     var status: Int?
     var user_id: Int
    var due_date: String?
    var isDue : String = ""
    var is_payable : String = ""
  

    init(dict : [String : Any]) {
           let name = dict["name"] as? String ?? ""
           let image = dict["image"] as? String ?? ""
           let address = dict["address"] as? String ?? ""
           let propertyID = dict["propertyID"] as? Int ?? 0
           let status = dict["status"] as? Int ?? 0
           let user_id = dict["user_id"] as? Int ?? 0
        let duedate = dict["due_date"] as? String ?? ""
        let profilePicture = dict["profile_picture"] as? String ?? ""
        
     
        
        if let isduew = dict["is_due"] as? String{
                   self.isDue = isduew
               }else if let isduew = dict["is_due"] as? Int{
                   self.isDue = String(isduew)
               }
        
        if let ispayable = dict["is_payable"] as? String{
                          self.is_payable = ispayable
                      }else if let ispayable = dict["is_payable"] as? Int{
                          self.is_payable = String(ispayable)
                      }
        
        
           self.name = name
           self.address = address
           self.image = image
           self.propertyID = propertyID
           self.status = status
           self.user_id = user_id
        self.due_date = duedate
        self.profile_picture = profilePicture
        print(duedate)
     }
}



