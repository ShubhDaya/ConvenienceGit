//
//  ChangePassWordVC.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 04/02/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SVProgressHUD

class ChangePassWordVC: UIViewController,UITextFieldDelegate {
    
    //MARK: Variables-
    
    
    
    //MARK: IBOutlet-
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var txtEnterOldPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtEnterNewPassword: UITextField!
    
    //MARK: AppLifeCycle-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UIViewDesign()
        self.txtEnterNewPassword.delegate = self
        self.txtEnterOldPassword.delegate = self
        self.txtConfirmPassword.delegate = self
        
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: Buttons-
    
    @IBAction func btnChangePassword(_ sender: Any) {
        self.view.endEditing(true)
        
        self.changePassValidation()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.view.endEditing(true)
        
        navigationController?.popViewController(animated: true)
        
    }
    
    //MARK: Local Methods-
    func UIViewDesign(){
        self.view1.setViewRadius()
        self.view1.setshadowView()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.txtEnterOldPassword{
            self.txtEnterOldPassword.resignFirstResponder()
            self.txtEnterNewPassword.becomeFirstResponder()
        }else if textField == self.txtEnterNewPassword{
            self.txtEnterNewPassword.resignFirstResponder()
            self.txtConfirmPassword.becomeFirstResponder()
            
        }
        
        else{
            self.txtConfirmPassword.resignFirstResponder()
        }
        return true
    }
    
}

extension ChangePassWordVC {
    
    func changePassValidation(){
        let strOldPassword = self.txtEnterOldPassword.text?.count ?? 0
        
        let strNewPassword = self.txtEnterNewPassword.text?.count ?? 0
        let strConfirmPassord = self.txtConfirmPassword.text?.count ?? 0
        
        
        self.txtEnterOldPassword.text = self.txtEnterOldPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtEnterNewPassword.text = self.txtEnterNewPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtEnterNewPassword.text = self.txtEnterNewPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let isValidPassword = objValidationManager.ValidPassWord8digit(with: txtEnterNewPassword.text ?? "")
        
        if txtEnterOldPassword.text?.isEmpty == true {
            objAlert.showAlert(message: BlankOldPassword, title: kAlertTitle, controller: self)
        }else if txtEnterNewPassword.text?.isEmpty == true {
            objAlert.showAlert(message: BlankNewPassword, title: kAlertTitle, controller: self)
        }else if strNewPassword < 8 {
            objAlert.showAlert(message: InvalidNewPassword, title: kAlertTitle, controller: self)
        }else if !isValidPassword  {
            objAlert.showAlert(message: InvalidPassword, title: kAlertTitle, controller: self)
        }else if txtConfirmPassword.text?.isEmpty == true {
            objAlert.showAlert(message: BlankconfirmPassword, title: kAlertTitle, controller: self)
        }else if(txtEnterNewPassword.text != self.txtConfirmPassword.text){
            objAlert.showAlert(message: ConfirmPassword, title: kAlertTitle, controller: self)
        }else{
            callWebServiceForChangePassword()
        }
    }
}
extension ChangePassWordVC {
    func  callWebServiceForChangePassword(){
        SVProgressHUD.show()
        self.view.endEditing(true)
        let param = [WsParam.CurrentPassWord:self.txtEnterOldPassword.text ?? "",
                     WsParam.newPassword:self.txtEnterNewPassword.text ?? "",
                     WsParam.confirmPassword:self.txtConfirmPassword.text ?? ""
                     
        ] as [String : Any]
        objWebServiceManager.requestPut(strURL: WsUrl.ChangePasWord, queryParams: [:], params: param, strCustomValidation: "", showIndicator: true, success:{response in
            print(response)
            let status = (response["status"] as? String)
            let message = response["message"] as? String ?? ""
            if status == k_success{
                SVProgressHUD.dismiss()
                
                if (response["data"]as? [String:Any]) != nil{
                    if status == "success" || status == "Success"
                    {
                        //                        objAlert.showAlert(message: message ?? "", title: kAlertTitle, controller: self)
                        self.txtConfirmPassword.text = ""
                        self.txtEnterNewPassword.text = ""
                        self.txtEnterOldPassword.text = ""
                        let refreshAlert = UIAlertController(title: kAlertTitle, message: "Your password has been updated succesfully, your session is expired. please login again.", preferredStyle: UIAlertController.Style.alert)
                        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                            objAppShareData.callWebserviceForLogoutDelete()
                            checkOnboarding = ""
                        }))
                        self.present(refreshAlert, animated: true, completion: nil)
                    }
                }
            }else{
                SVProgressHUD.dismiss()
                if message == "k_sessionExpire"{
                    objAlert.showAlert(message: k_sessionExpire, title: kAlertTitle, controller: self)
                    objAppShareData.resetDefaultsAlluserInfo()
                    objAppDelegate.showLogInNavigation()
                }  else{
                    objAlert.showAlert(message:message, title: kAlertTitle, controller: self)
                }
            }
            
        }, failure: { (error) in
            print(error)
            SVProgressHUD.dismiss()
            objAlert.showAlert(message: kErrorMessage, title: kAlertTitle, controller: self)
        })
    }
}


