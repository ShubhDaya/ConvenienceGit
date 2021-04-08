//
//  PaymentMethodModel.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 11/02/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import Foundation
class CardListModel: NSObject {
    var strcardID: String = ""
    var strCard_brand_type: String = ""
    var strCard_expiry_month: String = ""
    var strCard_expiry_year: String = ""
    var strCard_holder_name: String = ""
    var strCard_last_4_digits: String = ""
    var strIs_default: String = ""
    var strStatus: String = ""
    var strStripe_card_id: String = ""
    var strUser_id: String = ""
    
    
    init(dict : [String:Any]) {
        
        if let cardHolderName = dict["card_holder_name"] as? String{
            self.strCard_holder_name = cardHolderName
        }
        if let status = dict["status"] as? Int{
            self.strStatus = String(status)
        }
        if let cardbrandtype = dict["card_brand_type"] as? String{
            self.strCard_brand_type = cardbrandtype
        }
        if let userid = dict["user_id"] as? String{
            self.strUser_id = userid
        }
        
        if let card = dict["cardID"] as? String{
            self.strcardID = card
        }else if let card = dict["cardID"] as? Int{
            self.strcardID = String(card)
            
        }
        if let cardexpirymonth = dict["card_expiry_month"] as? String{
            self.strcardID = cardexpirymonth
        }else if let cardexpirymonth = dict["card_expiry_month"] as? Int{
            self.strCard_expiry_month = String(cardexpirymonth)
        }
        if let cardexpiryYear = dict["card_expiry_year"] as? String{
            self.strCard_expiry_year = cardexpiryYear
        }else if let cardexpiryYear = dict["card_expiry_year"] as? Int{
            self.strCard_expiry_year = String(cardexpiryYear)
        }
        
        if let card4digit = dict["card_last_4_digits"] as? String{
            self.strCard_last_4_digits = card4digit
        }else if let card4digit = dict["card_last_4_digits"] as? Int{
            self.strCard_last_4_digits = String(card4digit)
        }
        
        if let isdefault = dict["is_default"] as? String{
            self.strIs_default = isdefault
        }else if let isdefault = dict["is_default"] as? Int{
            self.strIs_default = String(isdefault)
        }
        
        if let stripeCardId = dict["stripe_card_id"] as? String{
            self.strStripe_card_id = stripeCardId
        }else if let stripeCardId = dict["stripe_card_id"] as? Int{
            self.strStripe_card_id = String(stripeCardId)
            
        }
    }
}
