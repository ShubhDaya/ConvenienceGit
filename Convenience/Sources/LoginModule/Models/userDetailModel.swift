//
//  UserData.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 31/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

class userDetailModel {
    var strAccountVerified : String = ""
    var strAccountId : String = ""
    
    var strstripe_customer_id : String = ""
    var strkonboardingstep   : String = ""
    var strAuthToken          : String = ""
    var strOnboardingCompled  : String = ""
    var strCountyCode          : String = ""
    var strCreateAt            : String = ""
    var strDeviceId            : String = ""
    var strDeviceTimeZone        : String = ""
    var strDeviceType          : String = ""
    var strDeviceToken           : String = ""
    
    var strEmail                : String = ""
    var strFirstName            : String = ""
    var strLastName             : String = ""
    var strPhoneDialCode        : String = ""
    var strPhoneNumber          : String = ""
    var strProfilePicture     : String = ""
    
    var strProfileTimeZone     : String = ""
    var strStatus              : String = ""
    var strUserType             : String = ""
    var strUserName             : String = ""
    var strUserID             : String = ""
    var strStep               : String = ""
    
    var strUserMetaId             : String = ""
    var stronboarding_step        : String = ""
    var strphone_country_code       : String = ""
    var onbording : String = ""
    
    var strAccount_number       : String = ""
    var strBank_name            : String = ""
    var strRouting_number       : String = ""
    var isEmailVerify      : String = ""
    var strpushAlertStatus : String = ""
    
    var strBankname : String = ""
    var strAccountHoldername : String = ""
    var strRoutingNumber : String = ""
    var strAccountNumber : String = ""
    var strBankAccountId : String = ""
    
    
    init(dict : [String:Any]) {
        
        if let firstname = dict["first_name"] as? String{
            self.strFirstName = firstname
        }
        if let onboard = dict["onboarding"] as? String{
            self.onbording = onboard
        }
        if let step = dict["next_step"] as? String{
            self.strStep = step
        }
        
        if let lastname = dict["last_name"] as? String{
            self.strLastName = lastname
        }
        
        if let email = dict["email"] as? String{
            self.strEmail = email
        }
        if let userID = dict["userID"] as? String{
            self.strUserID = userID
        }else{
            let userID = dict["userID"] as? Int
            self.strUserID = String(userID ?? 0)
        }
        
        if let country_code = dict["country_code"] as? String{
            self.strCountyCode = country_code
        }
        
        if let phone_country_code = dict["phone_country_code"] as? String{
            self.strphone_country_code = phone_country_code
        }
        
        if let phone_number = dict["phone_number"] as? String{
            self.strPhoneNumber = phone_number
        }
        
        if let profile_picture = dict["profile_picture"] as? String{
            self.strProfilePicture = profile_picture
        }
        
        if let onboarding_step = dict["onboarding_step"] as? String{
            self.stronboarding_step = onboarding_step
        }else{
            let onboarding_step = dict["onboarding_step"] as? Int
            self.stronboarding_step = String(onboarding_step ?? 0)
        }
        
        if let onboarding_completed = dict["onboarding_completed"] as? String{
            self.strOnboardingCompled = onboarding_completed
        }else{
            let onboarding_completed = dict["onboarding_completed"] as? Int
            self.strOnboardingCompled = String(onboarding_completed ?? 0)
        }
        
        
        
        if let status = dict["status"] as? String{
            self.strStatus = status
        }
        
        if let created_at = dict["created_at"] as? String{
            self.strCreateAt = created_at
        }
        if let device_id = dict["device_id"] as? String{
            self.strDeviceId = device_id
        }
        if let device_timezone = dict["device_timezone"] as? String{
            self.strDeviceTimeZone = device_timezone
        }
        
        if let device_token = dict["device_token"] as? String{
            self.strDeviceToken = device_token
        }
        
        if let device_type = dict["device_type"] as? String{
            self.strDeviceType = device_type
        }
        
        if let auth_token = dict["token"] as? String{
            self.strAuthToken = auth_token
            
        }
        
        if let profile_timezone = dict["profile_timezone"] as? String{
            self.strProfileTimeZone = profile_timezone
        }
        
        
        if let usertype = dict["user_type"] as? String{
            self.strUserType = usertype
        }
        if let acountNumber = dict["Account_number"] as? String{
            self.strAccount_number = acountNumber
        }
        if let bankName = dict["bank_name"] as? String{
            self.strBank_name = bankName
        }
        if let rautingNumber = dict["routing_number"] as? String{
            self.strRouting_number = rautingNumber
        }
        //UserDefaults.standard.setValue(strAuthToken, forKey: UserDefaults.Keys.AuthToken)
        if let email = dict["email_verification_completed"] as? String{
            self.isEmailVerify = email
        }else if let email = dict["email_verification_completed"] as? Int{
            self.isEmailVerify = String(email)
        }
        
        if let stripecustomerid = dict["stripe_customer_id"] as? String{
            self.strstripe_customer_id = stripecustomerid
            print(stripecustomerid)
        }else if let stripecustomerid = dict["stripe_customer_id"] as? Int{
            self.strstripe_customer_id = String(stripecustomerid)
            
        }
        
        if let stripe_connect_account_id = dict["stripe_connect_account_id"] as? String{
            self.strAccountId = stripe_connect_account_id
        }
        
        if let stripe_connect_account_verified = dict["stripe_connect_account_verified"] as? String{
            self.strAccountVerified = stripe_connect_account_verified
        }
        
        if let alertStatus  = dict["push_alert_status"] as? String{
            self.strpushAlertStatus = alertStatus
        }else{
            let alertStatus = dict["push_alert_status"] as? Int
            self.strpushAlertStatus = String(alertStatus ?? 0)
        }
        
    
        //bank detail
        if let dictBankDetail  = dict["bank_account"] as? [String:Any]{
            if let account_holder_name  = dictBankDetail["account_holder_name"] as? String{
                self.strAccountHoldername = account_holder_name
            }
            if let account_number  = dictBankDetail["account_number"] as? String{
                           self.strAccountNumber = account_number
                       }
            if let bank_name  = dictBankDetail["bank_name"] as? String{
                self.strBankname = bank_name
            }
            if let routing_number  = dictBankDetail["routing_number"] as? String{
                self.strRoutingNumber = routing_number
            }
            
            if let bankAccountID  = dictBankDetail["bankAccountID"] as? String{
                self.strBankAccountId = bankAccountID
                
            }else if let bankAccountID  = dictBankDetail["bankAccountID"] as? Int{
                self.strBankAccountId = String(bankAccountID)
            }
        }
    
        
    }
    
}



