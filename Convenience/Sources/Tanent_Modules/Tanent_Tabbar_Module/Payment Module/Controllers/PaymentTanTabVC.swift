//
//  PaymentTanTabVC.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 24/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import SVProgressHUD

var PropertyID = ""
var month = ""
var Year = ""
var DefaultCardId = ""
var isNocardForPayment = false
var  Ispayable = 2


class PaymentTanTabVC: UIViewController {
    
    var limit:Int=10
    var offset:Int=0
    var isdataLoading:Bool=false
    var totalRecords = Int()
    var isdeselect = false
    var isrowselected = false
    var varname = ""
    var arCardList = [CardListModel]()
    
    
    @IBOutlet weak var viewNodata: UIView!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var tblmonthheightcon: NSLayoutConstraint!
    @IBOutlet weak var viewmonthCorner: UIView!
    @IBOutlet weak var viewSelectMonth: UIView!
    @IBOutlet weak var viewProfileImg: UIView!
    @IBOutlet weak var lblTenantName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var viewNoDataFound: UIView!
    @IBOutlet weak var viewAlert: UIView!
    @IBOutlet weak var viewAlertContsiner: UIView!
    @IBOutlet weak var viewAlertHeader: UIView!
    @IBOutlet weak var btnOk: customButton!
    @IBOutlet weak var ViewConfirmAlert: UIView!
    @IBOutlet weak var viewConfiermHeader: UIView!
    @IBOutlet weak var btnCancel: customButton!
    @IBOutlet weak var btnDone: customButton!
    @IBOutlet weak var tblPendinglist: UITableView!
    @IBOutlet weak var tblView: UITableView!
    
    
    var arrpendingmonth = [PaymentModel]()
    var arrConfirmlist = [PropertyModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.dataSource = self
        tblView.delegate = self
        tblPendinglist.dataSource = self
        tblPendinglist.delegate = self
        self.tblView.tableFooterView = UIView()
        self.tblPendinglist.tableFooterView = UIView()
        self.viewAlert.isHidden = true
        self.viewSelectMonth.isHidden = true
        self.viewNoDataFound.isHidden = true
        self.tblView.reloadData()
        self.tblPendinglist.reloadData()
        UiDesign()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.limit = 10
        self.offset = 0
        self.arrConfirmlist.removeAll()
        
        print("\(defaultCardId)")
        
        
        if isNocardForPayment == true{
            callWSForGetCardList()
            
            if defaultCardId == ""{
                print("card id nil ********\(defaultCardId)")
                
            }else {
                if PropertyID != ""  || month != ""{
                    webServiceMakePayment()
                }else {
                    callWebServiceForPropertyList()
                }
            }
        }else{
            callWebServiceForPropertyList()
        }
        
        self.lblTenantName.text = "\(objAppShareData.UserDetail.strFirstName) \(objAppShareData.UserDetail.strLastName)"
        let strimage = objAppShareData.UserDetail.strProfilePicture
        let urlImg = URL(string: strimage)
        self.imgProfile.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "profile_ico"))
        //IntDefaultCardId = Int(DefaultCardId) ?? 0
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBAction func btnClosePendingListview(_ sender: Any) {
        self.viewSelectMonth.isHidden = true
    }
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOk(_ sender: Any) {
        self.viewAlert.isHidden = true
        self.RedirectToMakePayment()

    }
    
    @IBAction func btnMakePayment(_ sender: Any) {
        
        
        
        if month == ""{
            print("id nil please select property ")
            objAlert.showAlert(message: "You don't select month yet please select month", title: kAlertTitle, controller: self)
        }else {
            self.viewSelectMonth.isHidden = true
            self.viewAlert.isHidden = false
            self.ViewConfirmAlert.isHidden = false
            self.viewAlertContsiner.isHidden = true
        }
    }
    
    
    @IBAction func btnContinue(_ sender: Any) {
        if PropertyID == ""{
            print("id nil please select property ")
            objAlert.showAlert(message: "You don't select property yet please select property", title: kAlertTitle, controller: self)
        }else {
            if Ispayable == 1 {
                self.viewSelectMonth.isHidden = false
                self.GetmonthList()
                      }else {
                objAlert.showAlert(message: "You can not proceed with payment because owner's billing account setup is not correct, Please contact property owner.", title: kAlertTitle, controller: self)
                   PropertyID = ""
                self.tblView.reloadData()
            }
        }
    }
    
    @IBAction func btnCancelConALert(_ sender: Any) {
        self.viewAlert.isHidden = true
    PropertyID = ""
    month = ""
        self.tblView.reloadData()
        self.tblPendinglist.reloadData()
    }
    
    @IBAction func btnDoneConLAlert(_ sender: Any) {
    self.callWSForGetCardList()
    }
    
    
    
    //MARK: Local Methods -
    
    func UiDesign(){
        self.imgProfile.setImgCircle()
        self.viewProfileImg.setviewCirclewhite()
        self.viewProfileImg.setshadowViewCircle()
        self.viewContent.setViewRadius()
        self.btnOk.setradiusbtn()
        self.viewAlertHeader.setViewRadius10()
        self.viewAlertContsiner.setViewCornerRadius()
        self.viewAlertContsiner.setShadowAllView10()
        self.viewConfiermHeader.setViewRadius10()
        self.ViewConfirmAlert.setViewCornerRadius()
        self.ViewConfirmAlert.setShadowAllView10()
        self.viewmonthCorner.setViewRadius10()
    }
}
extension PaymentTanTabVC : UITableViewDataSource,UITableViewDelegate{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == tblView
        {
            return  arrConfirmlist.count
        }
        else
        {
            self.tblmonthheightcon.constant = CGFloat(arrpendingmonth.count * 48)
            
            return  arrpendingmonth.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblView
        {
            let cell = tblView.dequeueReusableCell(withIdentifier: "PaymentCell")  as! PaymentCell
            let obj = arrConfirmlist[indexPath.row]
            cell.lblPropertyName.text? = obj.name ?? ""
            cell.lblPropertyAddress.text? = obj.address ?? ""
            let strimage = obj.image
            let urlImg = URL(string: strimage)
            cell.imgproperty.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "property-placeholder"))
            
