//
//  AddBankAccountVC.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 11/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import SVProgressHUD
import WebKit

class AddBankAccountVC: UIViewController {
    
    //MARK: Variable -
    var maxLength : Int = 0
    
    //MARK:IBOutlet-
    @IBOutlet weak var viewVerificationAlert: UIView!
    @IBOutlet weak var viewVerification: UIView!
    @IBOutlet weak var wkWebView: WKWebView!
    
    @IBOutlet weak var viewWebViewRadius: UIView!
    @IBOutlet weak var viewContentView: UIView!
    @IBOutlet weak var imgBankLogo: UIImageView!
    @IBOutlet weak var txtBankName: UITextField!
    @IBOutlet weak var txtAccountHolderName: UITextField!
    @IBOutlet weak var txtAccountNumber: UITextField!
    @IBOutlet weak var txtRaoutingNUmber: UITextField!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnCompleteVerification: UIButton!
    @IBOutlet weak var viewBtnback: UIView!
    @IBOutlet weak var lblTitleHeader: UILabel!
    
    
    
    var strVerifiedAccount = "0"
    var isOnboarding = "false"
    var AccountVerification = ""
    var BankAccountAdded = ""
    var returnFromeWebview = ""
    
    var strBankName = ""
    var strAccountHoldername = ""
    var strAccountNumber = ""
    var strRoutingNumber = ""
    var strAccountId = ""
    var strVerificationLink = ""
    
    
    //MARK:AppLifeCycle-
    override func viewDidLoad() {
        super.viewDidLoad()
        onboarding()
        self.viewVerification.isHidden = true
        self.viewVerificationAlert.isHidden = true
        self.txtBankName.delegate = self
        self.txtAccountNumber.delegate = self
        self.txtRaoutingNUmber.delegate = self
        DesignUI()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.call_WebserviceForCheckVerification()
        
        if isOnboarding == "true" {
            
            self.btnCompleteVerification.isHidden = true
        }else{
            btnCompleteVerification.isHidden = false
        }
        
        //  onboarding()
    }
    
    //MARK: Local Function-
    func DesignUI() {
        viewContentView.setViewRadius()
        viewContentView.setshadowView()
        viewWebViewRadius.setViewRadius()
        viewWebViewRadius.setshadowView()
        
        
    }
    
    //MARK:Buttons
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCompleteVerification(_ sender: Any) {
          self.viewVerificationAlert.isHidden = false
    }
    
    
    @IBAction func btnCancelVerification(_ sender: Any) {
        self.view.endEditing(true)
        if isOnboarding == "true"{
            if  BankAccountAdded == "1" {
                self.viewVerificationAlert.isHidden = true
                // self.callWsForbankSkip()
                print("user is owner")
                let storyBoard = UIStoryboard(name: "OwnerTabBar", bundle:nil)
                let AddBankAccountVC = storyBoard.instantiateViewController(withIdentifier: "AddPropertyVC") as! AddPropertyVC
                self.navigationController?.pushViewController(AddBankAccountVC, animated: true)
            }else{
                self.viewVerificationAlert.isHidden = true
                
            }
            
        }else{
            self.viewVerificationAlert.isHidden = true
            
        }
    }
    
    @IBAction func btnProceedVerification(_ sender: Any) {
        //self.call_WebserviceForAccountVerification()
        print(self.strVerificationLink)
        self.viewVerificationAlert.isHidden = true
        self.viewVerification.isHidden = false
        self.loadUrl(strUrl:self.strVerificationLink)
        
    }
    
    
    
