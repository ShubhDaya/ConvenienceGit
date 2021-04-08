//
//  LoginViewController.swift
//  Hoggz
//
//  Created by MACBOOK-SHUBHAM V on 30/12/19.
//  Copyright © 2019 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn


class LoginViewController: UIViewController {

    // MARK:  @IBOutlet

    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    
    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
         GIDSignIn.sharedInstance().presentingViewController = self
        // Automatically sign in the user.
         GIDSignIn.sharedInstance()?.restorePreviousSignIn()

         // ..
    }
    
    @IBAction func btnRememberMe(_ sender: Any) {
    }
    
    // MARK:  FaceBook Login Button
    
    @IBAction func faceBookLogin(_ sender: Any) {
      //action of the custom button in the storyboard
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
              // if user cancel the login
              if (result?.isCancelled)!{
                      return
              }
              if(fbloginresult.grantedPermissions.contains("email"))
              {
                print("Succesfull Login")
                self.getFBUserData()
              }
            }
          }
    }
    
    // MARK: Gmail Login Button
    @IBAction func btnGmailSignIN(_ sender: GIDSignInButton!) {
        
        GIDSignIn.sharedInstance()?.signIn()

        
        
    }
    
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {

        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
    }

    
    // MARK: SignUp Button

    @IBAction func btnSignUp(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                  let SignUpWelComeVc = storyBoard.instantiateViewController(withIdentifier: "SignUpWelComeVc") as! SignUpWelComeVc
             self.navigationController?.pushViewController(SignUpWelComeVc, animated: true)
    }
    
    // MARK: Forgot Password Button

    @IBAction func btnForgotPassword(_ sender: Any) {
        
        
                  let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
              let ForgotPasswordVC = storyBoard.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(ForgotPasswordVC, animated: true)
    }
    
  // MARK: Back Button

    @IBAction func backbtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnLogin(_ sender: Any) {
        var email = self.txtEmail.text ?? ""
           var password = self.txtPassword.text ?? ""
        
        let isEmailAddressValid = objValidationManager.validateEmail(with: txtEmail.text ?? "")
        let isPasswordValid = objValidationManager.isValidPassword(testStr: txtPassword.text ?? "")
           
           if txtEmail.text?.isEmpty == true  {
                   objAlert.showAlert(message: "Please Enter Email", title: "Alert", controller: self)
                    } else if txtPassword.text?.isEmpty == true  {
                   objAlert.showAlert(message: "please Enter Password", title: "Alert", controller: self
                       )
                  }else if !isEmailAddressValid  {
            objAlert.showAlert(message: "Please Enter  Valid Email", title: "Alert", controller: self)

           }else if !isPasswordValid{
            objAlert.showAlert(message: "please Enter valid Email", title: "Alert", controller: self
            )
           }
           else {
            
                      let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                  let HomeVC = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.navigationController?.pushViewController(HomeVC, animated: true)
        }
    }
    
    
    // MARK: Get Facebook Data

    func getFBUserData(){
          if((AccessToken.current) != nil){
              GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
            if (error == nil){
              //everything works print the user data
              print(result)
            }
          })
        }
      }
    
    
}



