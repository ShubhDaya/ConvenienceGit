//
//  File.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 23/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//


import Foundation


class TenantListModel : NSObject{
    
    
    var user_id : String = ""
    var first_name : String = ""
    var last_name : String = ""
    var full_name : String = ""
    var profile_picture : String = ""
    var isDueStatus : String = ""

     init(dict : [String:Any]) {
        if let userid = dict["user_id"] as? String{
            self.user_id = userid
        }else if let userid = dict["user_id"] as? Int{
            self.user_id = String(userid)
        }
        
        if let FirstName = dict["first_name"] as? String{
            self.first_name = FirstName
        }
        if let LastName = dict["last_name"] as? String{
            self.last_name = LastName
        }
        if let Profileimg = dict["profile_picture"] as? String{
            self.profile_picture = Profileimg
        }
        if let userid = dict["user_id"] as? String{
            self.user_id = userid
        }
        
        if let isduew = dict["is_due"] as? String{
                        self.isDueStatus = isduew
                    }else if let isduew = dict["is_due"] as? Int{
                        self.isDueStatus = String(isduew)
                    }
             
        
    }
    
}
class TenantDetailsModel : NSObject{
    
    
    var propertyName : String = ""
    var propertyAddress : String = ""
    var propertyImage : String = ""
    
     init(propertyName:String,propertyAddress:String,propertyImage:String) {
        self.propertyName = propertyName
        self.propertyAddress = propertyAddress
        self.propertyImage = propertyImage
        
    }
    
}
