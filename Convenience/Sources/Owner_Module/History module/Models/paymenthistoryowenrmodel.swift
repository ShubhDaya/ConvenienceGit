//
//  paymenthistoryowenrmodel.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 22/05/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//




import Foundation
import Foundation
//               amount = 5;
//               "created_at" = "2020-05-07 10:40:03";
//               "payment_date" = "2020-05-07";
//               propertyPaymentID = 1;
//               "property_id" = 5;
//               "property_name" = Hotel;
//               status = 2;
class paymenthistoryowenrmodel {
    
    var stramount : String = ""
    var strpropertyPaymentId : String = ""
    var strCreated_at : String = ""
    var strpropertyid: String = ""

    var strpayment_date : String = ""
    var strproperty_name : String = ""
    var strstatus : String = ""
    var strtenantName : String = ""

  

    init(dict : [String:Any]) {
        if let amount = dict["amount"] as? String{
            self.stramount = amount
        }else if let amount = dict["amount"] as? Int{
            self.stramount = String(amount)
        }else if let amount = dict["amount"] as? Float{
            self.stramount = String(amount)
        }else if let amount = dict["amount"] as? Double{
            self.stramount = String(amount)
        }

        if let proPaymentId = dict["propertyPaymentID"] as? String{
            self.strpropertyPaymentId = proPaymentId
        }else if let proPaymentId = dict["propertyPaymentID"] as? Int{
            self.strpropertyPaymentId = String(proPaymentId)
        }
        if let created = dict["created_at"] as? String{
            self.strCreated_at = created
        }
        if let propertyid = dict["property_id"] as? String{
            self.strpropertyid = propertyid
        }
        if let tenantName = dict["tenant_name"] as? String{
                   self.strtenantName = tenantName
               }
        
        if let paymentDate = dict["payment_date"] as? String{
            self.strpayment_date = paymentDate
        }
        
        if let propertyname = dict["property_name"] as? String{
            self.strproperty_name = propertyname
        }
        if let status = dict["status"] as? String{
            self.strstatus = status
        }else if let status = dict["status"] as? Int{
            self.strstatus = String(status)
        }
        
      

    }
    
   
}
