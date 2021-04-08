//
//  transationModel.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 29/05/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import Foundation
import UIKit

class trnacationModel: NSObject {
    
    var stramount : String = ""
     var strCreated_at : String = ""
     var strpropertyPaymentId : String = ""
     var strPropertyRentId2 : String = ""
     var strStatus1 : String = ""
    var isDueStatus : String = ""
    
    init(dict:Dictionary<String, Any>) {
        
      if let amount = dict["amount"] as? String{
                  self.stramount = amount
              }else if let amount = dict["amount"] as? Int{
                  self.stramount = String(amount)
              }else if let amount = dict["amount"] as? Double{
                  self.stramount = String(amount)
              }
        if let created_at = dict["created_at"] as? String{
                  self.strCreated_at = created_at
              }else if let created_at = dict["created_at"] as? Int{
                  self.strCreated_at = String(created_at)
              }
        if let propertypaymentId = dict["propertyPaymentID"] as? String{
                  self.strpropertyPaymentId = propertypaymentId
              }else if let propertypaymentId = dict["propertyPaymentID"] as? Int{
                  self.strpropertyPaymentId = String(propertypaymentId)
              }
        
        if let propertyrentId = dict["property_rent_id"] as? String{
                  self.strPropertyRentId2 = propertyrentId
              }else if let propertyrentId = dict["property_rent_id"] as? Int{
                  self.strPropertyRentId2 = String(propertyrentId)
              }
        
        if let status = dict["status"] as? String{
                         self.strStatus1 = status
                     }else if let status = dict["status"] as? Int{
                         self.strStatus1 = String(status)
                     }
        
        if let isduew = dict["is_due"] as? String{
                              self.isDueStatus = isduew
                          }else if let isduew = dict["is_due"] as? Int{
                              self.isDueStatus = String(isduew)
                          }

    }
    
    
}