            if PropertyID == String(obj.propertyID) {
                cell.imgSelectedCell.image = #imageLiteral(resourceName: "select_ico")
            }else if PropertyID == ""{
                cell.imgSelectedCell.image = nil
            }else {
                cell.imgSelectedCell.image = nil
            }
            return cell
            tblView.reloadData()
        }
        else
        {
            let cellTwo = tblPendinglist.dequeueReusableCell(withIdentifier: "PendingMonthCell")  as! PendingMonthCell
            let obj = arrpendingmonth[indexPath.row]
            cellTwo.lblPendingMonth.text = obj.strtext
            if month == obj.strmonth{
                cellTwo.imgSelection.image = #imageLiteral(resourceName: "ico_checkbox_active")
            }else{
                cellTwo.imgSelection.image = #imageLiteral(resourceName: "complete_inactive_ico")
                
            }
            return cellTwo
            tblPendinglist.reloadData()            
        }
    }
    
    
    func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tblView{
            let cellTwo = tblView.dequeueReusableCell(withIdentifier: "PaymentCell")  as? PaymentCell
            let obj = arrConfirmlist[indexPath.row]
            print(PropertyID)
            print(obj.propertyID)
            // PropertyID = String(obj.propertyID)
            print("Property id \(PropertyID)")
            
            if PropertyID == String(obj.propertyID){
                PropertyID = ""
            }else{
                PropertyID = String(obj.propertyID)
            }
            
            if obj.is_payable == "1" {
                Ispayable = 1
            }else{
                Ispayable = 0
            }
            print(PropertyID)
            self.tblView.reloadData()
            
        }else {
            print(indexPath)
            let cellTwo = tblView.dequeueReusableCell(withIdentifier: "PendingMonthCell")  as? PendingMonthCell
            let obj = arrpendingmonth[indexPath.row]
            
            isrowselected = true
            if month == obj.strmonth{
                month = ""
                Year = ""
            }else{
                month = obj.strmonth
                Year = obj.stryear
                
            }
            self.tblPendinglist.reloadData()
        }
        
    }
    
}




