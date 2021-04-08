//
//  PaymentHistoryCal_Month_Model.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 26/05/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import Foundation
class PaymentHistoryCal_Month_Model {
    
    var strPropertypaymentId : String = ""
    var DtPaymentDate : Date?
    var strPaymentDate : String = ""


 

    init(dict : [String:Any]) {
        if let ProPaymentId = dict["propertyPaymentID"] as? String{
            self.strPropertypaymentId = ProPaymentId
        }else if let ProPaymentId = dict["propertyPaymentID"] as? Int{
            self.strPropertypaymentId = String(ProPaymentId)
        }
        if let paymnetDate = dict["payment_date"] as? Date{
            self.DtPaymentDate = paymnetDate
        }else if  let paymnetDate = dict["payment_date"] as? Int{
            self.strPaymentDate = String(paymnetDate)
        }else if  let paymnetDate = dict["payment_date"] as? String{
            self.strPaymentDate = paymnetDate
        }
    
    }
 

}
