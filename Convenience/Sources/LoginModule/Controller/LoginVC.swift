//
//  ViewController.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 08/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SVProgressHUD

var PushAlertStatus = 2
var checkOnboarding = ""

class LoginVC: UIViewController,UITextFieldDelegate {
    
    // MARK:  @IBOutlet-
    @IBOutlet weak var imgRememberme: UIImageView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var ContentView: UIView!
    
    //MARK: Variables -
    var ErrorMsg = ""
    var userType = ""
    
    // MARK: AppLifeCycle-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UiDesign()
        self.txtEmail.delegate = self
        self.txtPassword.delegate = self
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        self.isRememberData()

        self.UiDesign()
    }
    
    // MARK: Buttons-
    
    @IBAction func btnForgotPassword(_ sender: Any) {
        self.view.endEditing(true)
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        let ForgotPasswordVC = storyBoard.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(ForgotPasswordVC, animated: true)
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        self.view.endEditing(true)
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        let SignUpVC = storyBoard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(SignUpVC, animated: true)
    }
    
    @IBAction func btnBack(_ sender: Any){
        self.view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        self.view.endEditing(true)
        self.SigninValidation()
    }
    @IBAction func btnRememberMe(_ sender: Any) {
    self.view.endEditing(true)
    let ud = UserDefaults.standard
    let value = ud.value(forKey: UserDefaults.KeysDefault.isRemember) as? String ?? ""

    if value == "true"{
    self.imgRememberme.image = nil
    ud.removeObject(forKey: UserDefaults.KeysDefault.isRemember)
    ud.removeObject(forKey: UserDefaults.KeysDefault.strEmail)
    ud.removeObject(forKey: UserDefaults.KeysDefault.strPassword)
    }else{
    self.imgRememberme.image = #imageLiteral(resourceName: "select_ico")
    ud.set("true", forKey: UserDefaults.KeysDefault.isRemember)
    ud.set(self.txtEmail.text, forKey: UserDefaults.KeysDefault.strEmail)
    ud.set(self.txtPassword.text, forKey: UserDefaults.KeysDefault.strPassword)
    }
    }
    //MARK: Local Function-
    func UiDesign(){
        ContentView.setViewRadius()//radius to view top left and top right
        ContentView.setshadowView()// for only top left and top right shadow in the view
    }
    
    //MARK:TextFiedFunction-
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.txtEmail{
            self.txtEmail.resignFirstResponder()
            self.txtPassword.becomeFirstResponder()
        }else{
            self.txtPassword.resignFirstResponder()
        }
        return true
    }
    
    func isRememberData(){
    let ud = UserDefaults.standard
        print(ud.value(forKey: UserDefaults.KeysDefault.strEmail) ?? "")
        print(ud.value(forKey: UserDefaults.KeysDefault.strPassword) ?? "")
        print(ud.value(forKey: UserDefaults.KeysDefault.isRemember) ?? "")

    self.txtEmail.text = ud.value(forKey: UserDefaults.KeysDefault.strEmail) as? String ?? ""
    self.txtPassword.text = ud.value(forKey: UserDefaults.KeysDefault.strPassword) as? String ?? ""
    let value = ud.value(forKey: UserDefaults.KeysDefault.isRemember) as? String ?? ""
    if value == "true"{
    self.imgRememberme.image = #imageLiteral(resourceName: "select_ico")
    }else{
    self.imgRememberme.image = nil
    }
    }
}


// MARK: Extension --
extension LoginVC {
    // MARK: Func  SigninValidation
    
