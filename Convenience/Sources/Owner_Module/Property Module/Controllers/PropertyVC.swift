//
//  PropertyVC.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 21/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

var isCommingFrom = false
var isnocard = false 
var iscame = false


class PropertyVC: UIViewController {
    
    //MARK: Variables-
    //  var arrProperty = [PropertyModel]()
    var arrPendingList = [PropertyModel]()
    var arrConfirmList = [PropertyModel]()
    var arrotherList = [PropertyModel]()
    
    // var arrPropertySection1 = [PropertyModel]()
    
    @IBOutlet weak var lblProfileName: UILabel!
    //MARK: IBOutlet-
    @IBOutlet weak var viewAlertHeader: UIView!
    @IBOutlet weak var viewLeaveAlertContainer: UIView!
    @IBOutlet weak var viewLeaveAlert: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var viewimg: UIView!
    @IBOutlet weak var imgprofile: UIImageView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var viewNoDataFound: UIView!
    
    
    
    
    var strSearchText = ""
    var nodata = ""
    
    var titleString = [0 : "Pending ", 1 : "Confirmed", 2 : "Other"]
    
    
    //MARK: AppLifeCycle-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(iscame)
         iscame = false

        self.tableview.tableFooterView = UIView()
        self.Uidesign()
        self.viewLeaveAlert.isHidden = true
        self.viewNoDataFound.isHidden = true
     
        if objAppShareData.isFromNotification{
             if objAppShareData.strNotificationType == "property_request" || objAppShareData.strNotificationType == "tenant_property_leave"{
               let vc = UIStoryboard.init(name: "Property", bundle: Bundle.main).instantiateViewController(withIdentifier: "LeaveTanantProppertyVC") as? LeaveTanantProppertyVC
                var property_id = 0
                if let id = objAppShareData.notificationDict["property_id"] as? Int{
                    property_id = id
                }else if let id = objAppShareData.notificationDict["property_id"] as? String{
                    property_id = Int(id)!
                }
               vc?.objProperty.propertyID = property_id
               self.navigationController?.pushViewController(vc!, animated: false)
            }
            objAppShareData.isFromNotification = false
            objAppShareData.strNotificationType = ""
            objAppShareData.notificationDict = [:]
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         iscame = false
             self.lblProfileName.text = "\(objAppShareData.UserDetail.strFirstName) \(objAppShareData.UserDetail.strLastName)"
             let strimage = objAppShareData.UserDetail.strProfilePicture
             let urlImg = URL(string: strimage)
             self.imgprofile.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "profile_ico"))
        self.callWebServiceForPropertyList()
        
        //  self.callWebServiceForPropertyList()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBAction func btnAddProperty(_ sender: Any) {
        isCommingFrom = true
        iscame = true
        
        let storyBoard = UIStoryboard(name: "OwnerTabBar", bundle:nil)
        let AddPropertyVC = storyBoard.instantiateViewController(withIdentifier: "AddPropertyVC") as! AddPropertyVC
        self.navigationController?.pushViewController(AddPropertyVC, animated: true)
    }
    
    
    @IBAction func btnLeaveNo(_ sender: Any) {
        self.viewLeaveAlert.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        
        self.btnNo.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.231372549, blue: 0.3568627451, alpha: 1)
        self.btnNo.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        self.btnOK.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        self.btnOK.backgroundColor = .clear
    }
    
    
    @IBAction func btnLeaveYes(_ sender: Any) {
        
        self.btnOK.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.231372549, blue: 0.3568627451, alpha: 1)
        self.btnOK.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        self.btnNo.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        self.btnNo.backgroundColor = .clear
        
        let storyBoard = UIStoryboard(name: "Property", bundle:nil)
        let AddPropertyVC = storyBoard.instantiateViewController(withIdentifier: "LeaveTanantProppertyVC") as! LeaveTanantProppertyVC
        self.navigationController?.pushViewController(AddPropertyVC, animated: true)
        self.viewLeaveAlert.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: Local function-
    func Uidesign(){
        self.imgprofile.setImgCircle()
        self.viewimg.setviewCirclewhite()
        self.viewimg.setshadowViewCircle()
        self.view1.setViewRadius()
        self.view1.setshadowView()
        self.btnOK.btnRadNonCol20()
        self.viewAlertHeader.setViewRadius10()
        self.viewLeaveAlertContainer.setViewRadius10()
        self.viewLeaveAlertContainer.setshadowViewCircle()
        
    }
}


//MARK: UITableViewDataSource,UITableViewDelegate-

