

//
//  ForgotPasswordVC.swift
//  Hoggz
//
//  Created by MACBOOK-SHUBHAM V on 31/12/19.
//  Copyright © 2019 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    
    
    @IBOutlet weak var lblForgotPassword: UILabel!
    
    @IBOutlet weak var textlbl: UILabel!
    
    @IBOutlet weak var emailnumbertxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backbtn(_ sender: Any) {
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSend(_ sender: Any) {
        
        
        
            var email = self.emailnumbertxt.text ?? ""
               
               let isEmailAddressValid = objValidationManager.validateEmail(with: emailnumbertxt.text ?? "")
//               let isPasswordValid = objValidationManager.isValidPassword(testStr: txtPassword.text ?? "")
                  
                  if emailnumbertxt.text?.isEmpty == true  {
                          objAlert.showAlert(message: "Please Enter Email  ", title: "Alert", controller: self)
                           }
                  else if !isEmailAddressValid  {
                   objAlert.showAlert(message: "Please Enter  Valid Email", title: "Alert", controller: self)

                  }
                  
                  else {
                  let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                       let ResetPasswordVC = storyBoard.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
                               
                                      self.navigationController?.pushViewController(ResetPasswordVC, animated: true)
               
               }
        
       
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