    func SigninValidation() {
        let strPassword = self.txtPassword.text?.count ?? 0
        let isEmailAddressValid = objValidationManager.validateEmail(with: txtEmail.text ?? "")
        //        let isPasswordValid = objValidationManager.validatePassword(password: txtPassword.text ?? "")
        self.txtEmail.text = self.txtEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtPassword.text = self.txtPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if txtEmail.text?.isEmpty  == true  {
            objAlert.showAlert(message: BlankEmail, title: kAlertTitle, controller: self)
        }else if !isEmailAddressValid  {
            objAlert.showAlert(message:InvalidEmail, title: kAlertTitle, controller: self)
            
        } else if txtPassword.text?.isEmpty == true  {
            objAlert.showAlert(message: BlankPassword, title: kAlertTitle, controller: self
            )
        }
        else if strPassword < 8{
            objAlert.showAlert(message: LengthPassword, title: kAlertTitle, controller: self
            )
        }
        else{
            callWebserviceForLogin()
        }
        
    }
    func saveTanantLoggedState() {
        //  UserDefaults.standard.set(strUsername, forKey: “username”)
        UserDefaults.standard.set(2, forKey: "Key") //Integer
        UserDefaults.standard.synchronize()
        
    }
    func navigateToEmailVC(){
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "EmailVerifyVC") as! EmailVerifyVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateaddBankVC(){
               let storyBoard = UIStoryboard(name: "OwnerTabBar", bundle:nil)
               let vc = storyBoard.instantiateViewController(withIdentifier: "AddBankAccountVC") as! AddBankAccountVC
               vc.isOnboarding = "true"
               self.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToAddPropertyVCTenant(){
        let storyBoard = UIStoryboard(name: "Tanentside", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "GrabBetterPropertyVC") as! GrabBetterPropertyVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToAddCard(){
        let storyBoard = UIStoryboard(name: "Tanentside", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "AddPaymentVC") as! AddPaymentVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToAddPropertyOwner(){
        let storyBoard = UIStoryboard(name: "OwnerTabBar", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "AddPropertyVC") as! AddPropertyVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func saveOwnerLoggedState() {
        //  UserDefaults.standard.set(strUsername, forKey: “username”)
        UserDefaults.standard.set(1, forKey: "Key") //Integer
        UserDefaults.standard.synchronize()
    }
    
    func callWebserviceForLogin(){
        // objWebServiceManager.showIndicator()
        SVProgressHUD.show()
        self.view.endEditing(true)
        let param = [WsParam.email:self.txtEmail.text ?? "",
                     WsParam.password:self.txtPassword.text ?? "",
                     WsParam.device_token:objAppShareData.strFirebaseToken,
                     WsParam.user_type:self.userType
                    ] as [String : Any]
        
        objWebServiceManager.requestPost(strURL: WsUrl.login, queryParams: [:], params: param, strCustomValidation: "", showIndicator: false, success: {response in
            print(response)
            let status = (response["status"] as? String)
            let message = (response["message"] as? String)
            
            
            if status == k_success{
                SVProgressHUD.dismiss()
                
                if (response["data"]as? [String:Any]) != nil{
                    if status == "success" || status == "Success"
                    {
                        let dic = response["data"] as? [String:Any] ?? [:]
                        let user_details  = dic["user_details"] as? [String:Any] ?? [:]
                        let alertStatus = user_details["push_alert_status"] as? Int ?? 2
                        let stralertStatus = user_details["push_alert_status"] as? String ?? ""

                        PushAlertStatus = alertStatus
                    
                        objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details )
                            objAppShareData.fetchUserInfoFromAppshareData()
                   
                        UserDefaults.standard.set(PushAlertStatus, forKey:"PushAlertStatus")
                        
                        UserDefaults.standard.set(objAppSharedata.UserDetail.strUserType, forKey: UserDefaults.KeysDefault.kUserType)
                        UserDefaults.standard.set(objAppSharedata.UserDetail.strAuthToken, forKey: UserDefaults.KeysDefault.kAuthToken)
                        UserDefaults.standard.set(objAppSharedata.UserDetail.strkonboardingstep, forKey: UserDefaults.KeysDefault.konbordingCompled)
                        UserDefaults.standard.set(objAppSharedata.UserDetail.strkonboardingstep, forKey: UserDefaults.KeysDefault.konbordingCompled)
                        
                        UserDefaults.standard.set(objAppShareData.UserDetail.strstripe_customer_id, forKey: UserDefaults.KeysDefault.KStripe_customer_id)
                        print(objAppShareData.UserDetail.strstripe_customer_id)
                        let stripeid = UserDefaults.standard.value(forKey: UserDefaults.KeysDefault.KStripe_customer_id)
                        let alertstatus = UserDefaults.standard.value(forKey: UserDefaults.KeysDefault.kAlertStatus)
                        let ud = UserDefaults.standard
                         let value = ud.value(forKey: UserDefaults.KeysDefault.isRemember) as? String ?? ""

                         if value == "true"{
                          ud.set(self.txtEmail.text, forKey: UserDefaults.KeysDefault.strEmail)
                          ud.set(self.txtPassword.text, forKey: UserDefaults.KeysDefault.strPassword)
                        }
                        if objAppSharedata.UserDetail.strUserType == "tenant"{
                            if objAppShareData.UserDetail.strOnboardingCompled == "1"{
                                checkOnboarding = "false"
                                objAppDelegate.showTenantTabbarNavigation()
                            }else if objAppShareData.UserDetail.strOnboardingCompled == "0"{
                                checkOnboarding = "true"
                                if objAppSharedata.UserDetail.stronboarding_step == "1"{
                                    if objAppShareData.UserDetail.isEmailVerify == "1"{
                                        self.navigateToAddPropertyVCTenant()
                                    }else{
                                        self.navigateToEmailVC()
                                    }
                                }else if objAppSharedata.UserDetail.stronboarding_step == "2"{
                                    self.navigateToAddPropertyVCTenant()
                                }else if objAppSharedata.UserDetail.stronboarding_step == "3"{
                                    self.navigateToAddCard()
                                }else if objAppSharedata.UserDetail.stronboarding_step == "4"{
                                    checkOnboarding = "false"
                                    objAppDelegate.showTenantTabbarNavigation()
                                }
                            }
                        }
                        else if objAppSharedata.UserDetail.strUserType == "owner"{
                            if objAppShareData.UserDetail.strOnboardingCompled == "1"{
                                checkOnboarding = "false"
                                objAppDelegate.showTabbarNavigation()
                            }else if objAppShareData.UserDetail.strOnboardingCompled == "0"{
                                checkOnboarding = "true"
                                if objAppSharedata.UserDetail.stronboarding_step == "1"{
                                    self.navigateToEmailVC()
                                }else if objAppSharedata.UserDetail.stronboarding_step == "2"{
                                    self.navigateaddBankVC()
                                }
                                else if objAppSharedata.UserDetail.stronboarding_step == "3"{
                                    self.navigateToAddPropertyOwner()
                                }else if objAppSharedata.UserDetail.stronboarding_step == "4"{
                                    objAppDelegate.showTabbarNavigation()
                                }
                            }
                        }
                    }
                }
            }else{
                SVProgressHUD.dismiss()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
        }, failure: { (error) in
            print(error)
            SVProgressHUD.dismiss()
            objAlert.showAlert(message:kErrorMessage, title: "Alert", controller: self)

        })
        
    }
    
}

