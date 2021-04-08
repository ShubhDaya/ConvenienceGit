//
//  SignUpVC.swift
//  Hoggz
//
//  Created by MACBOOK-SHUBHAM V on 02/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {

    
    @IBOutlet weak var lblFirstName: UILabel!
    
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var lblConfirmPass: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    
    @IBOutlet weak var txtFistName: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtNumber: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                         let LoginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    self.navigationController?.pushViewController(LoginViewController, animated: true)
        
        
    }
    
    @IBAction func backbtn(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnNext(_ sender: Any) {
        var email = self.txtEmail.text ?? ""
        var password = self.txtPassword.text ?? ""
        var number = self.txtNumber.text ?? ""
              let isEmailAddressValid = objValidationManager.validateEmail(with: txtEmail.text ?? "")
              let isPasswordValid = objValidationManager.isValidPassword(testStr: txtPassword.text ?? "")
        let isnumbervalid = objValidationManager.isvalidatePhone(value: txtNumber.text ?? "")
                 
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
                 }else if !isnumbervalid{
                  objAlert.showAlert(message: "please Enter valid Number", title: "Alert", controller: self
                  )
                 }
                 
                 else {
                  
                  print("Email and Password is valid ")
                  
              
              }
               
        
        
        
    }
    


}
