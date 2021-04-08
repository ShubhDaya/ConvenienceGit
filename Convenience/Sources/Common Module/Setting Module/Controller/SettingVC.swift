//
//  SettingVC.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 21/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import SVProgressHUD

class SettingVC: UIViewController {
    var check = true
    var notificationStatus = -1
    var alertStaus = 5

    var strPolicy = ""
    var strTermsCondition = ""
    
    //MARK: IBOutlets-
    
    @IBOutlet weak var imgOnOff: UIImageView!
    @IBOutlet weak var lblProfileName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var viewimgProfile: UIView!
    @IBOutlet weak var Stackview: UIStackView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var viewBankView: UIView!
    @IBOutlet weak var viewPaymentMethods: UIView!
    @IBOutlet weak var togglebutton: UIButton!
    
    //MARK: AppLifeCycle-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UIDesign()
        self.Usertype()
        checkNotificationStatus()
        if objAppShareData.isFromNotification{
            if objAppShareData.strNotificationType == "connect_account_verification_pending"{
            let userType = UserDefaults.standard.value(forKey: UserDefaults.KeysDefault.kUserType) as? String ?? ""
            if userType == "owner"{
               let vc = UIStoryboard.init(name: "OwnerTabBar", bundle: nil).instantiateViewController(withIdentifier: "AddBankAccountVC")as! AddBankAccountVC
               vc.isOnboarding = "false"
               self.navigationController?.pushViewController(vc, animated: false)
                }
                 objAppShareData.isFromNotification = false
                 objAppShareData.strNotificationType = ""
                 objAppShareData.notificationDict = [:]
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkOnboarding = "false"
        print("push alert status \(UserDefaults.standard.value(forKey:"PushAlertStatus"))")

        alertStaus = UserDefaults.standard.value(forKey:"PushAlertStatus") as? Int ?? 5
        print(alertStaus)

        self.checkNotificationStatus()
        self.lblProfileName.text = "\(objAppShareData.UserDetail.strFirstName) \(objAppShareData.UserDetail.strLastName)"
        let strimage = objAppShareData.UserDetail.strProfilePicture
        let urlImg = URL(string: strimage)
        self.imgProfile.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "user_img"))
        //self.GetContent()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:Button
    
    
    @IBAction func toggleButton(_ sender: Any) {
        check = !check
        
    if alertStaus == 0{
            imgOnOff.image = #imageLiteral(resourceName: "toggleon")
            //  check = true
            notificationStatus = 1
            print(" for on \(notificationStatus)")
        } else if alertStaus == 1
        {
            imgOnOff.image = #imageLiteral(resourceName: "toggleoff")
            notificationStatus = 0
            print(" for off \(notificationStatus)")
        }
        self.callWebforchangeNotificationStatus()
    }
    
    
    
