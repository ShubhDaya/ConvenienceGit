//
//  webserviceConstants.swift
//  LightGeneration
//  Created by mindiii on 10/30/17.
//  Copyright © 2017 mindiii. All rights reserved.

import Foundation

//http://api.convenienceapp.com:3000 // live new base url

// https://www.convenienceapp.com/  live old base url
let BASE_URL = "http://api.convenienceapp.com:3000" //Live new base url
//let BASE_URL = "https://convenienceco.com" //Live
let PublishKey = "pk_test_51I13GSGHYQNTVGeb6u3eSt5b0pobrPbybE5EjmlD4Og2iHzF3kwZsD17cg14xUTi70Se0X6f7W3k8xTEAWjynqU3008uSCtduk" //dev
let stripeKey = "Bearer sk_test_51I13GSGHYQNTVGebLRS8TYj1WeYeLXTQYl5xwPHv9AUtNywygyPoIuPFA4vQfahG3JHBSzjPWCBfdikmu6arHEig00ahsoO1eq" //dev



//let pkTest =  "pk_live_51I13GSGHYQNTVGebxxIr5TwQcvc60MB8Jb58lJRm0xlHC6Ag87cIL9imTazzmiJqoSv6X0cvohXNe8mzirVL52v300sAPNfJZO" // new for live
// let stripeKey = "Bearer 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"  // new for live

//sk_test_51I13GSGHYQNTVGebLRS8TYj1WeYeLXTQYl5xwPHv9AUtNywygyPoIuPFA4vQfahG3JHBSzjPWCBfdikmu6arHEig00ahsoO1eq


// Api Base url with api name
struct WsUrl {
    static let signup                = BASE_URL + "/api/v1/auth/signup"
    static let login                 = BASE_URL + "/api/v1/auth/login"
    static let logout                = BASE_URL + "/auth/logout"
    static let emailVerified         = BASE_URL + "/auth/check-email-verification"
    static let skip_onboardingsStep  = BASE_URL + "/api/v1/auth/skip-onboarding-step"
    static let resetPassword         = BASE_URL + "/v1/auth/reset-password"
    static let AddProperty           = BASE_URL + "/api/v1/property"
    
    static let SelectOwnerlist       = BASE_URL + "/api/v1/owner/list?"
    static let SelectedPropertyList  = BASE_URL + "/api/v1/owner/"
    static let updateUserLocation    = BASE_URL + "/api/v1/user/location"
    static let GrabPropertyTenant    = BASE_URL + "/api/v1/tenant/grab-property"
    static let addCard               = BASE_URL + "/api/v1/card"
    
    static let PropertyList       = BASE_URL + "/api/v1/property/list?"

    static let PropetyDetails       = BASE_URL + "/api/v1/property/"
    static let PropertyTenantList   = BASE_URL + "/api/v1/property/"
    static let PatchRequestA_C_L    = BASE_URL + "/api/v1/owner/property/"
    static let DueDate              = BASE_URL + "/api/v1/property/"
    static let getOwnertenantlist   = BASE_URL + "/api/v1/owner/"
    static let gettenantProlist     = BASE_URL + "/api/v1/owner/"
    static let leaveproprtyOwner    = BASE_URL + "/api/v1/property/"
    static let cancelRequestTenant  = BASE_URL + "/api/v1/tenant/property/"
    
    static let updateProfile        = BASE_URL + "/api/v1/user/profile"
    // Add Card -
    static let create_Customer        = BASE_URL + "/api/v1/user/stripe-customer"
    static let AddCard        = BASE_URL + "/api/v1/card"
    static let CardList        = BASE_URL + "/api/v1/card/list"
    static let DeleteCard        = BASE_URL + "/api/v1/card/"
    static let MakeCardDefault        = BASE_URL + "/api/v1/card/"

    static let NotificationAlert        = BASE_URL + "/api/v1/alert/push-setting/"
    
