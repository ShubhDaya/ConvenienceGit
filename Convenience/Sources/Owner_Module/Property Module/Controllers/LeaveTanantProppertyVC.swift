//
//  LeaveTanantProppertyVC.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 13/02/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//


 import UIKit
 import SVProgressHUD

 var isfromOwnerDetail = false

 class LeaveTanantProppertyVC: UIViewController {
     
     var selectedButton: UIButton? = nil
     var SelectedDate = -1
     var owner = "Owner"
     var propertyid = 0
     var isDataLoading:Bool=false
     var limit:Int=1
     var offset:Int=0
     var totalRecords = Int()
     
     var objProperty = PropertyDetail(dict: [:])
     var ObjAlertClassData =  AlertModel(dict: [:])
     
     var arrDetails = [PropertyDetail]()
     var arrPendingList = [PropertyTenantModel]()
     var arrConfirmList = [PropertyTenantModel]()
     var arrConfirmPendingList = [PropertyTenantModel]()
     
     var accept = "accept"
     var reject = "cancel"
     var Leave = "leave"
     // var obj1 = PropertyDetail(dict: [:])
     var tenant_id = 0
     
     
     var isSepratorline = false
     var isSepratorRowHeight = false
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewBothAlert: UIView!
     @IBOutlet weak var viewAlerytLeaveC: UIView!
     @IBOutlet weak var viewAlertLeaveHeader: UIView!
     
     @IBOutlet weak var viewAlertCancel: UIView!
     @IBOutlet weak var viewHeaderCancel: UIView!
     @IBOutlet weak var lblLeaveAlertText: UILabel!
     @IBOutlet weak var viewNodataFound: UIView!
     @IBOutlet weak var btnChangeDate: customButton!
     @IBOutlet weak var ConfirmTblView: UITableView!
     @IBOutlet weak var imgPropertyImg: UIImageView!
     @IBOutlet weak var lblPropertyName: UILabel!
     @IBOutlet weak var lblPropertyAddress: UILabel!
     @IBOutlet weak var view1: UIView!
     @IBOutlet weak var lblPaymentDueDate: UILabel!
     @IBOutlet weak var viewAlert: UIView!
     @IBOutlet weak var viewAlertContainer: UIView!
     @IBOutlet weak var viewHeader: UIView!
     @IBOutlet weak var btnAlertDone: customButton!
     @IBOutlet var btnAllSelected: [UIButton]!
     @IBOutlet weak var tableviewheight: NSLayoutConstraint!
     @IBOutlet weak var Pendingtableheight: NSLayoutConstraint!
     
     override func viewDidLoad() {
         super.viewDidLoad()
         self.uiDesign()
         print(ObjAlertClassData.strPropertyID)
        self.scrollView.delegate = self
         self.viewAlert.isHidden = true
         self.viewNodataFound.isHidden = true
         self.viewBothAlert.isHidden = true
         self.viewAlerytLeaveC.isHidden = true
         self.viewAlertCancel.isHidden = true
        
        self.ConfirmTblView.dataSource = self
        self.ConfirmTblView.delegate = self

         
         // self.lblPaymentDueDate.text = "\(obj1.due_date)"
         
     }
     
     override func viewWillAppear(_ animated: Bool) {
         isfromOwnerDetail = false

         if isAlertId == true{
             print(ObjAlertClassData.strPropertyID)
             self.propertyid = Int(ObjAlertClassData.strPropertyID) ?? 0
         }else{
             print(objProperty.propertyID)
             self.propertyid = objProperty.propertyID
         }
       self.uGetProprtyDetails()
       self.arrPendingList.removeAll()
       self.arrConfirmList.removeAll()
        self.arrConfirmPendingList.removeAll()
            self.limit = 10
            self.offset = 0
        
        self.getPropertyTenantList()
        self.ConfirmTblView.reloadData()
         //  self.propertyid = objProperty.propertyID
        let strimage = objProperty.property_image
        let urlImg = URL(string: strimage)
        self.imgPropertyImg.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "property-placeholder"))
        
        if objProperty.due_date == "" {
             
             self.lblPaymentDueDate.text = "No date available"
             self.btnChangeDate.setTitle("Set Date", for: .normal)
             
         }else {
             
             self.btnChangeDate.setTitle("Change Date", for: .normal)
             if self.objProperty.due_date == "1"{
                 self.lblPaymentDueDate.text = "\(self.objProperty.due_date)st of every month"
             }else if self.objProperty.due_date == "2"{
                 self.lblPaymentDueDate.text = "\(self.objProperty.due_date)nd of every month"
             }else if self.objProperty.due_date == "3"{
                 self.lblPaymentDueDate.text = "\(self.objProperty.due_date)rd of every month"
             }
             else if self.objProperty.due_date == "21"{
                 self.lblPaymentDueDate.text = "\(self.objProperty.due_date)st of every month"
             }else if self.objProperty.due_date == "22"{
                 self.lblPaymentDueDate.text = "\(self.objProperty.due_date)nd of every month"
             }
             else if self.objProperty.due_date == "23"{
                 self.lblPaymentDueDate.text = "\(self.objProperty.due_date)rd of every month"
             }
             else{
                 self.lblPaymentDueDate.text = "\(self.objProperty.due_date)th of every month"
             }
         }
     }
     
     override var preferredStatusBarStyle: UIStatusBarStyle {
         return .lightContent
     }
     
     //MARK:buttons -
     
     
     @IBAction func btnLeaveNO(_ sender: Any) {
         self.viewBothAlert.isHidden = true
         self.tabBarController?.tabBar.isHidden = false
     }
     
     @IBAction func btnLeaveYes(_ sender: Any) {
         self.LeaveTenantRequestAPI()
         self.tabBarController?.tabBar.isHidden = false
         self.viewBothAlert.isHidden = true
     }
     
     
     @IBAction func btnCancelNo(_ sender: Any) {
         self.tabBarController?.tabBar.isHidden = false
         self.viewBothAlert.isHidden = true
     }
     
     @IBAction func btnCancelYes(_ sender: Any) {
         self.tabBarController?.tabBar.isHidden = false
         self.viewBothAlert.isHidden = true
         self.RejectRequestAPI()
         
     }
  
     
     @IBAction func btnSelecteDateDone(_ sender: Any) {
         
         if SelectedDate == -1{
             objAlert.showAlert(message: "Please select due date", title: kAlertTitle, controller: self)
             
         }else {
             
             self.UpdateDueDate()
             
         }
     }
     @IBAction func btnBack(_ sender: Any) {
         navigationController?.popViewController(animated: true)
     }
     
     @IBAction func btnChangeDate(_ sender: Any) {
         self.viewAlert.isHidden = false
     }
     
     @IBAction func btnLeaveTanant(_ sender: Any) {
         
     }
     @IBAction func btnNumberTapped(sender: AnyObject) {
         print(sender )
         
         for button in btnAllSelected {
             if sender.tag == button.tag{
                 button.isSelected = true;
                 button.backgroundColor = #colorLiteral(red: 0.1803921569, green: 0.1019607843, blue: 1, alpha: 1)
                 button.setTitleColor(.white, for: .normal)
                 button.setradiusbtn15()
                 button.setbtnshadow()
                 SelectedDate = sender.tag
                 if SelectedDate == 1 {
                     self.lblPaymentDueDate.text = String(SelectedDate)+"st of every month"
                     
                 }else if SelectedDate == 2 {
                     self.lblPaymentDueDate.text = String(SelectedDate)+"nd of every month"
                     
                 }else if SelectedDate == 3 {
                     self.lblPaymentDueDate.text = String(SelectedDate)+"rd of every month"
                     
                 }
                 else if SelectedDate == 21{
                     self.lblPaymentDueDate.text = String(SelectedDate)+"st of every month"
                     
                 }else if SelectedDate == 22{
                     self.lblPaymentDueDate.text = String(SelectedDate)+"nd of every month"
                     
                 }
                 else if SelectedDate == 23{
                     self.lblPaymentDueDate.text = String(SelectedDate)+"rd of every month"
                     
                 }
                     
                 else {
                     self.lblPaymentDueDate.text = String(SelectedDate)+"th of every month"
                     
                 }
                 print(SelectedDate)
             }else{
                 button.isSelected = false;
                 button.backgroundColor = .clear
                 button.setTitleColor(.black, for: .normal)
                 button.setradiusbtn15()
             }
         }
         if sender.tag == 1{
             print("Button 1 selected")
         }else if sender.tag == 2{
             print("Button 2 selected")
         }else if sender.tag == 3{
             print("Button 3 selected")
         }else if sender.tag == 4{
             print("Button 4 selected")
         }else if sender.tag == 5{
             print("Button 5 selected")
         }else if sender.tag == 6{
             print("Button 6 selected")
         }
     }
     
     
     
     //MARK:Local Function-
     
     func uiDesign(){
         
         self.view1.setViewRadius()
         self.view1.setshadowView()
         self.viewAlertContainer.setViewCornerRadius()
         self.viewAlertContainer.setshadowViewCircle()
         self.btnAlertDone.setradiusbtn()
         self.viewHeader.setViewRadius10()
         self.viewAlerytLeaveC.setshadowViewCircle()
         self.viewAlerytLeaveC.setViewCornerRadius()
         self.viewAlertCancel.setshadowViewCircle()
         self.viewAlertCancel.setViewCornerRadius()
         self.viewAlertLeaveHeader.setViewRadius10()
         self.viewHeaderCancel.setViewRadius10()
      
     }
 }

 extension LeaveTanantProppertyVC:UITableViewDelegate,UITableViewDataSource{
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
         self.tableviewheight.constant = CGFloat(arrConfirmPendingList.count * 60)
         return arrConfirmPendingList.count
         
     }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         
         let obj = arrConfirmPendingList[indexPath.row]
         if obj.status == 1
         {
             if self.isSepratorRowHeight == false
             {
                 self.isSepratorRowHeight = true
                 return 65;//Choose your custom row height
             }
             else
             {
                 return 57;//Choose your custom row height
             }
         }
         else
         {
             return 57;//Choose your custom row height
         }
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
                let obj = arrConfirmPendingList[indexPath.row]

                     let cell = self.ConfirmTblView.dequeueReusableCell(withIdentifier: "ConfirmListCell") as! ConfirmListCell
                     cell.lblConTenantName.text = obj.first_name ?? ""
                     // tenant_id = obj.user_id ?? 0
                     let strimage = obj.profile_picture ?? ""
                     let urlImg = URL(string: strimage)
                     cell.imgConTenant.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "user_img"))
                    if arrPendingList.count == 0{
                                cell.lblSeparator.isHidden = true
                        }
             if obj.status == 1  {

                         if isSepratorline == false
                                 {
                                   
                                     cell.lblSeparator.isHidden = true
                                     self.isSepratorline = true
                                 }
                                 else
                                 {
                                     cell.lblSeparator.isHidden = true
                                 }
                
                     cell.btnLeaveTenant.isHidden = true
                     cell.viewbtnAcceptReject.isHidden = false
                     cell.btnAccept.tag = indexPath.row
                     cell.btnreject.tag = indexPath.row
                     cell.btnAccept.addTarget(self,action:#selector(acceptbtnClicked(sender:)), for: .touchUpInside)
                      cell.btnreject.addTarget(self,action:#selector(cancelbtnclicked(sender:)), for: .touchUpInside)

                 }else {
                     cell.lblSeparator.isHidden = true
                     cell.viewbtnAcceptReject.isHidden = true
                     cell.btnLeaveTenant.tag = indexPath.row
                     cell.btnLeaveTenant.isHidden = false
                     cell.btnLeaveTenant.addTarget(self,action:#selector(btnLeaveTenant(sender:)), for: .touchUpInside)
                 }

                     return cell
        
        
     }
     @objc func acceptbtnClicked(sender : UIButton!) {
         self.viewAlert.isHidden = true
         print(SelectedDate)
         let obj = self.arrConfirmPendingList[sender.tag]
         print(obj)
         print(objProperty.due_date)
         tenant_id = obj.user_id ?? 0
         let pro = objProperty.due_date
         print(pro)
         if  objProperty.due_date == "" || SelectedDate == -1 {
             
             objAlert.showAlertCallBack(alertLeftBtn: "Cancel", alertRightBtn: "Ok", title: "Alert", message: "you have to select your due date", controller: self) { (isOk) in
                 
                 if isOk
                 {
                     self.viewAlert.isHidden = false
                     
                 }
                 else
                 {
                     
                 }
             }
         }else {
             self.AcceptRejectRequestAPI()
         }
     }
     @objc func cancelbtnclicked(sender : UIButton!) {
         self.viewAlert.isHidden = true
         let obj = self.arrConfirmPendingList[sender.tag]
         print(obj)
         tenant_id = obj.user_id ?? 0
         
         self.viewBothAlert.isHidden = false
         self.viewAlerytLeaveC.isHidden = true
         self.viewAlertCancel.isHidden = false
     }
     @objc func btnLeaveTenant(sender : UIButton!) {
         self.viewAlert.isHidden = true
         let obj = self.arrConfirmPendingList[sender.tag]
         print(obj)
         tenant_id = obj.user_id ?? 0
         self.lblLeaveAlertText.text = "Are you sure \(obj.first_name ?? "") \(obj.last_name ?? "") has settled all dues ?"
         //  objAlert.showAlert(message: kunderDevelopment, title: kAlertTitle, controller: self)
         //  self.LeaveTenantRequestAPI()
         
         self.tabBarController?.tabBar.isHidden = true
         self.viewBothAlert.isHidden = false
         self.viewAlerytLeaveC.isHidden = false
         self.viewAlertCancel.isHidden = true
     }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = arrConfirmPendingList[indexPath.row]
        isfromOwnerDetail = true
        let storyBoard = UIStoryboard(name: "Tenant", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "TanantDetailsVC") as! TanantDetailsVC
                     
        vc.firstname = obj.first_name ?? ""
        vc.Lastname = obj.last_name ?? ""
        vc.ProfileImg = obj.profile_picture ?? ""
        vc.userID = String(obj.user_id ?? 00)

        self.navigationController?.pushViewController(vc, animated: true)
       }
 }

 extension LeaveTanantProppertyVC{
     func uGetProprtyDetails(){
         SVProgressHUD.show()
         self.view.endEditing(true)
         print(objProperty.propertyID)
         print(ObjAlertClassData.strPropertyID)
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
                             self.lblPropertyName.text = self.objProperty.name
                             self.lblPropertyAddress.text = self.objProperty.address
                             if self.objProperty.due_date == ""{
                                 self.lblPaymentDueDate.text = "No date available"
                                 self.btnChangeDate.setTitle("Set Date", for: .normal)
                                 
                             }else{
                                 self.btnChangeDate.setTitle("Change Date", for: .normal)
                                 
                                 if self.objProperty.due_date == "1"{
                                     self.lblPaymentDueDate.text = "\(self.objProperty.due_date)st of every month"
                                 }else if self.objProperty.due_date == "2"{
                                     self.lblPaymentDueDate.text = "\(self.objProperty.due_date)nd of every month"
                                 }else if self.objProperty.due_date == "3"{
                                     self.lblPaymentDueDate.text = "\(self.objProperty.due_date)rd of every month"
                                 }
                                 else if self.objProperty.due_date == "21"{
                                     self.lblPaymentDueDate.text = "\(self.objProperty.due_date)st of every month"
                                 }else if self.objProperty.due_date == "22"{
                                     self.lblPaymentDueDate.text = "\(self.objProperty.due_date)nd of every month"
                                 }
                                 else if self.objProperty.due_date == "23"{
                                     self.lblPaymentDueDate.text = "\(self.objProperty.due_date)rd of every month"
                                 }
                                 else{
                                     self.lblPaymentDueDate.text = "\(self.objProperty.due_date)th of every month"
                                 }
                             }
                             
                             let strimage =  self.objProperty.property_image
                             let urlImg = URL(string: strimage )
                             self.imgPropertyImg.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "property-placeholder"))
                             let buttonTag   =   Int(self.objProperty.due_date) ?? -1
                             for button in self.btnAllSelected {
                                 if buttonTag == button.tag{
                                     button.isSelected = true;
                                     button.backgroundColor = #colorLiteral(red: 0.1803921569, green: 0.1019607843, blue: 1, alpha: 1)
                                     button.setTitleColor(.white, for: .normal)
                                     button.setradiusbtn15()
                                     button.setbtnshadow()
                                     self.SelectedDate = buttonTag
                                     print(self.SelectedDate)
                                     if self.SelectedDate == 1{
                                         self.lblPaymentDueDate.text = String(self.SelectedDate)+"st of every month"
                                     }else if self.SelectedDate == 2{
                                         self.lblPaymentDueDate.text = String(self.SelectedDate)+"nd of every month"
                                     }
                                     else if self.SelectedDate == 3{
                                         self.lblPaymentDueDate.text = String(self.SelectedDate)+"rd of every month"
                                     }else if self.SelectedDate == 21{
                                         self.lblPaymentDueDate.text = String(self.SelectedDate)+"st of every month"
                                     }
                                     else if self.SelectedDate == 22{
                                         self.lblPaymentDueDate.text = String(self.SelectedDate)+"nd of every month"
                                     
                                     }
                                     else if self.SelectedDate == 23{
                                                                                self.lblPaymentDueDate.text = String(self.SelectedDate)+"rd of every month"
                                                                            
                                                }
                                     else{
                                         self.lblPaymentDueDate.text = String(self.SelectedDate)+"th of every month"
                                     }
                                 }else{
                                     button.isSelected = false;
                                     button.backgroundColor = .clear
                                     button.setTitleColor(.black, for: .normal)
                                     button.setradiusbtn15()
                                 }
                             }
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
             //  objAppShareData.showAlert(title: "Something went wrong.", message: kErrorMessage, view: self)
         })
         
     }
 }
 extension LeaveTanantProppertyVC{
     func getPropertyTenantList(){
         print(propertyid)
         SVProgressHUD.show()

         objWebServiceManager.requestGet(strURL: WsUrl.PropertyTenantList+String(propertyid)+"/tenants?limit="+String(self.limit)+"&offset="+String(self.offset), params: nil , queryParams: [:], strCustomValidation: "", success: { (response) in
             print(response)
             
             let message = response["message"] as? String ?? ""
             let status = response["status"] as? String ?? ""
             let datafound = Int(response["data_found"] as? String ?? "") ?? 0
             
             
             if   status == "success" {
              
                 SVProgressHUD.dismiss()
                 if let data = response["data"]as? [String:Any]{
                    
                    self.totalRecords = data["total_records"] as? Int ?? 0

                     if let arrtenantlist = data["quote_list"]as? [[String:Any]]{
                         for dic in arrtenantlist{
                             let obj = PropertyTenantModel.init(dict: dic)
                             if obj.status == 1 {
                                 self.arrPendingList.append(obj)
                             }else {
                                 self.arrConfirmList.append(obj)
                             }
                            
                                self.arrConfirmPendingList = self.arrPendingList
                                for obj in self.arrConfirmList{
                                    self.arrConfirmPendingList.append(obj)
                                }
                            
                             self.ConfirmTblView.reloadData()
                         }
                         self.ConfirmTblView.reloadData()
                         
                     }else{
                         //   self.arrownerList.removeAll()
                         // self.tableView.reloadData()
                     }
                     SVProgressHUD.dismiss()
                     if datafound == 0{
                         if self.arrConfirmPendingList.count == 0{
                             self.viewNodataFound.isHidden = false
                         }else{
                             self.viewNodataFound.isHidden = true
                         }
                     }else{
                         self.viewNodataFound.isHidden = true
                     }
                     self.ConfirmTblView.reloadData()
                 }
                 
             }else{
                 objWebServiceManager.hideIndicator()
                 if message == "k_sessionExpire"{
                     objAlert.showAlert(message: k_sessionExpire, title: kAlertTitle, controller: self)
                     objAppShareData.resetDefaultsAlluserInfo()
                     
                     objAppDelegate.showLogInNavigation()
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

 //MARK:- Paggination Logic
 extension LeaveTanantProppertyVC{

     func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
         isDataLoading = false
     }

     func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
         if velocity.y < 0 {
             print("up")
         }else{
            if ((self.scrollView.contentOffset.y + self.scrollView.frame.size.height) >= self.scrollView.contentSize.height)
             {
                 if !isDataLoading{
                     isDataLoading = true

                     self.offset = self.offset+self.limit

                     if arrConfirmPendingList.count != totalRecords {
                         self.getPropertyTenantList()
                     }else {
                         print("All records fetched")
                     }
                 }
             }
         }
     }
 }

 extension LeaveTanantProppertyVC{
     func AcceptRejectRequestAPI(){
         print(tenant_id)
         SVProgressHUD.show()
         let param = [WsParam.status:accept,
                      WsParam.tenant_id:tenant_id] as [String : Any]
         
         objWebServiceManager.requestPatch(strURL: WsUrl.PatchRequestA_C_L+String(propertyid)+"/action", params: param, strCustomValidation:"", success: { (response) in
             print(response)
             
             let message = response["message"] as? String ?? ""
             let status = response["status"] as? String ?? ""
             let datafound = Int(response["data_found"] as? String ?? "") ?? 0
             self.totalRecords = Int(response["total_records"] as? String ?? "") ?? 0
             print(datafound)
             
            if status == "success" {
               SVProgressHUD.dismiss()
                 if (response["data"]as? [String:Any]) != nil{
                   self.arrConfirmList.removeAll()
                    self.arrPendingList.removeAll()
                    self.arrConfirmPendingList.removeAll()
                    self.limit = 10
                    self.offset = 0
                    self.getPropertyTenantList()
                 }
             }else{
                 objWebServiceManager.hideIndicator()
                 if message == "k_sessionExpire"{
                     objAlert.showAlert(message: k_sessionExpire, title: kAlertTitle, controller: self)
                     objAppDelegate.showLogInNavigation()
                     
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

 extension LeaveTanantProppertyVC{
     func RejectRequestAPI(){
         print(tenant_id)
         SVProgressHUD.show()
         let param = [WsParam.status:reject,
                      WsParam.tenant_id:tenant_id] as [String : Any]
         
         objWebServiceManager.requestPatch(strURL: WsUrl.PatchRequestA_C_L+String(propertyid)+"/action", params: param, strCustomValidation:"", success: { (response) in
             print(response)
             
             let message = response["message"] as? String ?? ""
             let status = response["status"] as? String ?? ""
             let datafound = Int(response["data_found"] as? String ?? "") ?? 0
             self.totalRecords = Int(response["total_records"] as? String ?? "") ?? 0
             print(datafound)
             
             if   status == "success" {
              
                 SVProgressHUD.dismiss()
                 if (response["data"]as? [String:Any]) != nil{
                    
                    self.arrConfirmList.removeAll()
                    self.arrPendingList.removeAll()
                    self.arrConfirmPendingList.removeAll()
                    self.limit = 10
                    self.offset = 0
                    self.getPropertyTenantList()
                 }
             }else{
                 objWebServiceManager.hideIndicator()
                 if message == "k_sessionExpire"{
                     objAlert.showAlert(message: k_sessionExpire, title: kAlertTitle, controller: self)
                     objAppShareData.resetDefaultsAlluserInfo()
                     
                     objAppDelegate.showLogInNavigation()
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
 extension LeaveTanantProppertyVC{
     func LeaveTenantRequestAPI(){

         SVProgressHUD.show()
         print(tenant_id)
         print(propertyid)
         objWebServiceManager.requestDelete(strURL: WsUrl.leaveproprtyOwner+String(propertyid)+"/leave/"+String(tenant_id), params: nil, queryParams: [:], strCustomValidation: "", success: { (response) in
             print(response)
             
             let message = response["message"] as? String ?? ""
             let status = response["status"] as? String ?? ""
             let datafound = Int(response["data_found"] as? String ?? "") ?? 0
             //self.totalRecords = Int(response["total_records"] as? String ?? "") ?? 0
             print(datafound)
             
             if   status == "success" {
                 SVProgressHUD.dismiss()
               //  self.getPropertyTenantList()
                 if (response["data"]as? [String:Any]) != nil{
                    self.arrConfirmList.removeAll()
                    self.arrPendingList.removeAll()
                    self.arrConfirmPendingList.removeAll()
                    self.limit = 10
                    self.offset = 0
                     self.getPropertyTenantList()
                     self.ConfirmTblView.reloadData()
                 }
             }else{
                 objWebServiceManager.hideIndicator()
                 if message == "k_sessionExpire"{
                     objAlert.showAlert(message: k_sessionExpire, title: kAlertTitle, controller: self)
                     objAppShareData.resetDefaultsAlluserInfo()
                     
                     objAppDelegate.showLogInNavigation()
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

 extension LeaveTanantProppertyVC{
     func UpdateDueDate(){
         SVProgressHUD.show()
         print(objProperty.propertyID)
         print(objProperty.propertyID)
         print(SelectedDate)
         //    let param = [WsParam.status:reject,
         //                 WsParam.tenant_id:tenant_id] as [String : Any]
         
         objWebServiceManager.requestPatch(strURL: WsUrl.DueDate+String(objProperty.propertyID)+"/due-date/"+String(SelectedDate), params: [:], strCustomValidation:"", success: { (response) in
             print(response)
             
             let message = response["message"] as? String ?? ""
             let status = response["status"] as? String ?? ""
             let datafound = Int(response["data_found"] as? String ?? "") ?? 0
             self.totalRecords = Int(response["total_records"] as? String ?? "") ?? 0
             print(datafound)
             
             if   status == "success" {
                 SVProgressHUD.dismiss()
                 if (response["data"]as? [String:Any]) != nil{
                     self.viewAlert.isHidden = true
                     self.btnChangeDate.setTitle("Change Date", for:.normal)
                    self.arrConfirmList.removeAll()
                    self.arrPendingList.removeAll()
                    self.arrConfirmPendingList.removeAll()
                    self.limit = 10
                    self.offset = 0
                     self.getPropertyTenantList()
                     self.ConfirmTblView.reloadData()
                     self.uGetProprtyDetails()

                 }
             }else{
                 objWebServiceManager.hideIndicator()
                 if message == "k_sessionExpire"{
                     objAlert.showAlert(message: k_sessionExpire, title: kAlertTitle, controller: self)
                     objAppDelegate.showLogInNavigation()
                     
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
