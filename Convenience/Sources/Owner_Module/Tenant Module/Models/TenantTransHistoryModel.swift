//
//  TenantTransHistoryModel.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 29/05/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import Foundation
class TenantTransHistoryModel : NSObject{
   
    var strbyUserId : String = ""
    var strForuserId : String = ""
    var strMonth : String = ""
    var strMonthLabel : String = ""
    var strPropertyRentId : String = ""
    var strPropertyId : String = ""
    var strStatus : String = ""
    var arrtrancation = [trnacationModel]()

    
    
    init(dict : [String:Any]) {
        if let byuserid = dict["by_user_id"] as? String{
            self.strbyUserId = byuserid
        }else if let byuserid = dict["by_user_id"] as? Int{
            self.strbyUserId = String(byuserid)
        }
        
        if let foruserid = dict["for_user_id"] as? String{
                  self.strForuserId = foruserid
              }else if let foruserid = dict["for_user_id"] as? Int{
                  self.strForuserId = String(foruserid)
              }
        if let month = dict["month"] as? String{
                  self.strMonth = month
              }else if let month = dict["month"] as? Int{
                  self.strMonth = String(month)
              }
        if let monthLabel = dict["month_label"] as? String{
                  self.strMonthLabel = monthLabel
              }else if let monthLabel = dict["month_label"] as? Int{
                  self.strMonthLabel = String(monthLabel)
              }
        
        if let propertyRentID = dict["propertyRentID"] as? String{
                  self.strPropertyRentId = propertyRentID
              }else if let propertyRentID = dict["propertyRentID"] as? Int{
                  self.strPropertyRentId = String(propertyRentID)
              }
        
        if let propertyid = dict["property_id"] as? String{
                         self.strPropertyId = propertyid
                     }else if let propertyid = dict["property_id"] as? Int{
                         self.strPropertyId = String(propertyid)
                     }
        if let status = dict["status"] as? String{
            self.strStatus = status
        }else if let status = dict["status"] as? Int{
            self.strStatus = String(status)
        }
    
      if let arrReqData1 = dict["transactions"] as? [Any]{
          for dictGetData1 in arrReqData1
          {
              let obj = trnacationModel.init(dict: dictGetData1 as! Dictionary<String, Any>)
              self.arrtrancation.append(obj)
            //  self.arrtrancation.append(obj)
            //self.arrtrancation.append(obj)
            //self.arrtrancation.append(obj)

            
          }
        print(" array trancation amount - \(arrtrancation.count)")
      }else{
          arrtrancation = [trnacationModel]()
      }
      

    }
    
}


