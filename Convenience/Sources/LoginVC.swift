//
//  ViewController.swift
//  Hoggz
//
//  Created by MACBOOK-SHUBHAM V on 27/12/19.
//  Copyright © 2019 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
//import FBSDKLoginKit
//import FBSDKCoreKit
//import GoogleSignIn

class LoginVC: UIViewController  {
    var dict : [String : AnyObject]!

    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    override func viewDidLoad() {
        
        super.viewDidLoad()
    //    LocationSingleton.sharedInstance.lastLocation

    }
    @IBAction func SignIn(_ sender: Any) {
         let providedEmailAddress = Email.text
        let providedPassWord = password.text
        let providePhone = phoneNumber.text
        
        let isEmailAddressValid = objValidationManager.validateEmail(with: Email.text ?? "")
        let isPasswordValid = objValidationManager.isValidPassword(testStr: password.text ?? "")
        let isvalidNumber = objValidationManager.isvalidatePhone(value: phoneNumber.text ?? "")
        
        if isEmailAddressValid
        {
            print("Email address is valid")
        } else {
            print("Email address is not valid")
        }
        
        if isPasswordValid{
            print("Password is valid ")
        }else{
            print("Password is not valid ")
        }
        
        
        if isvalidNumber{
            print("phone number is valid ")
            
        }else {
            print("Envalid Phone number")
        }
      }
    @IBAction func showAlert(_ sender: Any) {
//    objAlert.showAlertCallBack(title: "Title", message: "Please Fill Deatils", controller: self) {
//            print("lokendra")
//        }
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
   // override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    


