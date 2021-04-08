//
//  TanantDetailsVC.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 28/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

class TanantDetailsVC: UIViewController {
    
    //MARK: Variable-
    var arrDetails = [TenantDetailsModel]()
    var objData = TenantListModel(dict: [:])
    var arrTenantPropertyL = [PropertyModel]()
    var indexNew = 0
    var tenantid = ""
    var propertyId = ""
    
    var firstname = ""
    var Lastname = ""
    var fullname = ""
    var ProfileImg = ""
    var userID = ""
    
    var tanantName = ""
    var image = UIImage()
    var isDataLoading:Bool=false
    var limit:Int=10
    var offset:Int=0
    var totalRecords = Int()
    
    //MARK: IBOutlet-
    
    @IBOutlet weak var imgtanantDetail: UIImageView!
    @IBOutlet weak var lblTanantName: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var btnCancelAlert: customButton!
    @IBOutlet weak var btnProceed: UIButton!
    @IBOutlet weak var btnProceedAlert: UIButton!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var viewAlert: UIView!
    @IBOutlet weak var viewAlertContainer: UIView!
    @IBOutlet weak var viewheaderAlert: customView!
    
    var arrlist = ["Meeting Ares ","Bangalow","home","Home","Office","Meeting Area ","Garden","Hall ","Bungalow","John"]
    let arrTenantImages = [#imageLiteral(resourceName: "3-1"),#imageLiteral(resourceName: "3-4"),#imageLiteral(resourceName: "7-1"),#imageLiteral(resourceName: "7-3"),#imageLiteral(resourceName: "4-3"),#imageLiteral(resourceName: "img 1"),#imageLiteral(resourceName: "7"),#imageLiteral(resourceName: "3"),#imageLiteral(resourceName: "4"),#imageLiteral(resourceName: "4")]
    
    //MARK: AppLifeCycle-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UiDesign()
        self.tableview.tableFooterView = UIView()
        self.viewAlert.isHidden = true
        self.tableview.delegate = self
        self.tableview.dataSource = self
        print(objData)
        
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
           return .lightContent
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isfromOwnerDetail == true {
                 print(firstname)
                  print(Lastname)
                  print(ProfileImg)
                  print(userID)
        } else{
                   self.firstname = objData.first_name
                   self.Lastname = objData.last_name
                   self.ProfileImg = objData.profile_picture
                   self.userID = objData.user_id
                   self.fullname = objData.full_name
        }
        
//        else if isFromePaymentDueSystem == true{
//            print(firstname)
//            print(Lastname)
//            print(ProfileImg)
//            print(userID)
//        }
        if  self.fullname.count > 0{
            self.lblTanantName.text = self.fullname
        }else{
            self.lblTanantName.text = "\(firstname) \(Lastname)"
        }
        let strimage = ProfileImg
        let urlImg = URL(string: strimage)
        self.imgtanantDetail.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "user_img"))
        UiDesign()
        self.arrTenantPropertyL.removeAll()
        self.limit = 10
        self.offset = 0
        self.getlist()
        
        
        
    }
    //MARK: Variable-
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCancelAlert(_ sender: Any) {
        self.viewAlert.isHidden = true

    }
    @IBAction func btnProceedAlert(_ sender: Any) {
        self.viewAlert.isHidden = true
        
        webserviceForTenantNotify()

    }
    
    //MARK: local Function -
    
   
    func UiDesign(){
        
        self.btnCancelAlert.layer.cornerRadius = 20
        self.btnCancelAlert.layer.borderWidth = 0.5
        self.btnCancelAlert.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        btnCancelAlert.layer.masksToBounds = true
        
        self.btnProceedAlert.layer.cornerRadius = 20
        self.btnProceedAlert.layer.borderWidth = 0.5
        self.btnProceedAlert.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        btnProceedAlert.layer.masksToBounds = true
        
        viewheaderAlert.setViewRadius10()
        viewAlertContainer.setShadowAllView()
        viewAlertContainer.setViewCornerRadius()
        imgtanantDetail.setImgCircleColor()
        view1.setViewRadius()
        view1.setshadowView()
    }
}
//MARK: Variable-