    @IBAction func btnContinue(_ sender: Any) {
        self.view.endEditing(true)
        self.onboarding()
        self.AddBankAccountValidation()
    }
    
    
    @IBAction func btnSkip(_ sender: Any) {
        self.view.endEditing(true)
        self.onboarding()
        self.callWsForbankSkip()
    }
    
    
    func naviagteToProperty(){
        let storyBoard = UIStoryboard(name: "OwnerTabBar", bundle:nil)
        let AddBankAccountVC = storyBoard.instantiateViewController(withIdentifier: "AddPropertyVC") as! AddPropertyVC
        self.navigationController?.pushViewController(AddBankAccountVC, animated: true)
    }
    
    
    func onboarding(){
        
        if AccountManager.sharedInstance.isonboarding == true{
            //checkOnboarding = "true"
            UserDefaults.standard.set(AccountManager.sharedInstance.isonboarding, forKey:"onboard")
            UserDefaults.standard.set(checkOnboarding, forKey: "onboarding" )
            print(AccountManager.sharedInstance.isonboarding)
            
        }else if AccountManager.sharedInstance.isonboarding == false {
            
            //checkOnboarding = "false"
            UserDefaults.standard.set(AccountManager.sharedInstance.isonboarding, forKey:"onboard")
            UserDefaults.standard.set(checkOnboarding, forKey: "onboarding" )
            //print(checkOnboarding)
            print(AccountManager.sharedInstance.isonboarding)
            
        }
    }
}


//MARK: Validation-

extension AddBankAccountVC {
    
    func AddBankAccountValidation (){
        
        self.txtBankName.text = self.txtBankName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtAccountHolderName.text = self.txtAccountHolderName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtAccountNumber.text = self.txtAccountNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtRaoutingNUmber.text = self.txtRaoutingNUmber.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let strBankName = self.txtBankName.text?.count ?? 0
        _ = self.txtRaoutingNUmber.text?.count ?? 0
        
        
        if txtBankName.text?.isEmpty == true  {
            objAlert.showAlert(message: BlankBankName, title: kAlertTitle, controller: self
            )
        }
        else if strBankName < 3  {
            objAlert.showAlert(message: BankNameLenght, title:kAlertTitle, controller: self
            )
        }else if txtAccountHolderName.text?.isEmpty == true  {
            objAlert.showAlert(message: BlankHolderName, title: kAlertTitle, controller: self
            )
        }
        else if txtAccountNumber.text?.isEmpty == true  {
            objAlert.showAlert(message: BlankAccountNumber, title: kAlertTitle, controller: self
            )
        }else if txtRaoutingNUmber.text?.isEmpty == true  {
            objAlert.showAlert(message: BlankRoutingNumber, title: kAlertTitle, controller: self
            )
        }else {
            if self.btnContinue.titleLabel?.text == "Update"{
                self.callWebserviceForUpdatebankAccount(strAccoundID: self.strAccountId)
            }else{
                self.callWebserviceForAddbankAccount()
            }
            
            
        }
    }
}

extension AddBankAccountVC : UITextFieldDelegate {
    
    //MARK:KeyboardFunctions-
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.txtBankName{
            self.txtBankName.resignFirstResponder()
            self.txtAccountHolderName.becomeFirstResponder()
            
            
        }else if textField == self.txtAccountHolderName{
            self.txtAccountHolderName.resignFirstResponder()
            self.txtAccountNumber.becomeFirstResponder()
            
        }
        else if textField == self.txtAccountNumber{
            self.txtAccountNumber.resignFirstResponder()
            self.txtRaoutingNUmber.becomeFirstResponder()
        }
        else{
            self.txtRaoutingNUmber.resignFirstResponder()
        }
        return true
    }
    
}

//MARK:- Add bank Detail Api

