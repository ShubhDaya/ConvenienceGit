//
//  PropertyTanVC.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 24/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import SVProgressHUD

var dueAllClearBox = ""
var iscome = false

class PropertyTanVC: UIViewController {
    //MARK: Variables-
    
    var arrPendingList = [PropertyModel]()
    var arrConfirmList = [PropertyModel]()
    var btnClearAllDueCheck_Box = false
    var btnCancelPendingProDueCheck_Box = false

    var nodata = ""
    var reject = "cancel"
    var tenant_id = 0
    var propertyid = 0
    
    var isCancelProperty = ""
    
    
    //MARK: IBOutlet-
   
    
    @IBOutlet weak var imgCancelProCheck: UIImageView!
    
    @IBOutlet weak var viewNoDataFound: UIView!
    
    @IBOutlet weak var imgCheckBox: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var viewDueAlert: UIView!
    @IBOutlet weak var viewHeaderAlert: UIView!
    @IBOutlet weak var viewHeaderDue: UIView!
    
    @IBOutlet weak var viewAlert: UIView!
    @IBOutlet weak var btnCancelAlertNo: UIButton!
    @IBOutlet weak var btnCancelAlertYes: UIButton!
    
    @IBOutlet weak var btnProceedDue: customButton!
    @IBOutlet weak var btnCancelDueAlert: customButton!
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var viewimg: UIView!
    @IBOutlet weak var imgprofile: UIImageView!
    @IBOutlet weak var view1: UIView!
    
    @IBOutlet weak var viewCancelAlert: UIView!
    // @IBOutlet weak var viewCancelContainer: UIView!
    
    var titleString = [0 : "Pending ", 1 : "Confirmed"]
    
    
    //MARK: AppLifeCycle-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isCommingFrom = false

        self.tableview.tableFooterView = UIView()
        self.viewNoDataFound.isHidden = true
        self.viewAlert.isHidden = true
        
        self.viewDueAlert.isHidden = true
        self.btnClearAllDueCheck_Box = false
        self.btnCancelPendingProDueCheck_Box = false

       
        self.Uidesign()
    