extension TanantDetailsVC :UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTenantPropertyL.count    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TanantDetailsCell", for: indexPath) as! TanantDetailsCell
        let obj = arrTenantPropertyL[indexPath.row]
        
        cell.lblPropertyName.text = obj.name
        cell.lblPropertyAddress.text = obj.address
        let strimage = obj.profile_picture ?? ""
        let urlImg = URL(string: strimage)
        cell.imgProperty.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "property-placeholder"))
        
        cell.btnNotify.addTarget(self, action: #selector(notifyButtonClicked), for: .touchUpInside)
        
        cell.btnNotify.tag = indexPath.row

        if obj.isDue == "0"{
            cell.btnNotify.isHidden = true
            cell.viewNotify.isHidden = true
        }else {
            cell.btnNotify.isHidden = false
            cell.viewNotify.isHidden = false

        }
        return cell
        
    }
    @objc func notifyButtonClicked(sender : UIButton!) {
        let buttonTag = sender.tag
               print(buttonTag)
               let obj = self.arrTenantPropertyL[sender.tag]
               print(obj)
        tenantid = String(obj.user_id)
        propertyId = String(obj.propertyID)
        
        self.viewAlert.isHidden = false
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
        if isfromOwnerDetail == true{
            
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TenantPropertyDetail_VC") as! TenantPropertyDetail_VC
                      let obj = arrTenantPropertyL[indexPath.row]
                      vc.strPropertyName = obj.name ?? ""
                      vc.strPropertyAddress = obj.address ?? ""
                      vc.strPropertyImage = obj.profile_picture
                       vc.strUserId = "\(obj.user_id)"
                      vc.strPropertyID = "\(obj.propertyID)"

                      self.navigationController?.pushViewController(vc, animated: true)
        }
       
       }
    
}


extension TanantDetailsVC{
    func getlist(){
        SVProgressHUD.show()
//
//        let param = [WsParam.owner_id:objAppSharedata.UserDetail.strUserID,
//                     WsParam.tenant_id:objData.user_id] as [String : Any]

       
        objWebServiceManager.requestGet(strURL: WsUrl.gettenantProlist+String(objAppShareData.UserDetail.strUserID)+"/tenant/"+String(userID)+"?limit="+String(self.limit)+"&offset="+String(self.offset), params:nil, queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            SVProgressHUD.dismiss()
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
            if status == "success"{
                let data = response["data"] as? [String:Any] ?? [:]
                let tenantlist = data["tenant_property_list"] as? [String:Any] ?? [:]
                self.totalRecords = data["total_records"] as? Int ?? 0

                
                      if let data = response["data"]as? [String:Any]{
                                     if let arrTenantList = data["tenant_property_list"]as? [[String:Any]]{
                                         for dic in arrTenantList{
                                             let obj = PropertyModel.init(dict: dic)
                                             self.arrTenantPropertyL.append(obj)
                                             print(obj)
                                         }
                                        self.tableview.reloadData()
                                     }else{
                                  //   self.arrownerList.removeAll()
                                     }
                        }
            }else{
                SVProgressHUD.dismiss()
                objAlert.showAlert(message: message, title: "Alert", controller: self)
            }
        }) { (error) in
            print(error)
        }
    }
}

extension TanantDetailsVC{
    func webserviceForTenantNotify(){
        SVProgressHUD.show()

        let param = [WsParam.property_id:propertyId,
                     WsParam.tenant_id:tenantid] as [String : Any]

        objWebServiceManager.requestPost(strURL: WsUrl.TenantDueNotify, queryParams: [:], params: param, strCustomValidation: "", showIndicator: false, success: { (response) in
         print(response)
            SVProgressHUD.dismiss()
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
            if status == "success"{
                let data = response["data"] as? [String:Any] ?? [:]
                let tenantlist = data["tenant_property_list"] as? [String:Any] ?? [:]
                
                      if let data = response["data"]as? [String:Any]{
                                     if let arrTenantList = data["tenant_property_list"]as? [[String:Any]]{
                                         for dic in arrTenantList{
                                             let obj = PropertyModel.init(dict: dic)
                                             self.arrTenantPropertyL.append(obj)
                                             print(obj)
                                         }
                                        self.tableview.reloadData()
                                     }else{
                                  // self.arrownerList.removeAll()
                                     }
                        }
            }else{
                SVProgressHUD.dismiss()
                objAlert.showAlert(message: message, title: "Alert", controller: self)
            }
        }) { (error) in
            print(error)
        }
    }
}
//MARK:- Paggination Logic
extension TanantDetailsVC{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < 0 {
            print("up")
        }else{
            if ((tableview.contentOffset.y + tableview.frame.size.height) >= tableview.contentSize.height)
            {
                if !isDataLoading{
                    isDataLoading = true
                    
                    self.offset = self.offset+self.limit
                    
                    if arrTenantPropertyL.count != totalRecords {
                                self.getlist()
()
                    }else {
                        print("All records fetched")
                    }
                }
            }
        }
    }
}