extension AddBankAccountVC{
    func call_WebserviceForCheckVerification(){
        SVProgressHUD.show()
        
        objWebServiceManager.requestGet(strURL: WsUrl.checkAccountVerification, params:nil, queryParams: [:], strCustomValidation: "", success: { (response) in
            
            print("*******************************")
            print(response)
            
            print("*******************************")
            
            SVProgressHUD.dismiss()
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
            var isAccountVerify = ""
            if status == "success"{
                SVProgressHUD.dismiss()

                if let data = response["data"] as? [String:Any]{
                    if let isVerify = data["stripe_connect_account_verified"] as? String {
                        isAccountVerify = isVerify
                        self.AccountVerification = isVerify
                    }else if let isVerify = data["stripe_connect_account_verified"] as? Int {
                        isAccountVerify = String(isVerify)
                        self.AccountVerification = String(isVerify)
                        
                    }
                    
                    if isAccountVerify == "1"{
                        self.AccountVerification = "1"
                        self.btnCompleteVerification.isUserInteractionEnabled = false
                        self.btnCompleteVerification.setTitle("Verification Completed", for: .normal)
                        self.btnCompleteVerification.backgroundColor = .clear
                        
                        self.btnCompleteVerification.setTitleColor(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), for: .normal);
                    }else{
                        self.AccountVerification = "0"
                        
                        self.btnCompleteVerification.isUserInteractionEnabled = true
                        self.btnCompleteVerification.setTitle("Verify Account", for: .normal)
                        self.btnCompleteVerification.backgroundColor = #colorLiteral(red: 1, green: 0.003921568627, blue: 0.003921568627, alpha: 1)
                        self.btnCompleteVerification.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal);
                        
                        //  self.viewVerificationAlert.isHidden = true
                        
                    }
                    
                    if let dictBankDetail = data["bank_account"] as? [String:Any]{
                        if self.isOnboarding == "true" {
                            self.lblTitleHeader.text = "Edit Bank Account"
                            self.btnContinue.setTitle("Update", for: .normal)
                            self.viewBtnback.isHidden = true
                            self.btnSkip.isHidden = false
                            
                        }else{
                            self.lblTitleHeader.text = "Edit Bank Account"
                            self.btnContinue.setTitle("Update", for: .normal)
                            self.viewBtnback.isHidden = false
                            self.btnSkip.isHidden = true
                        }
                        self.BankAccountAdded = "1"
                        
                        self.txtBankName.text = dictBankDetail["bank_name"] as? String ?? ""
                        self.txtAccountHolderName.text = dictBankDetail["account_holder_name"] as? String ?? ""
                        self.txtAccountNumber.text = dictBankDetail["account_number"] as? String ?? ""
                        self.txtRaoutingNUmber.text = dictBankDetail["routing_number"] as? String ?? ""
                        self.strAccountId = String(dictBankDetail["bankAccountID"] as? Int ?? 0)
                        self.strBankName = self.txtBankName.text ?? ""
                        self.strAccountHoldername = self.txtAccountHolderName.text ?? ""
                        self.strAccountNumber = self.txtAccountNumber.text ?? ""
                        self.strRoutingNumber = self.txtRaoutingNUmber.text ?? ""
                        self.btnSkip.isHidden = true
                    }else{
                        
                        self.BankAccountAdded = "0"
                        self.lblTitleHeader.text = "Add Bank Account"
                        if self.isOnboarding == "true" {
                            self.btnContinue.setTitle("Continue", for: .normal)
                            self.viewBtnback.isHidden = true
                            self.btnSkip.isHidden = false
                            
                        }else{
                            
                            self.btnContinue.setTitle("Add", for: .normal)
                            self.viewBtnback.isHidden = false
                            self.btnSkip.isHidden = true
                        }
                        
                    }
                    if self.returnFromeWebview == "1"{
                        if self.isOnboarding == "false"{
                            self.viewBtnback.isHidden = false
                            
                            if self.BankAccountAdded == "1" && self.AccountVerification == "1"{
                                
                            }else if self.BankAccountAdded == "1"{
                                if self.AccountVerification == "0"{
                                    self.viewVerificationAlert.isHidden = false
                                    
                                }
                            }
                            
                        }
                        
                        if self.isOnboarding == "true"
                        {
                            self.viewBtnback.isHidden = true
                            self.naviagteToProperty()

//                            self.viewBtnback.isHidden = true
//                            if self.BankAccountAdded == "1" && self.AccountVerification == "1"{
//                                self.naviagteToProperty()
//
//                            }else if self.BankAccountAdded == "1"{
//                                if self.AccountVerification == "0"{
//                                    self.viewVerificationAlert.isHidden = false
//
//                                }
//
//                            }
                        }
                        
                    }else if self.isOnboarding == "false"{
                        self.viewBtnback.isHidden = false
                        
                        
                        if self.BankAccountAdded == "1" && self.AccountVerification == "1"{
                            
                        }else if self.BankAccountAdded == "1"{
                            if self.AccountVerification == "0"{
                                self.viewVerificationAlert.isHidden = false
                                
                            }
                        }
                        
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
            self.call_WebserviceForAccountVerification()
            
        }) { (error) in
            print(error)
        }
    }
    
    
    func call_WebserviceForAccountVerification(){
        
        print(AppShareData.sharedObject().UserDetail.strAccountId)
        let strStripeAccountId = objAppSharedata.UserDetail.strAccountId
        objWebServiceManager.requestPut(strURL: WsUrl.accountVerification+strStripeAccountId, queryParams: [:], params: nil, strCustomValidation:WsParamsType.PathVariable , showIndicator: true, success: { (response) in
            print(response)
            let message = response["message"] as? String ?? ""
            let status = response["status"] as? String ?? ""
            
            if status == "success"{
                if let dict = response["data"] as? [String:Any] {
                    if let dictStriplink = dict["stripe_account_link"] as? [String:Any] {
                        if let strLink = dictStriplink["url"] as? String {
                            self.strVerificationLink = strLink
                            //                        self.viewVerificationAlert.isHidden = true
                            //                        self.viewVerification.isHidden = false
                            //                        self.loadUrl(strUrl:strLink)
                        }
                    }
                }
                SVProgressHUD.dismiss()
                
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
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message:kErrorMessage, title: kAlertTitle, controller: self)
        })
        
    }
}

//MARK:- WKNavigationDelegate
extension AddBankAccountVC: WKNavigationDelegate{
    
    
    @IBAction func backFromVerificationAction(_ sender: Any){
        self.viewVerification.isHidden = true
        self.call_WebserviceForCheckVerification()
        
    }
    
