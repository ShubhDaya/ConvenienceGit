//
//  TenantVC.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 20/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import SVProgressHUD

class TenantVC: UIViewController ,UICollectionViewDelegate{
    
    //MARK: Variable-
    var arrTenantList = [TenantListModel]()
    var indexNew = 0
    let reuseIdentifier = "Cell" // also enter this string as the cell identifier in the storyboard
    var isDataLoading:Bool=false
    var isLoadData = false
    var limit:Int=10
    var offset:Int=0
    var totalRecords = Int()
    var placeholderRow = 10
    //MARK: IBOutlet-
    
    @IBOutlet weak var viewNodataFound: UIView!
    @IBOutlet weak var viewimgOwner: UIView!
    @IBOutlet weak var viewCollectionData: UIView!
    @IBOutlet weak var imgOwner: UIImageView!
    @IBOutlet weak var lblOwnerName: UILabel!
    @IBOutlet weak var viewTableView: UIView!
    @IBOutlet weak var viewCollectionView: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK: AppLifeCycle-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewCollectionData.isHidden = false
        self.viewTableView.isHidden = true
        self.viewNodataFound.isHidden = true
        self.lblOwnerName.text = "\(objAppShareData.UserDetail.strFirstName) \(objAppShareData.UserDetail.strLastName)"
        let strimage = objAppShareData.UserDetail.strProfilePicture
        let urlImg = URL(string: strimage)
        self.imgOwner.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "profile_ico"))

         if objAppShareData.isFromNotification{
            if objAppShareData.strNotificationType == "payment_received"{
                let vc = UIStoryboard.init(name: "Tenant", bundle: nil).instantiateViewController(withIdentifier: "TenantPropertyDetail_VC")as! TenantPropertyDetail_VC
            if let sender_id = objAppShareData.notificationDict["sender_id"] as? Int{
                vc.strUserId = String(sender_id)
            }else if let sender_id = objAppShareData.notificationDict["sender_id"] as? String{
                vc.strUserId = sender_id
            }
                if let property_id = objAppShareData.notificationDict["property_id"] as? Int{
                    vc.strPropertyID = String(property_id)
                }else if let property_id = objAppShareData.notificationDict["property_id"] as? String{
                    vc.strPropertyID = property_id
                }
            if let property_name = objAppShareData.notificationDict["property_name"] as? String{
                vc.strPropertyName = property_name
            }
            if let property_address = objAppShareData.notificationDict["property_address"] as? String{
                vc.strPropertyAddress = property_address
            }
            if let property_image = objAppShareData.notificationDict["property_image"] as? String{
                vc.strPropertyImage = property_image
            }
                self.navigationController?.pushViewController(vc, animated: false)
            
            }else if objAppShareData.strNotificationType == "Payment_due_system"{
                 let vc = UIStoryboard.init(name: "Tenant", bundle: nil).instantiateViewController(withIdentifier: "TanantDetailsVC")as! TanantDetailsVC
                let objData = TenantListModel(dict: [:])
                if let sender_id = objAppShareData.notificationDict["sender_id"] as? Int{
                    objData.user_id = String(sender_id)
                }else if let sender_id = objAppShareData.notificationDict["sender_id"] as? String{
                    objData.user_id = sender_id
                }
                if let name = objAppShareData.notificationDict["sender_name"] as? String{
                    objData.full_name = name
                }
                if let pic = objAppShareData.notificationDict["sender_user_avatar"] as? String{
                    objData.profile_picture = pic
                }
                vc.objData = objData
                self.navigationController?.pushViewController(vc, animated: false)
            }
                   objAppShareData.isFromNotification = false
                   objAppShareData.strNotificationType = ""
                   objAppShareData.notificationDict = [:]
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isfromOwnerDetail = false
        //isFromePaymentDueSystem = false

        UiDesign()
        self.lblOwnerName.text = "\(objAppShareData.UserDetail.strFirstName) \(objAppShareData.UserDetail.strLastName)"
             let strimage = objAppShareData.UserDetail.strProfilePicture
             let urlImg = URL(string: strimage)
             self.imgOwner.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "profile_ico"))
        self.arrTenantList.removeAll()
        self.limit = 10
        self.offset = 0
        self.callWebServiceForTenantList()
        
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: Variable-
    
    // btn in collection view
    @IBAction func btnCollectionData(_ sender: Any) {
        self.viewCollectionData.isHidden = true
        self.viewTableView.isHidden = false
        self.tblView.reloadData()
    }
    
    // btn in tablview view
    @IBAction func btnTblData(_ sender: Any) {
        self.viewTableView.isHidden = true
        self.viewCollectionData.isHidden = false
        self.collectionView.reloadData()
    }
    
    //MARK: Local Functions-
    
    
    func UiDesign(){
        self.imgOwner.setImgCircle()
        self.viewimgOwner.setviewCirclewhite()
        self.viewimgOwner.setshadowViewCircle()
        self.viewTableView.setViewRadius()
        self.viewCollectionData.setViewRadius()
        self.viewTableView.setshadowView()
        self.viewCollectionData.setshadowView()
        
    }
    
}