    @IBAction func btnPaymentMethods(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Settings", bundle:nil)
        let AddPropertyVC = storyBoard.instantiateViewController(withIdentifier: "PaymentMethodVC") as! PaymentMethodVC
        self.navigationController?.pushViewController(AddPropertyVC, animated: true)
        
    }
    @IBAction func btnBankDetails(_ sender: Any) {
        self.view.endEditing(true)
        let vc = UIStoryboard.init(name: "OwnerTabBar", bundle: nil).instantiateViewController(withIdentifier: "AddBankAccountVC")as! AddBankAccountVC
        vc.isOnboarding = "false"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnEditProfile(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Settings", bundle:nil)
        let AddPropertyVC = storyBoard.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        self.navigationController?.pushViewController(AddPropertyVC, animated: true)
    }
    
    @IBAction func btnChangePassword(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Settings", bundle:nil)
        let AddPropertyVC = storyBoard.instantiateViewController(withIdentifier: "ChangePassWordVC") as! ChangePassWordVC
        self.navigationController?.pushViewController(AddPropertyVC, animated: true)
    }
    
    @IBAction func btnTermCondition(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Settings", bundle:nil)
        let AddPropertyVC = storyBoard.instantiateViewController(withIdentifier: "TermConditionVC") as! TermConditionVC
       // AddPropertyVC.strTermsCondition = self.strTermsCondition
        AddPropertyVC.strTermsCondition = objAppShareData.strTermsCondition
        self.navigationController?.pushViewController(AddPropertyVC, animated: true)
    }
    
    @IBAction func btnPrivacyPolicy(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Settings", bundle:nil)
        let AddPropertyVC = storyBoard.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
       // AddPropertyVC.strPolicy = self.strPolicy
        AddPropertyVC.strPolicy = objAppShareData.strPolicy
        self.navigationController?.pushViewController(AddPropertyVC, animated: true)
    }
    
    @IBAction func btnFAQ(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Settings", bundle:nil)
        let AddPropertyVC = storyBoard.instantiateViewController(withIdentifier: "FAQVC") as! FAQVC
        self.navigationController?.pushViewController(AddPropertyVC, animated: true)
    }
    @IBAction func btnLogout(_ sender: Any) {
        
        objAlert.showAlertCallBackother(alertLeftBtn: "Cancel", alertRightBtn: "OK", title: kAlertTitle, message: logoutAlert, controller: self, callback: { (Bool) in
            selectedProfileImage = nil
            objAppShareData.callWebserviceForLogoutDelete()
        
            checkOnboarding = ""
            //objAppDelegate.showLogInNavigation()
        }){
            // Add code here For cancel
        }
    }
    
   
    //MARK: Local Functions-
    
    func Usertype(){
        //let UserId = UserDefaults.standard.integer(forKey: "Key")
        
        let userType = UserDefaults.standard.value(forKey: UserDefaults.KeysDefault.kUserType) as? String ?? ""
        if userType == "tenant"{
            self.viewBankView.isHidden = true
        }else if userType == "owner"{
            self.viewPaymentMethods.isHidden = true
        }
    }
    
    func UIDesign(){
        self.view1.setViewRadius()
        self.view1.setshadowView()
        self.imgProfile.setImgCircle()
        self.viewimgProfile.setviewCirclewhite()
        self.viewimgProfile.setshadowViewCircle()
    }
    
    func checkNotificationStatus(){
        if alertStaus == 1{
                     imgOnOff.image = #imageLiteral(resourceName: "toggleon")
                     
                 }else if alertStaus == 0 {
                     imgOnOff.image = #imageLiteral(resourceName: "toggleoff")
                     print(" for off \(notificationStatus)")
        }else{
            
        }
    }
}
extension SettingVC{
    func callWebforchangeNotificationStatus(){
        SVProgressHUD.show()
        print(notificationStatus)
        // let param = ["id":cardID]
        objWebServiceManager.requestPatch(strURL: WsUrl.NotificationAlert+String(notificationStatus), params: [:], strCustomValidation: "", success: { (response) in
            print(response)
            SVProgressHUD.dismiss()

            let status = response["status"] as? String
            let message = response["message"] as? String ?? ""
            if status == "success"{
                let dic = response["data"] as? [String:Any] ?? [:]
                let alertStatusapi = dic["push_alert_status"] as? Int ?? 0
                print(alertStatusapi)
                
                objAppShareData.strAlertStatuss = alertStatusapi
                UserDefaults.standard.set(alertStatusapi, forKey:"PushAlertStatus")
                
                PushAlertStatus = alertStatusapi
                self.alertStaus = UserDefaults.standard.value(forKey:"PushAlertStatus") as! Int
                print(self.alertStaus)
    
            }  else{
                       
                          SVProgressHUD.dismiss()
                          if message == "k_sessionExpire"{
                              objAlert.showAlert(message: k_sessionExpire, title: kAlertTitle, controller: self)
                              objAppShareData.resetDefaultsAlluserInfo()
                              objAppDelegate.showLogInNavigation()
                          }  else{
                              objAlert.showAlert(message:message, title: kAlertTitle, controller: self)
                          }
                      }
                      
        }) { (error) in
            print(error)
        }
    }
}