extension PropertyVC: UITableViewDataSource,UITableViewDelegate{
    
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //
    //        return 2
    //    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0
        {
            return arrPendingList.count
        }else if section == 1 {
            return arrConfirmList.count
        }
        else  {
            return arrotherList.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyStatusCell", for: indexPath) as? PropertyStatusCell
            let obj = arrPendingList[indexPath.row]
            cell?.lblPropertyName.text = obj.name ?? ""
            cell?.lblPropertyAddress.text = obj.address ?? ""
            let strimage = obj.image ?? ""
            let urlImg = URL(string: strimage)
            cell?.imgProperty.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "property-placeholder"))
            
            return cell!
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyStatusCell", for: indexPath) as? PropertyStatusCell
            let obj = arrConfirmList[indexPath.row]
            cell?.lblPropertyName.text = obj.name ?? ""
            cell?.lblPropertyAddress.text = obj.address ?? ""
            let strimage = obj.image
            let urlImg = URL(string: strimage)
            print(urlImg)
            cell?.imgProperty.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "property-placeholder"))
            return cell!
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyStatusCell", for: indexPath) as? PropertyStatusCell
            let obj = arrotherList[indexPath.row]
            cell?.lblPropertyName.text = obj.name ?? ""
            cell?.lblPropertyAddress.text = obj.address ?? ""
            let strimage = obj.image
            let urlImg = URL(string: strimage)
            print(urlImg)
            cell?.imgProperty.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "property-placeholder"))
            return cell!
            
        }
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
            
        }else if section == 2 {
            if arrotherList.count != 0 {
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
        }else if section == 2{
            if arrotherList.count != 0 {
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyStatusCell", for: indexPath) as? PropertyStatusCell
            let obj = arrPendingList[indexPath.row]
            let vc = UIStoryboard.init(name: "Property", bundle: Bundle.main).instantiateViewController(withIdentifier: "LeaveTanantProppertyVC") as? LeaveTanantProppertyVC
            
            vc?.objProperty.propertyID = obj.propertyID
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyStatusCell", for: indexPath) as? PropertyStatusCell
            let obj = arrConfirmList[indexPath.row]
            
            let vc = UIStoryboard.init(name: "Property", bundle: Bundle.main).instantiateViewController(withIdentifier: "LeaveTanantProppertyVC") as? LeaveTanantProppertyVC
            vc?.objProperty.propertyID = obj.propertyID
            
            
            self.navigationController?.pushViewController(vc!, animated: true)
        }else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyStatusCell", for: indexPath) as? PropertyStatusCell
            let obj = arrotherList[indexPath.row]
            
            let vc = UIStoryboard.init(name: "Property", bundle: Bundle.main).instantiateViewController(withIdentifier: "LeaveTanantProppertyVC") as? LeaveTanantProppertyVC
            vc?.objProperty.propertyID = obj.propertyID
            self.navigationController?.pushViewController(vc!, animated: true)
            
            
        }
        //        let storyBoard = UIStoryboard(name: "Property", bundle:nil)
        //        let AddPropertyVC = storyBoard.instantiateViewController(withIdentifier: "LeaveTanantProppertyVC") as! LeaveTanantProppertyVC
        //        self.navigationController?.pushViewController(AddPropertyVC, animated: true)
    }
    
}

extension PropertyVC{
    func callWebServiceForPropertyList(){
        SVProgressHUD.show()
        self.arrConfirmList.removeAll()
        self.arrotherList.removeAll()
        self.arrPendingList.removeAll()
//        let param = [WsParam.user:objAppSharedata.UserDetail.strUserType] as [String : Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.PropertyList+"for="+String(objAppSharedata.UserDetail.strUserType), params:[:], queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            SVProgressHUD.dismiss()
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
            if status == "success"{
                let data = response["data"] as? [String:Any] ?? [:]
                self.nodata = data["property_list"] as? String ?? ""
                let propertyList = data["property_list"] as? [String:Any] ?? [:]
                
                if self.nodata == "Data not found"{
                    self.viewNoDataFound.isHidden = false
                }else {
                    
                    if let arrproperty = data["property_list"]as? [String:Any]{
                        if let arrpending = arrproperty["pending"]as? [[String:Any]]{
                            
                            
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
                        if let arrother = arrproperty["other"]as? [[String:Any]]{
                            for dic in arrother{
                                let obj = PropertyModel.init(dict: dic)
                                self.arrotherList.append(obj)
                                print(obj)
                            }
                        }
                        if self.arrPendingList.count == 0 && self.arrConfirmList.count==0 && self.arrotherList.count == 0{
                            self.viewNoDataFound.isHidden = false
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
                       
                       //    objIndicator.stopActivityIndicator()
                       objAlert.showAlert(message: "Something went wrong.", title: "Alert", controller: self)
        }
    }
}