    func loadUrl(strUrl:String){
        let url = NSURL(string: strUrl)
        let request = NSURLRequest(url: url! as URL)
        self.wkWebView.navigationDelegate = self as! WKNavigationDelegate
        self.wkWebView.load(request as URLRequest)
    }
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        SVProgressHUD.dismiss()
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.show(withStatus: "Please wait..")
        returnFromeWebview = "1"

        // SVProgressHUD.show()
        print("Strat to load")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
        if let text = webView.url?.absoluteString {
            print(text)
            returnFromeWebview = "1"
            if (text == "http://hoggzlogistics.com:3002/payment/account-verify/success" || text == "http://hoggzlogistics.com:3002/payment/account-verify/fail") || (text.contains("success") || text.contains("fail")){
                self.viewVerification.isHidden = true
                self.call_WebserviceForCheckVerification()
                
            }
        }
    }
}


//MARK:- Api calling
extension AddBankAccountVC{
    
    //MARK:- Add bank detail
    func callWebserviceForAddbankAccount(){
        SVProgressHUD.show()
        let param = ["onboarding":self.isOnboarding,
                     "AcctHolderName" : txtAccountHolderName.text ?? "",
                     "bankName" : txtBankName.text ?? "",
                     "accountNumber" : txtAccountNumber.text ?? "",
                     "routingNumber" : txtRaoutingNUmber.text ?? "" ] as [String : Any]
        print(param)
        objWebServiceManager.requestPut(strURL: WsUrl.addBankAccount, queryParams: [:], params: param, strCustomValidation: "", showIndicator: true, success: { (response) in
            SVProgressHUD.dismiss()
            let message = response["message"] as? String ?? ""
            let status = response["status"] as? String ?? ""
            
            if status == "success"{
                if self.isOnboarding == "false"{
                    let alert = UIAlertController(title:"Alert" , message:message, preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title:"Ok" , style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }else{
                    AccountManager.sharedInstance.isonboarding = true
                    if message ==  "Bank account has added successfully."{
                        
                        self.BankAccountAdded = "1"
                        self.btnSkip.isHidden = true
                        
                    }else{
                        self.BankAccountAdded = "0"
                    }
                    //                    let dic = response["data"] as? [String:Any] ?? [:]
                    //                    let user_details  = dic["user_details"] as? [String:Any] ?? [:]
                    //                    let propertyList = BankAccountModel(dict: user_details )
                    //
                    if self.BankAccountAdded == "1" && self.AccountVerification == "1"{
                        //self.naviagteToProperty()
                        
                    }else if self.BankAccountAdded == "1"{
                        if self.AccountVerification == "0"{
                            self.viewVerificationAlert.isHidden = false
                        }
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
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message:kErrorMessage, title: kAlertTitle, controller: self)
        })
        
    }
}

extension AddBankAccountVC{
    
    func callWsForbankSkip(){
        SVProgressHUD.show()
        AccountManager.sharedInstance.isonboarding = false
        onboarding()
        
        let param = ["step":"2"]
        
        objWebServiceManager.requestPut(strURL: WsUrl.skip_onboardingsStep, queryParams: [:], params: param, strCustomValidation: "", showIndicator: true, success: { (response) in
            print(response)
            
            let status = response["status"] as? String ?? ""
            let data = response["data"] as? [String:Any] ?? [:]
            let message = response["message"] as? String ?? ""
            
            var nextStep = ""
            if let step = data["next_step"] as? Int{
                nextStep = String(step)
            }else if let step = data["next_step"] as? String{
                nextStep = step
            }
            
            if status == "success" {
                AccountManager.sharedInstance.isonboarding = false
                
                SVProgressHUD.dismiss()
                
                let usertype = objAppSharedata.UserDetail.strUserType
                let onstep = objAppSharedata.UserDetail.stronboarding_step
                print(onstep)
                
                if usertype == "owner" {
                    print("user is owner")
                    let storyBoard = UIStoryboard(name: "OwnerTabBar", bundle:nil)
                    let AddBankAccountVC = storyBoard.instantiateViewController(withIdentifier: "AddPropertyVC") as! AddPropertyVC
                    self.navigationController?.pushViewController(AddBankAccountVC, animated: true)
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
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message:kErrorMessage, title: kAlertTitle, controller: self)
        })
        
    }
}

//MARK:- update bank detail
extension AddBankAccountVC{
    
    func callWebserviceForUpdatebankAccount(strAccoundID:String){
        SVProgressHUD.show()
        let param = ["onboarding":self.isOnboarding,
                     "AcctHolderName" :self.txtAccountHolderName.text ?? "",
                     "bankName" :self.txtBankName.text ?? "",
                     "accountNumber" :self.txtAccountNumber.text ?? "",
                     "routingNumber" : self.txtRaoutingNUmber.text ?? "" ] as [String : Any]
        
        objWebServiceManager.requestPut(strURL: WsUrl.addBankAccount+"/"+strAccoundID, queryParams: [:], params: param, strCustomValidation: WsParamsType.PathVariable, showIndicator: true, success: { (response) in
            SVProgressHUD.dismiss()
            let message = response["message"] as? String ?? ""
            let status = response["status"] as? String ?? ""
            
            if status == "success"{
                
                let alert = UIAlertController(title:"Alert" , message:message, preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title:"Ok" , style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.navigationController?.popViewController(animated: true)
                }
                
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
                
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
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message:kErrorMessage, title: kAlertTitle, controller: self)
        })
        
    }
    
}
