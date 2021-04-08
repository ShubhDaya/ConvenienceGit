//
//  Singltone.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 15/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import Foundation


class AccountManager {
  static let sharedInstance = AccountManager()

  var selectedProperty = [""]
  var isSelected = false
  var isonboarding : Bool = false
  var UserBankDetails = BankAccountModel(dict: [:])


    
    var arrSelected : [String] = []
  // Networking: communicating server
  func network() {
    // get everything
  }

  private init() { }
}
