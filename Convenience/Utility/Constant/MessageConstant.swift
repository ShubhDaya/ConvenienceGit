//
//  MessageConstant.swift
//  Hoggz
//
//  Created by MACBOOK-SHUBHAM V on 27/12/19.
//  Copyright © 2019 MACBOOK-SHUBHAM V. All rights reserved.
//
//
//  MessageConstant.swift
//  Mualab
//
//  Created by MINDIII on 10/16/17.
//  Copyright © 2017 MINDIII. All rights reserved.
//

import Foundation
import UIKit


let k_success = "success"

//pragma mark - Field validation
let BlankName:String = "Please enter your name"
let BlankLastName:String = "Please enter lastname"

let BlankRentAmount:String = "Please enter selected property rent amount"


let BlankFirstName:String = "Please enter firstname"
let BlankUsername: String = "Please enter your Username."
let BlankBankName : String = "Please enter your bank name"
let c: String = "Please select user type."
let BankNameLenght:String = "Bank name must be atleast 4 characters long."
let RoutingNumberCount:String = "Routing number must be atleast 9 digits long."

let BlankAccountNumber:String = "Please enter your account number"
let InvaldAccountNUumber:String = "Please enter valid account number"
let BlankRoutingNumber:String = "Please enter raouting number"
let InvalidRoutingNumber:String = "Please enter valid rauting number"

let BlankCardDetails:String = "Please enter your card details"
let InvaldCardDetails:String = "Please enter valid card details."
let BlankExpiryDate:String = "Please enter expiry date of your card."
let InvalidCVV:String = "Please enter valid cvv of your card."
let BlankCVV:String =  "Please enter cvv of your card."
let BlankNameOnCard = "please enter name of your card"
let NameonCard: String = "Name must be atleast 3 characters long."

let InvalideInformation : String = "Please check that your card information is correct."

//pragma mark -Alert validation
let kAlertMessage: String = "Message"
let kAlertTitle: String = "Alert"
let kErrorMessage: String = "Something went wrong"
let kunderDevelopment :String = "Under Development"
let k_sessionExpire = "Session expired"
let kinvalid : String = "Invalid Payment Information"

//Property Alert Msg

let BlankPropertyName: String = "Please enter property name"
let PropertyNameLenght: String = "Property name  must be atleast 4 characters long."
let BlankPropertyAddress: String = "Please enter property address"
let PropertyAddressLenght:String = "Property address  must be atleast 4 characters long."
let Username: String = "Please enter name."
let UserFirstNamelenght :String = "User first name must be atleast 3 characters long."
let Userlastnamelenght: String = "User last name must be atleast 3 characters long."
let nameLength: String = "Name must be atleast 3 characters long."

let UsernameLength: String = "Username must be atleast 4 characters long."
let CorrectUsername: String = "Username cannot contains whitespace."
let BlankEmail: String = "Please enter email address."
let InvalidEmail: String = "Please enter valid email address."
let BlankPassword: String = "Please enter password."
let BlankOldPassword: String = "Please enter your old password."
let BlankNewPassword: String = "Please enter your new password."
let BlankconfirmPassword: String = "Please Re-enter your password."
let LengthPassword: String = "Please enter password with minimum 8 characters"
let LengthFirst: String = "Maximum length 30 characters."
let LengthLast: String = "Maximum length 30 characters."
let MismatchPassword: String = "Confirm Password should be same as Password."
let InvalidPassword: String = "Please enter valid password"
let InvalidNewPassword : String =  "Please enter password with minimum 8 characters."
let InvalidOldPassword : String =  "Old Password must be atleast 6 characters long."
let BlankHolderName : String = "Please enter account holder name"

let InvalidConfirmPassword: String = "Confirm Password must be atleast 8 characters long."
let ConfirmPassword: String = "Confirm password does not match with new password."
let ConfirmPasswordnotMatch: String = "Confirm password does not match with password."

let InvalidLastName: String = "Please enter valid last name."
let BlankContact: String = "Please enter Contact No."
let CorrectConnectNo: String = "Please enter  Vaild Contact No."
let BlankAddress: String = "Please enter Address."
let InternetConnection: String = "Please check internet connection."
let OTPMsg: String = "OTP is not matched."
let alreadyExistUsername: String = "The username that you've entered is already associated with any Mualab account."
let OTPConfirmMsg: String = "A 4 digit verification code sent to you."
let BlankOTP: String = "Please enter OTP First."
let BlankDOB: String = "Please Select DOB."
let BlankImage: String = "Please Select or take Profile Image."
let BlankGender: String = "Please Select Gender."
let SpicalCharcter: String = "Password should contain at least one special character."
let NoNetwork: String = "No network connection"
let SelectContact: String = "Please select contact."
let development: String = "Coming soon."
let signupfailed: String = "Sign Up Failed."

// logout msg

let logoutAlert:String = "Are you sure you want to logout?"


//Color constant
let colorTheame = UIColor(red: 14.0 / 255.0, green: 123.0 / 255.0, blue: 122.0 / 255.0, alpha: 1.0)
let colorTheameGreeen = UIColor(red: 70.0 / 255.0, green: 170.0 / 255.0, blue: 129.0 / 255.0, alpha: 1.0)
let colorTheameYellow = UIColor(red: 239.0 / 255.0, green: 187.0 / 255.0, blue: 107.0 / 255.0, alpha: 1.0)
let colorTheameRed = UIColor(red: 222.0 / 255.0, green: 113.0 / 255.0, blue: 127.0 / 255.0, alpha: 1.0)


//MARK: - Alerts

func showAlertVC(title:String,message:String,controller:UIViewController) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let subView = alertController.view.subviews.first!
    let alertContentView = subView.subviews.first!
    alertContentView.backgroundColor = UIColor.gray
    alertContentView.layer.cornerRadius = 20
    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(OKAction)
    controller.present(alertController, animated: true, completion: nil)
}

func sessionExpireAlertVC(controller:UIViewController) {
    let alertController = UIAlertController(title: kAlertTitle, message: "Your session is expired , please login again", preferredStyle: .alert)
    let subView = alertController.view.subviews.first!
    let alertContentView = subView.subviews.first!
    alertContentView.backgroundColor = UIColor.gray
    alertContentView.layer.cornerRadius = 20
    let OKAction = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
        //objAppShareData.objAppdelegate.logOut()
    })
    alertController.addAction(OKAction)
    controller.present(alertController, animated: true, completion: nil)
}

func checkForNULL(obj:Any?) -> Any {
    return obj ?? ""
}
