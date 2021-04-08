//
//  BankAccountModel.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 12/03/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import Foundation

class BankAccountModel{
    
       var account_number   : String = ""
       var bankAccountID    : String = ""
       var bank_name        : String = ""
       var first_name       : String = ""
       var last_name        : String = ""
       var routing_number   : String = ""
    
    init(dict : [String:Any]) {
        let account_number = dict["account_number"] as? String ?? ""
        let bank_name = dict["bank_name"] as? String ?? ""
        let bankAccountID = dict["bankAccountID"] as?  String ?? ""
        let first_name = dict["first_name"] as? String ?? ""
        let last_name = dict["last_name"] as? String ?? ""
        let routing_number = dict["routing_number"] as? String ?? ""
        
        
        self.account_number = account_number
        self.bankAccountID = bank_name
        self.bank_name = bankAccountID
        self.first_name = first_name
        self.last_name = last_name
        self.routing_number = routing_number
        
    }
    
    
    
    
    
    
}
