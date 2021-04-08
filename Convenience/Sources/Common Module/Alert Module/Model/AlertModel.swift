//
//  Alert.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 03/02/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import Foundation


class AlertModel {
    
    var strNotiFicationDate : String = ""
    var currentDate : Date?
    var notificationDate : Date?
    var relativeTime: String = ""
    var strAlertID : String = ""
    var strbody : String = ""
    var strCreated_at : String = ""
    var strIs_read : String = ""
    var strMeta_data : String = ""
    var strOwner_id : String = ""
    var strParent_id : String = ""
    var strParent_type : String = ""
    var strPropertyID : String = ""
    var strProperty_image : String = ""
    var strProperty_location : String = ""
    var strProperty_name : String = ""
    var strRecipient_name : String = ""
    var strRecipient_user_id : String = ""
    var strReference_id : String = ""
    var strSender_name : String = ""
    var strSender_user_avatar : String = ""
    var strSender_user_id : String = ""
    var strTitle : String = ""
    var strType : String = ""
    var strUpdated_at : String = ""
    var strCurrentTime : String = ""
    var stris_payable : String = ""

    
    
    init(dict : [String:Any]) {
        if let alertid = dict["alertID"] as? String{
            self.strAlertID = alertid
        }else if let alertid = dict["alertID"] as? Int{
            self.strAlertID = String(alertid)
        }
        if let createdid = dict["created_at"] as? String{
            self.strCreated_at = createdid
        }else if let createdid = dict["created_at"] as? Int{
            self.strCreated_at = String(createdid)
        }
        if let isread = dict["is_read"] as? String{
            self.strIs_read = isread
        }else if let isread = dict["is_read"] as? Int{
            self.strIs_read = String(isread)
        }
        if let metadat = dict["meta_data"] as? String{
            self.strMeta_data = metadat
        }else if let metadat = dict["meta_data"] as? Int{
            self.strMeta_data = String(metadat)
        }
        
        if let ispayable = dict["is_payable"] as? String{
            self.stris_payable = ispayable
        }else if let ispayable = dict["is_payable"] as? Int{
            self.stris_payable = String(ispayable)
        }
        
        if let ownerid = dict["owner_id"] as? String{
            self.strOwner_id = ownerid
        }else if let ownerid = dict["owner_id"] as? Int{
            self.strOwner_id = String(ownerid)
        }
        if let parentid = dict["parent_id"] as? String{
            self.strParent_id = parentid
        }else if let parentid = dict["parent_id"] as? Int{
            self.strParent_id = String(parentid)
        }
        
        if let propertyId = dict["propertyID"] as? String{
            self.strPropertyID = propertyId
        }else if let propertyId = dict["propertyID"] as? Int{
            self.strPropertyID = String(propertyId)
        }
        
        if let body = dict["body"] as? String{
            self.strbody = body
        }
        if let parentType = dict["parent_type"] as? String{
            self.strParent_type = parentType
        }
        if let propertyImage = dict["property_image"] as? String{
            self.strProperty_image = propertyImage
        }
        if let propertyLocation = dict["property_location"] as? String{
            self.strProperty_location = propertyLocation
        }
        
        if let propertyname = dict["property_name"] as? String{
            self.strProperty_name = propertyname
        }
        if let recipientname = dict["recipient_name"] as? String{
            self.strRecipient_name = recipientname
        }
        if let reciepientuserId = dict["recipient_user_id"] as? String{
            self.strRecipient_user_id = reciepientuserId
        }else if let reciepientuserId = dict["recipient_user_id"] as? Int{
            self.strRecipient_user_id = String(reciepientuserId)
        }
        
        if let referenceId = dict["reference_id"] as? String{
            self.strReference_id = referenceId
        }
        else if let referenceId = dict["reference_id"] as? Int{
            self.strReference_id = String(referenceId)
        }
        
        if let senderName = dict["sender_name"] as? String{
            self.strSender_name = senderName
        }
        if let senderUserAvatar = dict["sender_user_avatar"] as? String{
            self.strSender_user_avatar = senderUserAvatar
        }
        if let senderuserId = dict["sender_user_id"] as? String{
            self.strSender_user_id = senderuserId
        }
        else if let senderuserId = dict["sender_user_id"] as? Int{
            self.strSender_user_id = String(senderuserId)
        }
        
        if let updateAt = dict["updated_at"] as? String{
            self.strUpdated_at = updateAt
        }
        else if let updateAt = dict["updated_at"] as? Int{
            self.strUpdated_at = String(updateAt)
        }
        
        
        if let title = dict["title"] as? String{
            self.strTitle = title
        }
        if let tyep = dict["type"] as? String{
            self.strType = tyep
        }

    }
    
   
}