        if objAppShareData.isFromNotification{
            if objAppShareData.strNotificationType == "property_request_accept" || objAppShareData.strNotificationType == "property_request_declined" || objAppShareData.strNotificationType == "owner_property_leave"{
            let vc = UIStoryboard.init(name: "PropertyTenTab", bundle: Bundle.main).instantiateViewController(withIdentifier: "leavePropertyDetailsVC") as? leavePropertyDetailsVC
                var property_id = 0
                vc?.ObjAlertClassData.strType = objAppShareData.strNotificationType
                if let id = objAppShareData.notificationDict["property_id"] as? Int{
                    property_id = id
                }else if let id = objAppShareData.notificationDict["property_id"] as? String{
                    property_id = Int(id)!
                }
                vc?.objProperty.propertyID = property_id
                if objAppShareData.strNotificationType == "property_request_accept"{
                    vc?.object.status = 2
                }
                self.navigationController?.pushViewController(vc!, animated: false)
            }
            objAppShareData.isFromNotification = false
            objAppShareData.strNotificationType = ""
            objAppShareData.notificationDict = [:]
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isCommingFrom = false

        self.imgCheckBox.isHidden = true
        self.imgCancelProCheck.isHidden = true

        self.lblUserName.text = "\(objAppShareData.UserDetail.strFirstName) \(objAppShareData.UserDetail.strLastName)"
               
               let strimage = objAppShareData.UserDetail.strProfilePicture
               let urlImg = URL(string: strimage)
               self.imgprofile.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "profile_ico"))
        
        self.callWebServiceForPropertyList()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBAction func btnAddProperty(_ sender: Any) {
        isCommingFrom = true
        iscome = true
        
        
        let storyBoard = UIStoryboard(name: "Tanentside", bundle:nil)
        let AddPropertyVC = storyBoard.instantiateViewController(withIdentifier: "GrabBetterPropertyVC") as! GrabBetterPropertyVC
        AddPropertyVC.isFromSignUp = false
        self.navigationController?.pushViewController(AddPropertyVC, animated: true)
    }
    
    @IBAction func btncheckboxdue(_ sender: Any) {
        
        if (btnClearAllDueCheck_Box == true)
        {
            self.tabBarController?.tabBar.isHidden = true
            self.imgCheckBox.isHidden = false
            self.btnClearAllDueCheck_Box = false;
            self.btnProceedDue.backgroundColor = #colorLiteral(red: 0.2823529412, green: 0.3607843137, blue: 0.9607843137, alpha: 1)
            self.btnProceedDue.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            btnProceedDue.layer.cornerRadius = 20
            dueAllClearBox = "1"
        }
        else
        {
            self.tabBarController?.tabBar.isHidden = true
            self.imgCheckBox.isHidden = true
            self.btnClearAllDueCheck_Box = true;
            self.btnProceedDue.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.btnProceedDue.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
            btnProceedDue.layer.cornerRadius = 20
            dueAllClearBox = ""
        }
    }
    
    
    @IBAction func btnCancelProcheckboxdue(_ sender: Any) {
        
        if (btnCancelPendingProDueCheck_Box == true)
        {
            self.tabBarController?.tabBar.isHidden = true
            self.imgCancelProCheck.isHidden = false
            self.btnCancelPendingProDueCheck_Box = false;
            self.btnCancelAlertYes.backgroundColor = #colorLiteral(red: 0.2823529412, green: 0.3607843137, blue: 0.9607843137, alpha: 1)
            self.btnCancelAlertYes.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            btnCancelAlertYes.layer.cornerRadius = 20
             isCancelProperty = "1"

        }
        else
        {
            self.tabBarController?.tabBar.isHidden = true
            self.imgCancelProCheck.isHidden = true
            self.btnCancelPendingProDueCheck_Box = true;
            self.btnCancelAlertYes.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.btnCancelAlertYes.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
            btnCancelAlertYes.layer.cornerRadius = 20
            isCancelProperty = ""
 
        }
    }
  
  
    
    
    @IBAction func btnProccedDueAlert(_ sender: Any) {
        if    self.imgCheckBox.isHidden == false{
            
            self.tabBarController?.tabBar.isHidden = false
                 self.viewAlert.isHidden = true
                 self.imgCheckBox.isHidden = true
                 self.btnProceedDue.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                 self.btnProceedDue.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                 self.LeaveRequestAPI()

        }else{
            self.tabBarController?.tabBar.isHidden = false
                   self.viewAlert.isHidden = true
                   self.imgCheckBox.isHidden = true
                   self.btnProceedDue.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                   self.btnProceedDue.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                   self.btnProceedDue.layer.cornerRadius = 20
                   self.btnProceedDue.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)


        }
    }

    @IBAction func btnCancelDueAlert(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = false
        self.viewAlert.isHidden = true
        self.imgCheckBox.isHidden = true
        self.btnProceedDue.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.btnProceedDue.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
        self.btnProceedDue.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.btnProceedDue.layer.cornerRadius = 20
    }
    
    @IBAction func btnCancelNO(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = false
        self.viewAlert.isHidden = true
        self.imgCancelProCheck.isHidden = true
        self.btnCancelAlertNo.layer.cornerRadius = 20
        self.btnCancelAlertYes.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
        self.btnCancelAlertYes.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.btnCancelAlertYes.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
    }
    
    @IBAction func btnCancelYes(_ sender: Any) {
      
        
        if    self.imgCancelProCheck.isHidden == false{
            
            self.tabBarController?.tabBar.isHidden = false
            self.btnCancelAlertYes.layer.cornerRadius = 20
            self.imgCancelProCheck.isHidden = true
            self.btnCancelAlertNo.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
            self.btnCancelAlertNo.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            self.btnCancelAlertNo.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.btnCancelAlertYes.tintColor = #colorLiteral(red: 0.2823529412, green: 0.3607843137, blue: 0.9607843137, alpha: 1)
            self.viewAlert.isHidden = true
            self.RejectRequestAPI()

        }else{
            self.tabBarController?.tabBar.isHidden = false
            self.btnCancelAlertYes.layer.cornerRadius = 20
            self.imgCancelProCheck.isHidden = true
            self.btnCancelAlertNo.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
            self.btnCancelAlertNo.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            self.btnCancelAlertNo.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.btnCancelAlertYes.tintColor = #colorLiteral(red: 0.2823529412, green: 0.3607843137, blue: 0.9607843137, alpha: 1)
            self.viewAlert.isHidden = true

        }

        
        
    }
    
    //MARK: Local function-
    func Uidesign(){
        self.imgprofile.setImgCircle()
        self.viewimg.setviewCirclewhite()
        self.viewimg.setshadowViewCircle()
        self.view1.setViewRadius()
        self.view1.setshadowView()
        
        self.btnCancelAlertYes.btnRadNonCol20()
        self.btnCancelAlertNo.btnRadNonCol20()
        
        self.viewHeaderAlert.setViewRadius10()
        self.viewHeaderDue.setViewRadius10()
        self.viewCancelAlert.setViewCornerRadius()
        self.viewDueAlert.setViewCornerRadius()
        self.btnProceedDue.btnRadNonCol20()
        self.btnCancelDueAlert.btnRadNonCol20()
 
    }
}



