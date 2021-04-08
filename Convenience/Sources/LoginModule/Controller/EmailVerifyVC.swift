//
//  EmailVerifyVC.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 05/03/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import SVProgressHUD

class EmailVerifyVC: UIViewController {
    
    @IBOutlet weak var viewContentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UiDesign()
        objAppShareData.selecteddata.removeAll()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func btnSkip(_ sender: Any) {
        self.callWSForEmailSip()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        self.callWebserviceForLogoutDelete()
    }
    
    
    @IBAction func btnAlreadyVerify(_ sender: Any) {
        self.view.endEditing(true)
        _ = objAppShareData.UserDetail.strUserType
        self.callWSForEmailAlredyVerified()
//        if usertype == "owner"{
//            print("user is owner")
//            let storyBoard = UIStoryboard(name: "OwnerTabBar", bundle:nil)
//            let AddBankAccountVC = storyBoard.instantiateViewController(withIdentifier: "AddBankAccountVC") as! AddBankAccountVC
//            self.navigationController?.pushViewController(AddBankAccountVC, animated: true)
//            
//        }else if usertype == "tenant"{
//            print("user is tenant")
//            
//            let storyBoard = UIStoryboard(name: "Tanentside", bundle:nil)
//            let AddPropertieVC = storyBoard.instantiateViewController(withIdentifier: "AddPropertieVC") as! AddPropertieVC
//            self.navigationController?.pushViewController(AddPropertieVC, animated: true)
//        }
    }
    func UiDesign(){
        viewContentView.setViewRadius()
        viewContentView.setshadowView()
    }
    func callWSForEmailAlredyVerified(){
        SVProgressHUD.show()
        objWebServiceManager.requestGet(strURL: WsUrl.emailVerified+"?email="+objAppSharedata.UserDetail.strEmail, params: [:], queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            SVProgressHUD.dismiss()
            let code = response["code"] as? Int
            let message = response["message"] as? String ?? ""
            if code == 200{
                let data = response["data"] as? [String:Any] ?? [:]
                var verification = ""
                if let veri = data["is_verified"] as? String{
                    verification = veri
                }else if let veri = data["is_verified"] as? Int{
                    verification = String(veri)
                }
                if verification == "1"{
                    let usertype = objAppSharedata.UserDetail.strUserType
                           if usertype == "owner"{
                                print("user is owner")
                                self.view.endEditing(true)
                                          let vc = UIStoryboard.init(name: "OwnerTabBar", bundle: nil).instantiateViewController(withIdentifier: "AddBankAccountVC")as! AddBankAccountVC
                                          vc.isOnboarding = "true"
                                    self.navigationController?.pushViewController(vc, animated: true)
                                
                            }else if usertype == "tenant"{
                                print("user is tenant")
                    
                                let storyBoard = UIStoryboard(name: "Tanentside", bundle:nil)
                                let AddPropertieVC = storyBoard.instantiateViewController(withIdentifier: "GrabBetterPropertyVC") as! GrabBetterPropertyVC
                                self.navigationController?.pushViewController(AddPropertieVC, animated: true)
                            }

                }else{
                    objAlert.showAlert(message: message, title: kAlertTitle, controller: self)
                    
                }
                
                
                SVProgressHUD.dismiss()
            }else{
                SVProgressHUD.dismiss()
                objAlert.showAlert(message: message, title: "Alert", controller: self)
            }
        }) { (error) in
            print(error)
        }
    }
    func callWSForEmailSip(){
        SVProgressHUD.show()

        let param = ["step":"1"]
        objWebServiceManager.requestPut(strURL: WsUrl.skip_onboardingsStep, queryParams: [:], params: param, strCustomValidation: "", showIndicator: false, success: { (response) in
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
                SVProgressHUD.dismiss()

                let usertype = objAppSharedata.UserDetail.strUserType
                
                if usertype == "owner" && nextStep == "2"{
                            
                            self.view.endEditing(true)
                                let vc = UIStoryboard.init(name: "OwnerTabBar", bundle: nil).instantiateViewController(withIdentifier: "AddBankAccountVC")as! AddBankAccountVC
                                    vc.isOnboarding = "true"
                              self.navigationController?.pushViewController(vc, animated: true)
                          
                
                        }else if usertype == "tenant" && nextStep == "2"{
                            print("user is tenant")
                            let storyBoard = UIStoryboard(name: "Tanentside", bundle:nil)
                            let AddPropertieVC = storyBoard.instantiateViewController(withIdentifier: "GrabBetterPropertyVC") as! GrabBetterPropertyVC
                    checkOnboarding = "true"
                    self.navigationController?.pushViewController(AddPropertieVC, animated: true)
                        }
                }else{
                    SVProgressHUD.dismiss()
                    if message == "Inactive user"{
                        //                        objAppShareData.sessionExpireAlertVC(controller: self, alertTitle: kAlertTitle, alertMessage: k_Inactiveuser)
                    }else{
                        objAlert.showAlert(message : message, title: kAlertTitle, controller: self)
                    }
                }
        }, failure: { (error) in
            print(error)
            SVProgressHUD.dismiss()
            //  objAppShareData.showAlert(title: kAlertTitle, message: kErrorMessage, view: self)
        })
        
}
    
       func callWebserviceForLogoutDelete(){
            objWebServiceManager.requestDelete(strURL: WsUrl.logout, params: nil, queryParams: [:], strCustomValidation: "", success:{response in
              
               let status = (response["status"] as? String)
            //   let message = (response["message"] as? String)
               if status == k_success{
                objAppSharedata.resetDefaultsAlluserInfo()
                
                  objWebServiceManager.hideIndicator()
    //               if #available(iOS 13.0, *) {
    //                   objSceneDelegate.showLogInNavigation()
    //               }else{
                      objAppSharedata.resetDefaultsAlluserInfo()
                       objAppDelegate.showLogInNavigation()
                   //}
               }else{
                    objWebServiceManager.hideIndicator()
    //               if #available(iOS 13.0, *) {
    //                   objSceneDelegate.showLogInNavigation()
    //               }else{
                       objAppDelegate.showLogInNavigation()
                   //}
                }
               }, failure: { (error) in
                  print(error)
                    objWebServiceManager.hideIndicator()
                 // objAppShareData.showAlert(title: kAlertTitle, message: message ?? "", view: self)
               })
            
        }
}
