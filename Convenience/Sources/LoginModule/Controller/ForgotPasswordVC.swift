//
//  ForgotViewController.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 09/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import SVProgressHUD

class ForgotPasswordVC: UIViewController,UITextFieldDelegate {
    
    //MARK: Variabels-
    
    
    //MARK:IBOutlet-
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var viewContent: UIView!
    
    
    //MARK: AppLifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtEmail.tag = 0
        self.txtEmail.delegate = self
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UiDesign()
    }
    
    //MARK: Buttons -
    @IBAction func btnback(_ sender: Any) {
        self.view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.tagBasedTextField(textField)
        return true
    }
    
    private func tagBasedTextField(_ textField: UITextField) {
        let nextTextFieldTag = textField.tag + 1
        
        if let nextTextField = textField.superview?.viewWithTag(nextTextFieldTag) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        self.view.endEditing(true)
        // callWebserviceForForgotPassword()
        
        
        let isEmailAddressValid = objValidationManager.validateEmail(with: txtEmail.text ?? "")
        self.txtEmail.text = self.txtEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if txtEmail.text?.isEmpty  == true  {
            objAlert.showAlert(message: BlankEmail, title: kAlertTitle, controller: self)
        }else if !isEmailAddressValid  {
            objAlert.showAlert(message: InvalidEmail, title: kAlertTitle, controller: self)
        }
        else {
            callWebserviceForForgotPassword()
        }
    }
    //MARK: Local Function-
    
    func UiDesign(){
        viewContent.setViewRadius()
        viewContent.setshadowView()
    }
}
extension ForgotPasswordVC {
    func  callWebserviceForForgotPassword(){
        SVProgressHUD.show()
        self.view.endEditing(true)
        let param = [WsParam.email:self.txtEmail.text ?? "",
                     
            ] as [String : Any]
        objWebServiceManager.requestPut(strURL: WsUrl.resetPassword, queryParams: [:], params: param, strCustomValidation: "", showIndicator: true, success:{response in
            print(response)
            let status = (response["status"] as? String)
            let message = (response["message"] as? String)
            if status == k_success{
                SVProgressHUD.dismiss()

                if (response["data"]as? [String:Any]) != nil{
                    if status == "success" || status == "Success"
                    {
                        let dic = response["data"] as? [String:Any]
                        _  = dic!["user_details"] as? [String:Any]
                        //     self.saveDataInDeviceLogin(dict:user_details!)
                        objAlert.showAlert(message: message ?? "", title: kAlertTitle, controller: self)
                        self.txtEmail.text = ""
                    }
                }
            }else{
                SVProgressHUD.dismiss()
                if message == "Inactive user"{
                    //                        objAppShareData.sessionExpireAlertVC(controller: self, alertTitle: kAlertTitle, alertMessage: k_Inactiveuser)
                }else{
                    objAlert.showAlert(message : message ?? "", title: kAlertTitle, controller: self)
                }
            }
        }, failure: { (error) in
            print(error)
            SVProgressHUD.dismiss()
            objAlert.showAlert(message:kErrorMessage, title: "Alert", controller: self)

        })
    }
}