//MARK: UITableViewDataSource,UITableViewDelegate-

extension PropertyTanVC: UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0
        {
            return arrPendingList.count
        }else {
            return arrConfirmList.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyPropertyCell", for: indexPath) as? MyPropertyCell
            let obj = arrPendingList[indexPath.row]
            cell?.lblPropertyName.text = obj.name ?? ""
            cell?.lblPropertyAddress.text = obj.address ?? ""
            let strimage = obj.image ?? ""
            // propertyid = obj.propertyID
            let urlImg = URL(string: strimage)
            cell?.btnLeave.isHidden = true
            cell?.btnProCancel.isHidden = false
            
            cell?.btnProCancel.tag = indexPath.row
            cell?.imgMyProperty.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "property-placeholder"))
            cell?.btnProCancel.addTarget(self,action:#selector(cancelbtnclicked(sender:)), for: .touchUpInside)
            
            
            return cell!
        }
        else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyPropertyCell", for: indexPath) as? MyPropertyCell
            let obj = arrConfirmList[indexPath.row]
            cell?.lblPropertyName.text = obj.name ?? ""
            cell?.lblPropertyAddress.text = obj.address ?? ""
            let strimage = obj.image
            //tenant_id = obj.user_id ?? 0
            // propertyid = obj.propertyID ?? 0
            
            let urlImg = URL(string: strimage)
            print(urlImg)
            cell?.btnProCancel.isHidden = true
            cell?.btnLeave.isHidden = false
            
            cell?.imgMyProperty.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "property-placeholder"))
            cell?.btnLeave.tag = indexPath.row
            cell?.btnLeave.addTarget(self,action:#selector(buttonleave), for: .touchUpInside)
            
            return cell!
        }
    }
    @objc func buttonleave(sender:UIButton) {
        let obj = self.arrConfirmList[sender.tag]
        
        print(obj.propertyID)
        propertyid = obj.propertyID
        self.tabBarController?.tabBar.isHidden = true
        
        self.viewAlert.isHidden = false
        self.viewDueAlert.isHidden = false
        self.viewCancelAlert.isHidden = true
      //  self.LeaveRequestAPI()
        
    }
    
    @objc func cancelbtnclicked(sender : UIButton!) {
        //self.viewAlert.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.viewDueAlert.isHidden = true
        self.viewAlert.isHidden = false
        self.viewCancelAlert.isHidden = false
        
        
        let obj = self.arrPendingList[sender.tag]
        
        // self.viewDueAlert.isHidden = false
        
        print(obj.propertyID)
        
        propertyid = obj.propertyID
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            if arrPendingList.count != 0 {
                return 25
            }else {
                return 10
            }
            
        }else if section == 1 {
            if arrConfirmList.count != 0 {
                return 25
            }else {
                return 10
            }
            
        }
        return 25
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 35))
        let sectionName = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.frame.size.width, height: 25))
        
        if section == 0 {
            if arrPendingList.count != 0{
                sectionName.text = titleString[section]
            }else {
                sectionName.text = ""
                
            }
            
        }else if section == 1{
            if arrConfirmList.count != 0{
                sectionName.text = titleString[section]
            }else {
                sectionName.text = ""
                
            }
        }
        sectionName.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        sectionName.font = UIFont(name: "DroidSerif", size: 16)!
        sectionName.textAlignment = .left
        sectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        sectionView.addSubview(sectionName)
        return sectionView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyPropertyCell", for: indexPath) as? MyPropertyCell
            let obj = arrPendingList[indexPath.row]
            let status = obj.status
            
            let vc = UIStoryboard.init(name: "PropertyTenTab", bundle: Bundle.main).instantiateViewController(withIdentifier: "leavePropertyDetailsVC") as? leavePropertyDetailsVC
            
            vc?.objProperty.propertyID = obj.propertyID
            vc?.object.status = obj.status
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyPropertyCell", for: indexPath) as? MyPropertyCell
            let obj = arrConfirmList[indexPath.row]
            
            let vc = UIStoryboard.init(name: "PropertyTenTab", bundle: Bundle.main).instantiateViewController(withIdentifier: "leavePropertyDetailsVC") as? leavePropertyDetailsVC
            vc?.objProperty.propertyID = obj.propertyID
            vc?.object.status = obj.status
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}
extension PropertyTanVC{
    func callWebServiceForPropertyList(){
        SVProgressHUD.show()
        self.arrConfirmList.removeAll()
        self.arrPendingList.removeAll()
//        let param = [WsParam.user:objAppSharedata.UserDetail.strUserType] as [String : Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.PropertyList+"for="+String(objAppSharedata.UserDetail.strUserType), params:[:], queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            SVProgressHUD.dismiss()
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
           // let datafound = response["data_found"] as? String ?? ""
            //let dataFound = response["data_found"] as? Int ?? 0
            
            if status == "success"{
                SVProgressHUD.dismiss()

                let data = response["data"] as? [String:Any] ?? [:]
               // let dataFound = data[""]
                let dataFound = data["data_found"] as? Int ?? 0

                let propertyList = data["property_list"] as? [String:Any] ?? [:]
                
                if dataFound == 0{
                    self.viewNoDataFound.isHidden = false
                }else {
                    if let arrproperty = data["property_list"]as? [String:Any]{
                        if let arrpending = arrproperty["pending"]as? [[String:Any]]
                        {

                            for dic in arrpending{
                                let obj = PropertyModel.init(dict: dic)
                                self.arrPendingList.append(obj)
                                print(obj)
                            }
                        }
                        if let arrconfirm = arrproperty["confirmed"]as? [[String:Any]]{
                            for dic in arrconfirm{
                                let obj = PropertyModel.init(dict: dic)
                                self.arrConfirmList.append(obj)
                                print(obj)
                            }
                        }
                        
                        if self.arrPendingList.count == 0 && self.arrConfirmList.count==0  {
                            if dataFound == 0{
                                self.viewNoDataFound.isHidden = false

                            }
                        }else{
                             self.viewNoDataFound.isHidden = true
                        }
                        print(self.arrPendingList.count)
                        print(self.arrConfirmList.count)
                        
                        print(self.arrPendingList)
                        
                        
                        self.tableview.reloadData()
                    }else {
                        
                        SVProgressHUD.dismiss()
                        
                    }
                    
                }
                
            }
            
            else{
                                  if self.nodata ==  "Data not found"{
                                                    self.viewNoDataFound.isHidden = false
                                                }
                                                
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
            SVProgressHUD.dismiss()
                       objAlert.showAlert(message: "Something went wrong.", title: kAlertTitle, controller: self)
            print(error)
        }
    }
}
extension PropertyTanVC{
    func RejectRequestAPI(){
        
        print(propertyid)
        print(objAppShareData.UserDetail.strUserID)
        
        SVProgressHUD.show()
        let param = [WsParam.status:reject,
                     WsParam.tenant_id:objAppShareData.UserDetail.strUserID] as [String : Any]
        
        objWebServiceManager.requestDelete(strURL: WsUrl.cancelRequestTenant+String(propertyid)+"/request-cancel", params: param as [String : AnyObject], queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            
            let message = response["message"] as? String ?? ""
            let status = response["status"] as? String ?? ""
            let datafound = Int(response["data_found"] as? String ?? "") ?? 0
            //self.totalRecords = Int(response["total_records"] as? String ?? "") ?? 0
            print(datafound)
            
            if   status == "success" {
                SVProgressHUD.dismiss()
                self.callWebServiceForPropertyList()
                self.tableview.reloadData()
                if let data = response["data"]as? [String:Any]{
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

extension PropertyTanVC{
    func LeaveRequestAPI(){
        SVProgressHUD.show()
        let id = objAppShareData.UserDetail.strUserID
        print(id)
        print(propertyid)
        objWebServiceManager.requestDelete(strURL: WsUrl.leaveproprtyOwner+String(propertyid)+"/leave/"+String(objAppShareData.UserDetail.strUserID), params: [:], queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            
            let message = response["message"] as? String ?? ""
            let status = response["status"] as? String ?? ""
            let datafound = Int(response["data_found"] as? String ?? "") ?? 0
            //self.totalRecords = Int(response["total_records"] as? String ?? "") ?? 0
            print(datafound)
            
            if   status == "success" {
                SVProgressHUD.dismiss()
                self.callWebServiceForPropertyList()
                if let data = response["data"]as? [String:Any]{
                }
            }else{
                SVProgressHUD.dismiss()

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
