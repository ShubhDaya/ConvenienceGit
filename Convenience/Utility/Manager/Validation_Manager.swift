
//  Validation_Manager.swift
//  Hoggz
//  Created by MACBOOK-SHUBHAM V on 27/12/19.
//  Copyright © 2019 MACBOOK-SHUBHAM V. All rights reserved.
//

import Foundation
let objValidationManager = Validation_Manager.sharedObject()

class Validation_Manager {
    
 private static var sharedValidationManager: Validation_Manager = {
  let validation = Validation_Manager()
  return validation
  }()
    
// MARK: - Accessors
    class func sharedObject() -> Validation_Manager {
    return sharedValidationManager
    }
    
//MARK: - Validation Methods
    // Validate email id URL's
    func validateEmail(with Email: String) -> Bool {
    let emailRegex = "^([a-zA-Z0-9_\\-\\.+-]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4})(\\]?)$"
    let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailTest.evaluate(with: Email)
    }
    
    func isValidPassword(testStr:String?) -> Bool {
        guard testStr != nil else { return false }
             let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{6,}")
        return passwordTest.evaluate(with: testStr)
    }

    func ValidPassWord8digit(with Password: String) -> Bool {
      let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
      let paswordtest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
      return paswordtest.evaluate(with: Password)
      }
    
     func validatePassword(password: String) -> Bool {
         //Minimum 8 characters at least 1 Alphabet and 1 Number:
         let passRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,}$"
         let trimmedString = password.trimmingCharacters(in: .whitespaces)
         let validatePassord = NSPredicate(format:"SELF MATCHES %@", passRegEx)
         let isvalidatePass = validatePassord.evaluate(with: trimmedString)
         return isvalidatePass
      }
    
    
    
    func isValidBankAccountNUmber(testStr:String?) -> Bool {
        guard testStr != nil else { return false }
        let accountNumberTest = NSPredicate(format: "SELF MATCHES %@", "[0-9]{16}")
        return accountNumberTest.evaluate(with: testStr)
    }
    
    func isValidCardNUmber(testStr:String?) -> Bool {
        guard testStr != nil else { return false }
        let accountNumberTest = NSPredicate(format: "SELF MATCHES %@", "[0-9]{16}")
        return accountNumberTest.evaluate(with: testStr)
    }

 
    // Validate Name Strings
     func validatecardNameStrings(_ nameString: String) -> Bool {
     let nameRegEx = ".*[^A-Za-z ].*"
     let nameTest = NSPredicate (format:"SELF MATCHES %@",nameRegEx)
     let result = nameTest.evaluate(with: "")
     return result
     }
    
    // Validate Name Strings
    func validateNameStrings(_ nameString: String) -> Bool {
    let nameRegEx = "[a-zA-Z]{3,18}"
    let nameTest = NSPredicate (format:"SELF MATCHES %@",nameRegEx)
    let result = nameTest.evaluate(with: "")
    return result
    }
      
// Valid phone number ----
    func isvalidatePhone(value: String) -> Bool {
        let PHONE_REGEX = "[2356789][0-9]{6}([0-9]{3})?"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
     func isValidBankRautingNumber(testStr:String?) -> Bool {
          guard testStr != nil else { return false }
          let accountNumberTest = NSPredicate(format: "SELF MATCHES %@", "[0-9]{9}")
          return accountNumberTest.evaluate(with: testStr)
      }

    func isValidId(Id: String) -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{2,12}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: Id)
    }

    //Validation for url

    func validateUrl(_ candidate: String) -> Bool {
    // Converted with Swiftify v1.0.6488 - https://objectivec2swift.com/
    if candidate.hasPrefix("http://") {
    return true
    }
    else if candidate.hasPrefix("https://") {
    return true
    }
    else if candidate.hasPrefix("www") {
    return true
    }
    else {
    return false
    }
    }

    //MARK - time format
    func timeFormat(_ time: String) -> String {
    let dateFormatter3 = DateFormatter()
    dateFormatter3.dateStyle = .medium
    dateFormatter3.dateFormat = "HH:mm:ss"
    let date1: Date? = dateFormatter3.date(from: time)
    let formatter = DateFormatter()
    formatter.dateFormat = "hh:mm a"
    let formattedTime: String = formatter.string(from: date1!)
    return formattedTime

    }

    func timeFormat(forAPI date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "hh:mm a"
    let formattedTime: String = formatter.string(from: date)
    return formattedTime
    }

    //MARH - date format
    func dateFormat(_ date: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date1: Date? = dateFormatter.date(from: date)
    let dateFormatter2 = DateFormatter()
    dateFormatter2.dateFormat = "MM/dd/yyyy"
    let formatedDate: String = dateFormatter2.string(from: date1!)
    return formatedDate
    }

    func dateFormat(forAPI date: Date) -> String {
    let dateFormator = DateFormatter()
    dateFormator.dateFormat = "yyyy-MM-dd"
    let formatedDate: String = dateFormator.string(from: date)
    return formatedDate
    }

    func date(withTime date: Date) -> String {
    let dateFormatter3 = DateFormatter()
    dateFormatter3.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let date1: Date? = dateFormatter3.date(from: "\(date)")
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd hh:mm a"
    let formattedTime: String = formatter.string(from: date1!)
    return formattedTime
   }
    
}
