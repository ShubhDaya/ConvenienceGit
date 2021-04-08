//
//  leavePropertyDetailsVC.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 12/02/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import SVProgressHUD
var dueLeaveAllClearBox = ""

class leavePropertyDetailsVC: UIViewController {
    var objProperty = PropertyDetail(dict: [:])
    var object = PropertyModel(dict: [:])
    var ObjAlertClassData =  AlertModel(dict: [:])
    var btnLeaveAllDueCheck_Box = false
    var btnCancelPendingProDueCheck_Box = false

    var tenant_id = 0
    var propertyid = 0
    var tenantid = 0
    var reject = "cancel"
    var ownerid = 0
    var propertyStatusNew = 0
    var ownername = ""
    var ownerProfile = ""
    
    
    @IBOutlet weak var btnCancelRemvePro: customButton!
    @IBOutlet weak var btnProceedRemoveProperty: customButton!
    
    @IBOutlet weak var imgCancelProCheck: UIImageView!

    @IBOutlet weak var imgcheckBox: UIImageView!
    @IBOutlet weak var btnProceedDueAlert: customButton!
    @IBOutlet weak var btnCacnelDueAlert: customButton!
    @IBOutlet weak var CancelAlert: UIView!
    @IBOutlet weak var ViewCancelAlertHeader: UIView!
    @IBOutlet weak var viewAlertHeader: UIView!
    @IBOutlet weak var viewLeaveAlert: UIView!
    @IBOutlet weak var viewAlerContainer: UIView!
    @IBOutlet weak var btnProceedAlert: customButton!
    @IBOutlet weak var imgProperty: UIImageView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var lblleavePropertyDetails: UILabel!
    @IBOutlet weak var lblLeavePropertyAddress: UILabel!
    @IBOutlet weak var lblPaymentDueDate: UILabel!
    @IBOutlet weak var imgOwner: UIImageView!
    @IBOutlet weak var viewImgOwner: UIView!
    @IBOutlet weak var lblOwnerName: UILabel!
    @IBOutlet weak var btnLeaveProperty: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiDesign()
        self.imgcheckBox.isHidden = true
        self.viewLeaveAlert.isHidden = true
        self.CancelAlert.isHidden = true
        self.viewAlerContainer.isHidden = true
        if object.status == 1{
            self.btnLeaveProperty.setTitle("Remove Property", for: .normal)
        }else if object.status == 2{
            self.btnLeaveProperty.setTitle("Leave Property", for: .normal)
        }else if ObjAlertClassData.strType == "property_request_accept"{
            self.btnLeaveProperty.setTitle("Leave Property", for: .normal)
        }else if ObjAlertClassData.strType == "property_request_declined"{
            print("property_request_declined")
            self.btnLeaveProperty.isHidden = true
        }else if ObjAlertClassData.strType == "owner_property_leave"{
            print("owner_property_leave")
            self.btnLeaveProperty.isHidden = true
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.imgCancelProCheck.isHidden = true
        self.imgcheckBox.isHidden = true
        if isAlertId == true{
                 print(ObjAlertClassData.strPropertyID)
                 self.propertyid = Int(ObjAlertClassData.strPropertyID) ?? 0
                 self.tenantid = Int(ObjAlertClassData.strRecipient_user_id) ?? 0
             }else{
                 print(objProperty.propertyID)
                 self.propertyid = objProperty.propertyID
             self.tenantid = Int(objAppShareData.UserDetail.strUserID) ?? 0

             }
        
        self.GetProprtyDetails()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func btnContantOwner(_ sender: Any) {
        
              let storyBoard = UIStoryboard(name: "PropertyTenTab", bundle:nil)
              let AddPropertyVC = storyBoard.instantiateViewController(withIdentifier: "ContactOwnerVC") as! ContactOwnerVC
              self.navigationController?.pushViewController(AddPropertyVC, animated: true)
    }
    
    
    
    @IBAction func btnLeaveProperty(_ sender: Any) {
        print(object.status ?? "")
        if self.propertyStatusNew == 1{
             self.viewLeaveAlert.isHidden = false
             self.CancelAlert.isHidden = false
             self.viewAlerContainer.isHidden = true
        }else if self.propertyStatusNew == 2{
                  self.viewLeaveAlert.isHidden = false
                  self.CancelAlert.isHidden = true
                  self.viewAlerContainer.isHidden = false
        }
    }
    
    @IBAction func btnCancelNo(_ sender: Any) {
        self.viewLeaveAlert.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        self.imgCancelProCheck.isHidden = true
        self.btnCancelRemvePro.layer.cornerRadius = 20
        self.btnProceedRemoveProperty.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
        self.btnProceedRemoveProperty.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.btnProceedRemoveProperty.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    @IBAction func btnCancelYes(_ sender: Any) {
        if    self.imgCancelProCheck.isHidden == false{
            
            self.tabBarController?.tabBar.isHidden = false
            self.btnProceedRemoveProperty.layer.cornerRadius = 20
            self.imgCancelProCheck.isHidden = true
            self.btnCancelRemvePro.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
            self.btnCancelRemvePro.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            self.btnCancelRemvePro.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.btnProceedRemoveProperty.tintColor = #colorLiteral(red: 0.2823529412, green: 0.3607843137, blue: 0.9607843137, alpha: 1)
            self.viewLeaveAlert.isHidden = true
            self.RejectRequestAPI()
        }else{
            self.tabBarController?.tabBar.isHidden = false
            self.btnProceedRemoveProperty.layer.cornerRadius = 20
            self.imgCancelProCheck.isHidden = true
            self.btnCancelRemvePro.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
            self.btnCancelRemvePro.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            self.btnCancelRemvePro.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.btnProceedRemoveProperty.tintColor = #colorLiteral(red: 0.2823529412, green: 0.3607843137, blue: 0.9607843137, alpha: 1)
            self.viewLeaveAlert.isHidden = true
        }
    }
    
    @IBAction func btnLogout(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCancelLeaveAlert(_ sender: Any) {
        self.imgcheckBox.isHidden = true
        self.viewLeaveAlert.isHidden = true
        self.viewAlerContainer.isHidden = true
        
        self.tabBarController?.tabBar.isHidden = false
        self.viewLeaveAlert.isHidden = true
        self.imgcheckBox.isHidden = true
        self.btnProceedDueAlert.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.btnProceedDueAlert.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
    }
    
    @IBAction func btnProceedLeaveAlert(_ sender: Any) {
        if  self.imgcheckBox.isHidden == false{
            
             self.LeaveTenantRequestAPI()
            self.imgcheckBox.isHidden = true
            self.viewLeaveAlert.isHidden = true
            self.viewAlerContainer.isHidden = true
            self.btnProceedDueAlert.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.btnProceedDueAlert.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
            btnLeaveAllDueCheck_Box = false
        }else {
            self.imgcheckBox.isHidden = true
            self.btnProceedDueAlert.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.btnProceedDueAlert.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)

            self.viewLeaveAlert.isHidden = true
            self.viewAlerContainer.isHidden = true
        }
        
    }
    @IBAction func btnCheckBoxClearAlert(_ sender: Any) {
        
        if (btnLeaveAllDueCheck_Box == true)
        {
            self.tabBarController?.tabBar.isHidden = true
            self.imgcheckBox.isHidden = false
            self.btnLeaveAllDueCheck_Box = false;
            dueAllClearBox = "1"
           // self.btnProceedDueAlert.setBackgroundImage(#imageLiteral(resourceName: "Button_img"), for: .normal)
            self.btnProceedDueAlert.backgroundColor = #colorLiteral(red: 0.2823529412, green: 0.3607843137, blue: 0.9607843137, alpha: 1)
            self.btnProceedDueAlert.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            btnProceedDueAlert.layer.cornerRadius = 20
        }
        else
        {
            self.tabBarController?.tabBar.isHidden = true
            self.imgcheckBox.isHidden = true
            self.btnLeaveAllDueCheck_Box = true;
            self.btnProceedDueAlert.setBackgroundImage(nil, for: .normal)
            self.btnProceedDueAlert.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
            self.btnProceedDueAlert.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            btnProceedDueAlert.layer.cornerRadius = 20
            btnProceedDueAlert.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            btnProceedDueAlert.layer.borderWidth = 0.5
            dueAllClearBox = ""
        }
    }
    
    @IBAction func btnCancelProcheckboxdue(_ sender: Any) {
        
        if (btnCancelPendingProDueCheck_Box == true)
        {
            self.tabBarController?.tabBar.isHidden = true
            self.imgCancelProCheck.isHidden = false
            self.btnCancelPendingProDueCheck_Box = false;
            self.btnProceedRemoveProperty.backgroundColor = #colorLiteral(red: 0.2823529412, green: 0.3607843137, blue: 0.9607843137, alpha: 1)
            self.btnProceedRemoveProperty.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            btnProceedRemoveProperty.layer.cornerRadius = 20

        }
        else
        {
            self.tabBarController?.tabBar.isHidden = true
            self.imgCancelProCheck.isHidden = true
            self.btnCancelPendingProDueCheck_Box = true;
            self.btnProceedRemoveProperty.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.btnProceedRemoveProperty.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
            btnProceedRemoveProperty.layer.cornerRadius = 20

            
        }
    }
    
    
    
    
    //MARK:Loacal Methods-
    
    func uiDesign(){
        self.view1.setViewRadius10()
        self.view1.setshadowView()
        self.imgOwner.setImgCircle()
        self.viewImgOwner.setviewCircle()
        self.viewImgOwner.setshadowViewCircle()
        self.btnProceedAlert.btnRadNonCol20()
        self.viewAlerContainer.setViewRadius10()
        self.viewAlerContainer.setshadowViewCircle()
        self.CancelAlert.setshadowViewCircle()
        self.CancelAlert.setViewCornerRadius()
        self.viewAlertHeader.setViewRadius10()
        self.ViewCancelAlertHeader.setViewRadius10()
    }
}
extension leavePropertyDetailsVC{
    func GetProprtyDetails(){
        SVProgressHUD.show()
        self.view.endEditing(true)
        print(objProperty.propertyID)
        print(propertyid)
        objWebServiceManager.requestGet(strURL: WsUrl.PropetyDetails+String(propertyid)+"?for="+String(objAppShareData.UserDetail.strUserType), params: nil, queryParams: [:], strCustomValidation: "",success: { (response) in
            print(response)
            
            let message = response["message"] as? String ?? ""
            let status = response["status"] as? String ?? ""
            let datafound = Int(response["data_found"] as? String ?? "") ?? 0
            print(datafound)
            
            if   status == "success" {
                SVProgressHUD.dismiss()
                if let data = response["data"]as? [String:Any]{
                    if let arrDetails = data["property_detail"]as? [[String:Any]]{
                        
                        for dic in arrDetails{
                            
                            self.objProperty = PropertyDetail.init(dict: dic)
                            self.lblleavePropertyDetails.text = self.objProperty.name
                            self.lblLeavePropertyAddress.text = self.objProperty.address
                            self.lblOwnerName.text = "\(self.objProperty.first_name) \(self.objProperty.last_name)"
                            self.propertyid = self.objProperty.propertyID
                            print(self.objProperty.due_date)
                            
                            let strimage =  self.objProperty.profile_picture
                            let urlImg = URL(string: strimage )
                            self.imgOwner.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "user_img"))
                            if self.objProperty.due_date == ""{
                                self.lblPaymentDueDate.text = "No date available"
                                
                            }else if self.objProperty.due_date == "1"{
                                self.lblPaymentDueDate.text = "\(self.objProperty.due_date)st of every month"
                            }else if self.objProperty.due_date == "2"{
                                self.lblPaymentDueDate.text = "\(self.objProperty.due_date)nd of every month"
                            }else if self.objProperty.due_date == "3"{
                                self.lblPaymentDueDate.text = "\(self.objProperty.due_date)rd of every month"
                            }else if self.objProperty.due_date == "21"{
                                self.lblPaymentDueDate.text = "\(self.objProperty.due_date)st of every month"
                            }else if self.objProperty.due_date == "22"{
                                self.lblPaymentDueDate.text = "\(self.objProperty.due_date)nd of every month"
                            }else if self.objProperty.due_date == "23"{
                                self.lblPaymentDueDate.text = "\(self.objProperty.due_date)rd of every month"
                            }
                            else{
                                self.lblPaymentDueDate.text = "\(self.objProperty.due_date)th of every month"
                            }
                            let url =  self.objProperty.property_image
                            let urlImge = URL(string: url )
                            self.imgProperty.sd_setImage(with: urlImge, placeholderImage: #imageLiteral(resourceName: "property-placeholder"))
                            
                            let buttonTag = Int(self.objProperty.due_date) ?? -1
                            self.ownerid = Int(self.objProperty.owner_id) ?? 0
                            print(self.ownerid)
                            self.ownername = "\(self.objProperty.first_name) \(self.objProperty.last_name)"
                            self.ownerProfile = self.objProperty.profile_picture
                            
                            UserDefaults.standard.setValue(self.ownerid, forKey: UserDefaults.KeysDefault.ownerid)
                            UserDefaults.standard.setValue(self.ownername, forKey: UserDefaults.KeysDefault.firstname)
                            UserDefaults.standard.setValue(self.ownerProfile, forKey: UserDefaults.KeysDefault.profile)
            
                            var statusN = 0
                            if let status = data["tenant_property_status"] as? Int{
                                statusN = status
                            }else if let status = data["tenant_property_status"] as? String{
                                statusN = Int(status)!
                            }
                                if statusN == 0{
                                    self.btnLeaveProperty.isHidden = true
                                }else if statusN == 1{
                                    self.btnLeaveProperty.isHidden = false
                                    self.btnLeaveProperty.setTitle("Remove Property", for: .normal)
                                }else if statusN == 2{
                                    self.btnLeaveProperty.isHidden = false
                                    self.btnLeaveProperty.setTitle("Leave Property", for: .normal)
                                }
                            self.propertyStatusNew = statusN
                            }
                        }
                    }
                
            }else{
                SVProgressHUD.dismiss()
                objAlert.showAlert(message:message, title: kAlertTitle, controller: self)

            }
        }, failure: { (error) in
            print(error)
            SVProgressHUD.dismiss()
            objAlert.showAlert(message: kErrorMessage, title: kAlertTitle, controller: self)
        })
        
    }
}
extension leavePropertyDetailsVC{
    func LeaveTenantRequestAPI(){
        
        
        SVProgressHUD.show()
        print(objAppShareData.UserDetail.strUserID)
        print(propertyid)
        print(tenantid)
        
        
        objWebServiceManager.requestDelete(strURL: WsUrl.leaveproprtyOwner+String(propertyid)+"/leave/"+String(tenantid), params: [:], queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            
            let message = response["message"] as? String ?? ""
            let status = response["status"] as? String ?? ""
            let datafound = Int(response["data_found"] as? String ?? "") ?? 0
            //self.totalRecords = Int(response["total_records"] as? String ?? "") ?? 0
            print(datafound)
            
            if   status == "success" {
                SVProgressHUD.dismiss()
                self.navigationController?.popViewController(animated: true)
                
                if (response["data"]as? [String:Any]) != nil{
                }
            }else{
                objWebServiceManager.hideIndicator()
                if message == "k_sessionExpire"{
                    objAlert.showAlert(message: k_sessionExpire, title: kAlertTitle, controller: self)
                    objAppDelegate.showLogInNavigation()
                    objAppShareData.resetDefaultsAlluserInfo()
                    
                }  else{
                    objAlert.showAlert(message:message, title: kAlertTitle, controller: self)
                }
            }
        }, failure:  {(error) in
            print(error)
            SVProgressHUD.dismiss()
            objAlert.showAlert(message: "Something went wrong.", title: kAlertTitle, controller: self)
          }
       )
    }
}
extension leavePropertyDetailsVC{
    func RejectRequestAPI(){
        
        print(propertyid)
        print(objAppShareData.UserDetail.strUserID)
        
        SVProgressHUD.show()
        let param = [WsParam.status:reject,
                     WsParam.tenant_id:String(tenantid)] as [String : Any]
        print(param)
        objWebServiceManager.requestDelete(strURL: WsUrl.cancelRequestTenant+String(propertyid)+"/request-cancel", params: param as [String : AnyObject], queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            
            let message = response["message"] as? String ?? ""
            let status = response["status"] as? String ?? ""
            let datafound = Int(response["data_found"] as? String ?? "") ?? 0
            //self.totalRecords = Int(response["total_records"] as? String ?? "") ?? 0
            print(datafound)
            
            if   status == "success" {
                SVProgressHUD.dismiss()
                self.navigationController?.popViewController(animated: true)
                if (response["data"]as? [String:Any]) != nil{
                }
            }else{
                objWebServiceManager.hideIndicator()
                if message == "k_sessionExpire"{
                    objAlert.showAlert(message: k_sessionExpire, title: kAlertTitle, controller: self)
                    objAppDelegate.showLogInNavigation()
                    objAppShareData.resetDefaultsAlluserInfo()
                    
                }  else{
                    objAlert.showAlert(message:message, title: kAlertTitle, controller: self)
                }
                
            }
        }, failure:  {(error) in
            print(error)
            SVProgressHUD.dismiss()
            objAlert.showAlert(message: "Something went wrong.", title: kAlertTitle, controller: self)
        }
        )
    }
}
