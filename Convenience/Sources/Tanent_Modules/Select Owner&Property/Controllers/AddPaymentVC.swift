//
//  AddPaymentVC.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 13/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import SVProgressHUD
class AddPaymentVC: UIViewController {
    
    //MARK:IBOutlet-
    @IBOutlet weak var imgtanent: UIImageView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lblTanenName: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    
    //MARK:AppLifeCycle-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UiDesign()
        self.lblTanenName.text = objAppShareData.UserDetail.strFirstName
        let strimage = objAppShareData.UserDetail.strProfilePicture
        let urlImg = URL(string: strimage)
        self.imgtanent.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "profile_ico"))
        
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK:btnAddPayment-
    
    @IBAction func btnSkip(_ sender: Any) {
        self.callWSForEmailSip()
    }
    @IBAction func btnAddPayment(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Tanentside", bundle:nil)
        let AddCardVC = storyBoard.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
        self.navigationController?.pushViewController(AddCardVC, animated: true)
    }
    //MARK:Local Function -
    
    func UiDesign(){
        viewContent.setViewRadius()
        viewContent.setshadowView()
        imgtanent.setImgCircle()
        imgtanent.layer.shadowPath = UIBezierPath(rect: imgtanent.bounds).cgPath
        
    }
}
extension AddPaymentVC{
    func callWSForEmailSip(){
        SVProgressHUD.show()
        
        let param = ["step":"3"]
        objWebServiceManager.requestPut(strURL: WsUrl.skip_onboardingsStep, queryParams: [:], params: param, strCustomValidation: "", showIndicator: false, success: { (response) in
            print(response)
            SVProgressHUD.dismiss()
            
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""

            let data = response["data"] as? [String:Any] ?? [:]
            var nextStep = ""
            if let step = data["next_step"] as? Int{
                nextStep = String(step)
            }else if let step = data["next_step"] as? String{
                nextStep = step
            }
            
            if status == "success" {
                SVProgressHUD.dismiss()
                
                let usertype = objAppSharedata.UserDetail.strUserType
                
                if usertype == "tenant" && nextStep == "4"{
                    objAppDelegate.showTenantTabbarNavigation()
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

        })
        { (error) in
            print(error)
            SVProgressHUD.dismiss()
            
        }
    }
    
    
}
