//
//  AlertVC.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 21/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import SVProgressHUD
import Foundation

var isAlertId = false
var isAlertRedirection = false
var PropertyIdAlert = ""

class AlertVC: UIViewController {
    
    //MARK: Varibles-
    var strTime : String = ""
    var strDate : String = ""
    var strCurrentDate : String = ""
    var arrAlertList = [AlertModel]()
    var limit:Int=20
    var offset:Int=0
    var isdataLoading:Bool=false
    
    var totalRecords = Int()
    //MARK: Outlets-
    @IBOutlet weak var viewNoDataFound: UIView!
    
    @IBOutlet weak var viewimgProfile: UIView!
    @IBOutlet weak var imgOwnerOrTanant: UIImageView!
    @IBOutlet weak var lblOwnerTanantName: UILabel!
    @IBOutlet weak var view1: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    //MARK: AppLifeCycle-
    override func viewDidLoad() {
        super.viewDidLoad()
        isAlertId = false
        self.viewNoDataFound.isHidden = true
        print(arrAlertList.count)
        self.tableView.tableFooterView = UIView()
        self.UiDesign()
        
        if objAppShareData.isFromNotification{
            if objAppShareData.UserDetail.strUserType == "tenant"{
                if objAppShareData.strNotificationType == "payment_due" || objAppShareData.strNotificationType == "payment_marked_due"{
                let vc = UIStoryboard.init(name: "PaymentTanTab", bundle: Bundle.main).instantiateViewController(withIdentifier: "SendPaymentAlertVC") as? SendPaymentAlertVC
                var property_id = ""
                if let id = objAppShareData.notificationDict["property_id"] as? Int{
                    property_id = String(id)
                }else if let id = objAppShareData.notificationDict["property_id"] as? String{
                    property_id = id
                }
                vc?.PropertyId = property_id
                PropertyIdAlert = property_id
                if let is_payable = objAppShareData.notificationDict["is_payable"] as? String{
                    Ispayable = Int(is_payable)!
                }else if let id = objAppShareData.notificationDict["is_payable"] as? Int{
                    Ispayable = id
                }
                self.navigationController?.pushViewController(vc!, animated: false)
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isAlertId = false
        self.limit = 20
        self.offset = 0
        self.arrAlertList.removeAll()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.webServiceForAlertList()
        
        self.view1.setViewRadius()
        self.view1.setshadowView()
        self.lblOwnerTanantName.text = "\(objAppShareData.UserDetail.strFirstName) \(objAppShareData.UserDetail.strLastName)"
        let strimage = objAppShareData.UserDetail.strProfilePicture
        let urlImg = URL(string: strimage)
        print(urlImg)
        self.imgOwnerOrTanant.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "profile_ico"))
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //MARK:Local Methods -
    func UiDesign(){
        self.imgOwnerOrTanant.setImgCircle()
        self.viewimgProfile.setviewCirclewhite()
        self.viewimgProfile.setshadowViewCircle()
    }
}

//MARK: UITableViewDataSource,UITableViewDelegate-
extension AlertVC : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAlertList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlertCell", for: indexPath as IndexPath) as! AlertCell
        
        
        let obj = arrAlertList[indexPath.row]
        
        let strimage = obj.strProperty_image ?? ""
        let urlImg = URL(string: strimage)
        cell.imgOwnerProperty.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "property-placeholder"))
        cell.lblOwnerPropertyName.text = obj.strProperty_name
        let strCreatedDate = obj.strCreated_at
        
        cell.lblTimeOfStatus.text = self.CompareDate(strFirstDate:Date() , strSecondDate: strCreatedDate)
        
        var notificationType = obj.strType
        
        switch ( notificationType ) {
            
        case "payment_received":
            
            cell.lblOwnerPropertyStatus.text = "You just received a payment from \(obj.strSender_name) for \(obj.strProperty_name)";
            break;
            
        case "property_request":
            
            
            cell.lblOwnerPropertyStatus.text = "\(obj.strSender_name) sent a request for your \(obj.strProperty_name) property";
            break;
            
        case "payment_due_system":
            
            
            cell.lblOwnerPropertyStatus.text = "Payment for your \(obj.strProperty_name) property is due by \(obj.strSender_name) tenant";
            break;
            
        case "tenant_property_leave":
            
            
            cell.lblOwnerPropertyStatus.text = "\(obj.strSender_name) left your \(obj.strProperty_name) property";
            break;
            
        case "connect_account_verification_pending":
            cell.lblOwnerPropertyStatus.text = "Your account verification is pending. Complete your verification to receive funds in your bank account.";
            break;
            
        case "property_request_accept":
            
            
            cell.lblOwnerPropertyStatus.text = "\(obj.strSender_name) has accepted your request for \(obj.strProperty_name) property";
            break;
            
        case "property_request_declined":
            
            
            cell.lblOwnerPropertyStatus.text = "\(obj.strSender_name) has declined your request for \(obj.strProperty_name) property";
            break;
            
        case "owner_property_leave":
            cell.lblOwnerPropertyStatus.text = "\(obj.strSender_name) released you from \(obj.strProperty_name) property";
            break;
            
        case "payment_due":
            cell.lblOwnerPropertyStatus.text = "Your payment for \(obj.strProperty_name) property is due";
            break;
          
        case "payment_marked_due":
           cell.lblOwnerPropertyStatus.text = "Your payment for \(obj.strProperty_name) property is marked due by \(obj.strSender_name)";
            break;
        default:
            print("sdfsdfs")
        }
        print(arrAlertList.count)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        isAlertId = true
        isAlertRedirection = true 
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlertCell", for: indexPath) as? AlertCell
        let obj = arrAlertList[indexPath.row]
        var notificationType = obj.strType
        
        switch ( notificationType ) {
            
        case "payment_received":
            let obj = arrAlertList[indexPath.row]
             if objAppShareData.UserDetail.strUserType == "owner" {
             self.view.endEditing(true)
             let vc = UIStoryboard.init(name: "Tenant", bundle: nil).instantiateViewController(withIdentifier: "TenantPropertyDetail_VC")as! TenantPropertyDetail_VC
                vc.strUserId = obj.strSender_user_id
                vc.strPropertyID = obj.strPropertyID
                vc.strPropertyName = obj.strProperty_name
                vc.strPropertyAddress = obj.strProperty_location
                vc.strPropertyImage = obj.strProperty_image
                
            self.navigationController?.pushViewController(vc, animated: true)
            }
        break;
            
            
        case "connect_account_verification_pending":
            let obj = arrAlertList[indexPath.row]
            
            if objAppShareData.UserDetail.strUserType == "owner" {
                
                self.view.endEditing(true)
                let vc = UIStoryboard.init(name: "OwnerTabBar", bundle: nil).instantiateViewController(withIdentifier: "AddBankAccountVC")as! AddBankAccountVC
                vc.isOnboarding = "false"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            break;
            
            
            
        case "property_request":
            
            
            let obj = arrAlertList[indexPath.row]
            
            if objAppShareData.UserDetail.strUserType == "owner" {
                
                let vc = UIStoryboard.init(name: "Property", bundle: Bundle.main).instantiateViewController(withIdentifier: "LeaveTanantProppertyVC") as? LeaveTanantProppertyVC
                vc?.ObjAlertClassData.strRecipient_user_id = obj.strRecipient_user_id
                vc?.ObjAlertClassData.strPropertyID = obj.strPropertyID
                vc?.ObjAlertClassData.strType = obj.strType
                self.navigationController?.pushViewController(vc!, animated: true)
            }else {
                let vc = UIStoryboard.init(name: "PropertyTenTab", bundle: Bundle.main).instantiateViewController(withIdentifier: "leavePropertyDetailsVC") as? leavePropertyDetailsVC
                
                vc?.ObjAlertClassData.strPropertyID = obj.strPropertyID
                vc?.ObjAlertClassData.strType = obj.strType
                vc?.ObjAlertClassData.strRecipient_user_id = obj.strRecipient_user_id
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            break;
            
        case "payment_due_system":
            
            //self.navigatetoPropertyDetails()
             let obj = arrAlertList[indexPath.row]
             let objData = TenantListModel(dict: [:])
             objData.full_name = obj.strSender_name
             objData.user_id = obj.strSender_user_id
             objData.profile_picture = obj.strSender_user_avatar
              let vc = UIStoryboard.init(name: "Tenant", bundle: nil).instantiateViewController(withIdentifier: "TanantDetailsVC")as! TanantDetailsVC
                 vc.objData = objData
                 self.navigationController?.pushViewController(vc, animated: true)
            //objAlert.showAlert(message: kunderDevelopment, title: kAlertTitle, controller: self)
            break;
            
        case "tenant_property_leave":
            
            
            let obj = arrAlertList[indexPath.row]
            
            if objAppShareData.UserDetail.strUserType == "owner" {
                
                let vc = UIStoryboard.init(name: "Property", bundle: Bundle.main).instantiateViewController(withIdentifier: "LeaveTanantProppertyVC") as? LeaveTanantProppertyVC
                
                vc?.ObjAlertClassData.strPropertyID = obj.strPropertyID
                vc?.ObjAlertClassData.strType = obj.strType
                vc?.ObjAlertClassData.strRecipient_user_id = obj.strRecipient_user_id
                self.navigationController?.pushViewController(vc!, animated: true)
            }else {
                let vc = UIStoryboard.init(name: "PropertyTenTab", bundle: Bundle.main).instantiateViewController(withIdentifier: "leavePropertyDetailsVC") as? leavePropertyDetailsVC
                
                vc?.ObjAlertClassData.strPropertyID = obj.strPropertyID
                vc?.ObjAlertClassData.strType = obj.strType
                vc?.ObjAlertClassData.strRecipient_user_id = obj.strRecipient_user_id
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            break;
            
        case "property_request_accept":
            
            
            let obj = arrAlertList[indexPath.row]
            
            if objAppShareData.UserDetail.strUserType == "owner" {
                
                let vc = UIStoryboard.init(name: "Property", bundle: Bundle.main).instantiateViewController(withIdentifier: "LeaveTanantProppertyVC") as? LeaveTanantProppertyVC
                
                vc?.ObjAlertClassData.strPropertyID = obj.strPropertyID
                vc?.ObjAlertClassData.strType = obj.strType
                vc?.ObjAlertClassData.strRecipient_user_id = obj.strRecipient_user_id
                self.navigationController?.pushViewController(vc!, animated: true)
            }else {
                let vc = UIStoryboard.init(name: "PropertyTenTab", bundle: Bundle.main).instantiateViewController(withIdentifier: "leavePropertyDetailsVC") as? leavePropertyDetailsVC
                
                vc?.ObjAlertClassData.strPropertyID = obj.strPropertyID
                vc?.ObjAlertClassData.strType = obj.strType
                vc?.ObjAlertClassData.strRecipient_user_id = obj.strRecipient_user_id
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            break;
            
        case "property_request_declined":
            
            
            let obj = arrAlertList[indexPath.row]
            
            if objAppShareData.UserDetail.strUserType == "owner" {
                
                let vc = UIStoryboard.init(name: "Property", bundle: Bundle.main).instantiateViewController(withIdentifier: "LeaveTanantProppertyVC") as? LeaveTanantProppertyVC
                
                vc?.ObjAlertClassData.strPropertyID = obj.strPropertyID
                vc?.ObjAlertClassData.strType = obj.strType
                vc?.ObjAlertClassData.strRecipient_user_id = obj.strRecipient_user_id
                self.navigationController?.pushViewController(vc!, animated: true)
            }else {
                let vc = UIStoryboard.init(name: "PropertyTenTab", bundle: Bundle.main).instantiateViewController(withIdentifier: "leavePropertyDetailsVC") as? leavePropertyDetailsVC
                
                vc?.ObjAlertClassData.strPropertyID = obj.strPropertyID
                vc?.ObjAlertClassData.strType = obj.strType
                vc?.ObjAlertClassData.strRecipient_user_id = obj.strRecipient_user_id
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            break;
            
        case "owner_property_leave":
            let obj = arrAlertList[indexPath.row]
            
            if objAppShareData.UserDetail.strUserType == "owner" {
                
                let vc = UIStoryboard.init(name: "Property", bundle: Bundle.main).instantiateViewController(withIdentifier: "LeaveTanantProppertyVC") as? LeaveTanantProppertyVC
                
                vc?.ObjAlertClassData.strPropertyID = obj.strPropertyID
                vc?.ObjAlertClassData.strType = obj.strType
                vc?.ObjAlertClassData.strRecipient_user_id = obj.strRecipient_user_id
                self.navigationController?.pushViewController(vc!, animated: true)
            }else {
                let vc = UIStoryboard.init(name: "PropertyTenTab", bundle: Bundle.main).instantiateViewController(withIdentifier: "leavePropertyDetailsVC") as? leavePropertyDetailsVC
                
                vc?.ObjAlertClassData.strPropertyID = obj.strPropertyID
                vc?.ObjAlertClassData.strType = obj.strType
                vc?.ObjAlertClassData.strRecipient_user_id = obj.strRecipient_user_id
                
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            break;
            
        case "payment_due":
            
            if objAppShareData.UserDetail.strUserType == "tenant"{
               
                let vc = UIStoryboard.init(name: "PaymentTanTab", bundle: Bundle.main).instantiateViewController(withIdentifier: "SendPaymentAlertVC") as? SendPaymentAlertVC
                
                vc?.PropertyId = obj.strPropertyID
                PropertyIdAlert = obj.strPropertyID
                Ispayable  = Int(obj.stris_payable) ?? 22
                //vc?.ObjAlertClassData.strType = obj.strType
                //vc?.ObjAlertClassData.strRecipient_user_id = obj.strRecipient_user_id
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            break;
         
        case "payment_marked_due":
            if objAppShareData.UserDetail.strUserType == "tenant"{
                 let vc = UIStoryboard.init(name: "PaymentTanTab", bundle: Bundle.main).instantiateViewController(withIdentifier: "SendPaymentAlertVC") as? SendPaymentAlertVC
                 vc?.PropertyId = obj.strPropertyID
                 PropertyIdAlert = obj.strPropertyID
                 Ispayable  = Int(obj.stris_payable) ?? 22
                 self.navigationController?.pushViewController(vc!, animated: true)
             }
             break;
        default:
            print("sdfsdfs")
        }
    }
   
    //MARK: - Functions
    
    func convertDateFormater(_ date: String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date1 = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        //self.strDate = dateFormatter.(from: date!)
        return  date1 ?? Date()
        
    }
    
    func convertTimeFormater(_ time: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: time)!
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone.current
        let timeStamp = dateFormatter.string(from: date)
        self.strTime = dateFormatter.string(from: date)
        
        return timeStamp
    }
    
    
}
extension AlertVC{
    func webServiceForAlertList(){
        SVProgressHUD.show()
        
        //  self.arrTenantList.removeAll()
        objWebServiceManager.requestGet(strURL: WsUrl.ALertList+"limit="+String(self.limit)+"&offset="+String(self.offset), params:nil, queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
            if status == "success"{
                SVProgressHUD.dismiss()
                
                let data = response["data"] as? [String:Any] ?? [:]
                let datafound = Int(data["data_found"] as? String ?? "") ?? 0
                let userdata = data["data_found"] as? Int ?? 0
                self.totalRecords = data["total_records"] as? Int ?? 0
                self.tableView.isHidden = false
                if let data = response["data"]as? [String:Any]{

                    if let arrTenantList = data["alert_list"]as? [[String:Any]]{
                        for dic in arrTenantList{
                            let obj = AlertModel.init(dict: dic)
                            self.arrAlertList.append(obj)
                            print(obj)
                        }
                    }
                    else{
                        self.tableView.reloadData()
                    }
                    self.arrAlertList = self.arrAlertList.sorted(by: { (obj1, obj2) -> Bool in
                        let obj1 = obj1.strCreated_at
                        let obj2 = obj2.strCreated_at
                        return (obj1.localizedCaseInsensitiveCompare(obj2) == .orderedDescending)
                    })
                    self.tableView.reloadData()
                    
                }
                SVProgressHUD.dismiss()
                if datafound == 0{
                    if self.arrAlertList.count == 0{
                        self.viewNoDataFound.isHidden = false
                    }else{
                        self.viewNoDataFound.isHidden = true
                    }
                }else{
                    self.viewNoDataFound.isHidden = true
                }
                self.tableView.reloadData()
            }else{
                self.arrAlertList.removeAll()
                self.limit = 20
                self.offset = 0
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
            //    objIndicator.stopActivityIndicator()
            objAlert.showAlert(message: "Something went wrong.", title: "Alert", controller: self)
        }
    }
}




//MARK:- Paggination Logic
extension AlertVC{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isdataLoading = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < 0 {
            print("up")
        }else{
            if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height)
            {
                if !isdataLoading{
                    isdataLoading = true
                    
                    self.offset = self.offset+self.limit
                    
                    if arrAlertList.count != totalRecords {
                        webServiceForAlertList()
                    }else {
                        print("All records fetched")
                    }
                }
            }
        }
    }
}

extension AlertVC{
    
    
    func CompareDate (strFirstDate:Date, strSecondDate:String) -> String
    {//"14/01/2020"   "2020-01-13 14:23:09 PM"
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        df.locale =  NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        
        // SecondDateString = strSecondDate
        
        //df.locale =  NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        df.dateFormat = "dd/MM/yyyy"
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: strSecondDate)!
        let dateCurrent = Date()
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date123 = calendar.startOfDay(for: date)
        let date223 = calendar.startOfDay(for: dateCurrent)
        
        let components = calendar.dateComponents([.day], from: date123, to: date223)
        
        dateFormatter.dateFormat = "MMMM d, yyyy"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale // reset the locale
        let dateString = dateFormatter.string(from: date)
        
        let dateFormatterNew = DateFormatter()
        dateFormatterNew.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatterNew.dateFormat = "MMMM d, yyyy"
        self.strDate = dateFormatterNew.string(from: date)
        
        print("EXACT_DATE : \(dateString)")
        
        var strFinal = ""
        let arr = strSecondDate.components(separatedBy: " ")
        let strTime = arr[1]
        let strTime1 = self.convertTimeFormater(strTime)
        if components.day == 0{
            strFinal = "Today " + strTime1
        }else if components.day == 1{
            strFinal = "Yesterday " + strTime1
        }else{
            strFinal = "\(self.strDate) " + strTime1
        }
        return strFinal
    }
    
    
    
    
    func relativePast(for date : Date,currentDate : Date) -> String {
        
        let units = Set<Calendar.Component>([.day, .hour, .minute, .second])
        let components = Calendar.current.dateComponents(units, from: date, to: currentDate)
        
        if (components.day! > 0) {
            return (components.day! > 1 ? "\(components.day!) days ago" : "Yesterday")
            
        } else if components.hour! > 0 {
            return "\(components.hour!) " + (components.hour! > 1 ? "hours ago" : "hour ago")
            
        } else if components.minute! > 0 {
            print("\(components.minute!) " + (components.minute! > 1 ? "minutes ago" : "minute ago"))
            return "\(components.minute!) " + (components.minute! > 1 ? "minutes ago" : "minute ago")
            
        } else {
            return "\(components.second!) " + (components.second! > 1 ? "seconds ago" : "second ago")
        }
    }
}