extension PaymentTanTabVC{
    func callWebServiceForPropertyList(){
        SVProgressHUD.show()
        self.arrConfirmlist.removeAll()
//        let param = [WsParam.user:objAppSharedata.UserDetail.strUserType] as [String : Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.PropertyList+"for="+String(objAppSharedata.UserDetail.strUserType), params:[:], queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            SVProgressHUD.dismiss()
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
            self.totalRecords = response["total_records"] as? Int ?? 0
            
            // let datafound = response["data_found"] as? String ?? ""
            //  let dataFound = response["data_found"] as? Int ?? 0
            
            if status == "success"{
                SVProgressHUD.dismiss()
                let data = response["data"] as? [String:Any] ?? [:]
                let dataFound = data["data_found"] as? Int ?? 0
                let propertyList = data["property_list"] as? [String:Any] ?? [:]
                
                if dataFound == 0{
                    self.viewNoDataFound.isHidden = false
                }else {
                    if let arrproperty = data["property_list"]as? [String:Any]{
                        
                        if let arrconfirm = arrproperty["confirmed"]as? [[String:Any]]{
                            for dic in arrconfirm{
                                let obj = PropertyModel.init(dict: dic)
                                self.arrConfirmlist.append(obj)
                                print(obj)
                            }
                        }
                        print(self.arrConfirmlist.count)
                        
                        self.tblView.reloadData()
                        if  self.arrConfirmlist.count==0  {
                            self.viewNoDataFound.isHidden = false
                        }else{
                            self.tblView.reloadData()
                            self.viewNoDataFound.isHidden = true
                        }
                        print(self.arrConfirmlist.count)
                        self.tblView.reloadData()
                    }else {
                        SVProgressHUD.dismiss()
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
        }) { (error) in
            SVProgressHUD.dismiss()
            
            print(error)
        }
    }
}

extension PaymentTanTabVC{
    func GetmonthList(){
        SVProgressHUD.show()
        arrpendingmonth.removeAll()
        self.view.endEditing(true)
        objWebServiceManager.requestGet(strURL: WsUrl.GetMonthList+String(PropertyID), params: nil, queryParams: [:], strCustomValidation: "",success: { (response) in
            print(response)
            self.totalRecords = response["total_records"] as? Int ?? 0
            let message = response["message"] as? String ?? ""
            let status = response["status"] as? String ?? ""
            let datafound = Int(response["data_found"] as? String ?? "") ?? 0
            print(datafound)
            
            if   status == "success" {
                
                SVProgressHUD.dismiss()
                if let data = response["data"]as? [String:Any]{
                    
                    if let arrTenantList = data["rent_months_list"]as? [[String:Any]]{
                        for dic in arrTenantList{
                            let obj = PaymentModel.init(dict: dic)
                            self.arrpendingmonth.append(obj)

                            print(obj)
                        }
                        
                    }else{
                        self.tblPendinglist.reloadData()
                        
                    }
                    self.tblPendinglist.reloadData()
                }
            }
            else{
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



extension PaymentTanTabVC{
    func webServiceMakePayment(){
        SVProgressHUD.show()
        self.view.endEditing(true)
        
        let param = [WsParam.month:String(month),
                     WsParam.cardid:defaultCardId,
                     WsParam.propertyid:String(PropertyID),
                     WsParam.year:String(Year),
                     WsParam.amount:String(FinalPayment)] as [String : Any]
        self.view.endEditing(true)
        print(param)
        
        objWebServiceManager.requestPost(strURL: WsUrl.PaymentProperty, queryParams: [:], params: param, strCustomValidation: "", showIndicator: true, success: { (response) in
            print(response)
            self.totalRecords = response["total_records"] as? Int ?? 0
            let message = response["message"] as? String ?? ""
            let status = response["status"] as? String ?? ""
            let datafound = Int(response["data_found"] as? String ?? "") ?? 0
            print(datafound)
            
            if   status == "success" {
              
                SVProgressHUD.dismiss()
                if message == "Property rent payment has successfully done"{
                    self.viewAlert.isHidden = false
                    self.ViewConfirmAlert.isHidden = true
                    self.viewAlertContsiner.isHidden = false
                    month = ""
                    PropertyID = ""
                    Year = ""
                   // FinalPayment = ""
                    
                }else{
                    SVProgressHUD.dismiss()

                    self.viewAlert.isHidden = true
                  //  self.RedirectToMakePayment()
                     month = ""
                     PropertyID = ""
                     Year = ""
                    objAlert.showAlert(message:message, title: kAlertTitle, controller: self)
                    self.callWebServiceForPropertyList()
                }
            }
                
            else{
                SVProgressHUD.dismiss()
                month = ""
                PropertyID = ""
                Year = ""
                self.viewAlert.isHidden = true
              //  self.RedirectToMakePayment()
                
                 self.callWebServiceForPropertyList()
                // self.navigationController?.popViewController(animated: false)
                objAlert.showAlert(message:message, title: kAlertTitle, controller: self)
            }
        }, failure: { (error) in
            print(error)
            month = ""
            PropertyID = ""
            Year = ""
           // FinalPayment = ""
            SVProgressHUD.dismiss()
            self.viewAlert.isHidden = true
            self.callWebServiceForPropertyList()

         //   self.RedirectToMakePayment()
            objAlert.showAlert(message: kErrorMessage, title: kAlertTitle, controller: self)
        })
        
    }
}

//MARK:- Paggination Logic
extension PaymentTanTabVC{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isdataLoading = false
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < 0 {
            print("up")
        }else{
            if ((tblView.contentOffset.y + tblView.frame.size.height) >= tblView.contentSize.height)
            {
                if !isdataLoading{
                    isdataLoading = true
                    self.offset = self.offset+self.limit
                    if arrConfirmlist.count != totalRecords {
                        callWebServiceForPropertyList()
                    }else {
                        print("All records fetched")
                    }
                }
            }
        }
    }
}

extension PaymentTanTabVC{
    
    func callWSForGetCardList(){
        
        self.arCardList.removeAll()
        objWebServiceManager.requestGet(strURL: WsUrl.CardList, params: [:], queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            let status = response["status"] as? String
            let message = response["message"] as? String ?? ""

            if status == "success"{
                self.arCardList.removeAll()
                let data = response["data"] as? [String:Any] ?? [:]
                let dataFound = data["data_found"] as? Int ?? 0

                SVProgressHUD.dismiss()
                if dataFound == 0{
                    if self.arCardList.count == 0 {
                        defaultCardId = ""
                  
                        objAlert.showAlertCallBackOk(alertLeftBtn: "Ok", title: kAlertTitle, message: "You need to add card first", controller: self) {
                          
                                self.RedirectAddCard()
                        }
                        self.tblView.isHidden = true
                    }
                    //                    self.viewNoRecord.isHidden = false
                }else{
                    let cardDetail = data["card_list"] as? [[String:Any]]
                    for obj in cardDetail ?? [[:]]{
                        let modelObject = CardListModel.init(dict: obj)
                        self.arCardList.append(modelObject)
                        if  modelObject.strIs_default == "1" {
                            defaultCardId = modelObject.strcardID
                            print("Default Card Id Is \(defaultCardId)")
                        }
                        print("***********\(defaultCardId)")
                    }
                    print("***********\(defaultCardId)")
                    
                    self.webServiceMakePayment()
                    //  isNocardForPayment = false
                }
                self.tblView.reloadData()
                print(self.arCardList.count)
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
        }) { (error) in
            print(error)
            SVProgressHUD.dismiss()
            
            objAlert.showAlert(message: "Something went wrong.", title: kAlertTitle, controller: self)
        }
    }
    
    func RedirectAddCard(){
        
        isNocardForPayment = true
        isCommingFrom = true
        let storyBoard = UIStoryboard(name: "Tanentside", bundle:nil)
        let AddPropertyVC = storyBoard.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
        self.navigationController?.pushViewController(AddPropertyVC, animated: false)
        
    }
    func RedirectToMakePayment(){
        
        self.navigationController?.popToRootViewController(animated: false)
        if let tabBarController = objAppDelegate.window!.rootViewController as? TabBarVC {
            tabBarController.selectedIndex = 0
            
        }
    }
}