    static let ChangePasWord = BASE_URL + "/api/v1/user/change-password"
    static let ALertList = BASE_URL + "/api/v1/alerts?"
    static let OwnerProTenantlist = BASE_URL + "/api/v1/owner/"

    static let accountVerification = BASE_URL + "/api/v1/payment/account-verification/"

    static let addBankAccount = BASE_URL + "/api/v1/payment/bank-account"

    static let checkAccountVerification = BASE_URL + "/api/v1/payment/check-account"
    static let GetMonthList = BASE_URL + "/api/v1/payment/rent-months?propertyId="
    static let PaymentProperty = BASE_URL + "/api/v1/payment/property"
    
    static let GetPaymentHistoryTenant = BASE_URL + "/api/v1/payment/history?"
    
    // Calender payment history -
    static let GetHitoryOfMonthsCalener = BASE_URL + "/api/v1/payment/history?type=calendar&"
    
    // Calender payment Date History -
       static let GetHitoryOfDateType = BASE_URL + "/api/v1/payment/history?type=date&"
    // Owner Side -
    // Tenat transaction history -
    static let GetTenantTransaction = BASE_URL + "/api/v1/tenant/transaction-history?"
    static let ChangeAmountStatus = BASE_URL + "/api/v1/tenant/change-transaction-status"
    static let TenantDueNotify = BASE_URL + "/api/v1/tenant/due-notify"

    static let GetContent = BASE_URL + "/api/v1/user/content"
    
}
//Api Header
struct WsHeader {
    //Login
    static let deviceId   = "Device-Id"
    static let deviceType = "Device-Type"
    static let deviceTimeZone = "Timezone"
    static let ContentType = "Content-Type"
}

//Api parameters
struct WsParam {
    //Signup
    static let first_name = "first_name"
    static let last_name = "last_name"
    static let email = "email"
    static let password = "password"
    static let Confirm_password = "confirm_password"
    static let userID = "userID"
    static let user_type = "user_type"
    static let signup_from = "signup_from"
    static let device_token = "device_token"
    static let profile_timezone = "profile_timezone"
    static let socialId = "social_id"
    static let socialType = "social_type"
    static let profilePic = "profile_picture"
    //change password - 
    static let CurrentPassWord = "currentPassword"
    static let newPassword = "newPassword"
    static let confirmPassword = "confirmPassword"

    
    
    static let account_number = "account_number"
    static let routing_number = "routing_number"
    static let bank_name = "bank_name"
    
    static let propertyname = "name"
    static let propertyAddress = "address"
    static let propertyImage = "image"
    static let Propertylatitude = "latitude"
    static let Propertylongitude = "longitude"
    
    static let term = "term"
    static let offset = "offset"
    static let limit = "limit"
    
    
    static let current_location = "current_location"
    static let current_city = "current_city"
    static let current_state = "current_state"
    static let current_country = "current_country"
    static let current_latitude = "current_latitude"
    static let current_longitude = "current_longitude"
    
    //GrabProperty -
    static let property_id = "property_id"
    static let onboarding = "onboarding"
    //
    static let user = "for"
    // AcceptRequesr Api -n
    static let status = "status"
    
    static let owner_id  = "owner_id"
    static let tenant_id = "tenant_id"
    static let stripeCardId = "stripe_card_id"
    
    // PaymentProperty-
    
    static let cardid = "cardId"
    static let amount  = "amount"
    static let propertyid = "propertyId"
    static let month = "month"
    static let year = "year"
    
     // changeAmountStatus -
    static let UserTenant_id = "tenant_id"
    static let property_rent_id  = "property_rent_id"
    static let PaymentStatus = "status"
    


    //add Card -
//    static let card_holder_name = "property_id"
//    static let card_last_4_digits = "property_id"
//    static let property_id = "property_id"
//    static let property_id = "property_id"
//    static let property_id = "property_id"

}

//Api check for params
struct WsParamsType {
    
    static let PathVariable = "Path Variable"
    static let QueryParams = "Query Params"
    
}