//MARK: UICollectionViewDataSource -

extension TenantVC : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTenantList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! TenantCollectionCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        
        let obj = arrTenantList[indexPath.row]
        cell.lblTenantName.text = "\(obj.first_name) \(obj.last_name)"
        let strimage = obj.profile_picture ?? ""
        let urlImg = URL(string: strimage)
        cell.imgTenantList.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "property-placeholder"))
        
        if obj.isDueStatus == "1"{
            cell.imgTenantList.layer.borderColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
            cell.lblTenantName.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        }else{
            cell.imgTenantList.layer.borderColor = #colorLiteral(red: 0.1176470588, green: 0.231372549, blue: 0.3568627451, alpha: 1)
            cell.lblTenantName.textColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)

        }
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TanantDetailsVC") as! TanantDetailsVC
        let obj = arrTenantList[indexPath.row]
        vc.objData = obj
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: UITableViewDelegate,UITableViewDataSource  -


extension TenantVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrTenantList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "TenantTableViewCell", for: indexPath) as! TenantTableViewCell
        let obj1 = arrTenantList[indexPath.row]
        cell1.lblTenantName.text = "\(obj1.first_name) \(obj1.last_name)"
        let strimage = obj1.profile_picture ?? ""
        let urlImg = URL(string: strimage)
        cell1.imgTenantList.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "property-placeholder"))
        if obj1.isDueStatus == "1"{
            cell1.imgTenantList.layer.borderColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
            cell1.lblTenantName.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        }else{
            cell1.imgTenantList.layer.borderColor = #colorLiteral(red: 0.1176470588, green: 0.231372549, blue: 0.3568627451, alpha: 1)
            cell1.lblTenantName.textColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)

        }

        return cell1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TanantDetailsVC") as! TanantDetailsVC
        let obj = arrTenantList[indexPath.row]
        // print("name is \(obj.)")
        vc.objData = obj
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

//MARK:UICollectionViewDelegateFlowLayout
extension TenantVC : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = CGFloat((self.viewCollectionData.frame.size.width-10) / 3.0)
        let cellHeight = cellWidth*1
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}
extension TenantVC{
    func callWebServiceForTenantList(){
        SVProgressHUD.show()
        //  self.arrTenantList.removeAll()
        objWebServiceManager.requestGet(strURL: WsUrl.getOwnertenantlist+String(objAppShareData.UserDetail.strUserID)+"/tenants?limit="+String(self.limit)+"&offset="+String(self.offset), params:nil, queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
            if status == "success"{
                SVProgressHUD.dismiss()
                
                let data = response["data"] as? [String:Any] ?? [:]
                let datafound = Int(data["data_found"] as? String ?? "") ?? 0
                let userdata = data["data_found"] as? Int ?? 0
                print(userdata)
                print(datafound)
                //let datafound = Int(response["data_found"] as? String ?? "") ?? 0
                
                let tenantlist = data["tenant_list"] as? [String:Any] ?? [:]
                print(self.totalRecords)
                self.tblView.isHidden = false
                //  self.viewNoRecord.isHidden = true
                
                if let data = response["data"]as? [String:Any]{
                    self.totalRecords = data["total_records"] as? Int ?? 0

                    
                    if let arrTenantList = data["tenant_list"]as? [[String:Any]]{
                        for dic in arrTenantList{
                            let obj = TenantListModel.init(dict: dic)
                            self.arrTenantList.append(obj)
                            print(obj)
                        }
                    }else{
                        self.tblView.reloadData()
                        self.collectionView.reloadData()
                    }
                    self.tblView.reloadData()
                    self.collectionView.reloadData()
                }
                SVProgressHUD.dismiss()
                if datafound == 0{
                    if self.arrTenantList.count == 0{
                        self.viewNodataFound.isHidden = false
                    }else{
                        self.viewNodataFound.isHidden = true
                    }
                }else{
                    self.viewNodataFound.isHidden = true
                }
                self.tblView.reloadData()
            }else{
                self.arrTenantList.removeAll()
                self.limit = 10
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
extension TenantVC{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < 0 {
            print("up")
        }else{
            if ((tblView.contentOffset.y + tblView.frame.size.height) >= tblView.contentSize.height)
            {
                if !isDataLoading{
                    isDataLoading = true
                    
                    self.offset = self.offset+self.limit
                    
                    if arrTenantList.count != totalRecords {
                        callWebServiceForTenantList()
                    }else {
                        print("All records fetched")
                    }
                }
            }else if ((collectionView.contentOffset.y + collectionView.frame.size.height) >= collectionView.contentSize.height){
                
                if !isDataLoading{
                    isDataLoading = true
                    
                    self.offset = self.offset+self.limit
                    
                    if arrTenantList.count != totalRecords {
                        callWebServiceForTenantList()
                    }else {
                        print("All records fetched")
                    }
                }
                
            }
        }
    }
}
