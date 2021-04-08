//
//  ContactOwnerVCViewController.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 17/04/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import SVProgressHUD

class ContactOwnerVC: UIViewController {
    
    var limit:Int=10
    var offset:Int=0
    var isdataLoading:Bool=false
    var ownerid = 0
    var totalRecords = Int()
    var arrownerTenantList = [PropertyDetail]()
    
    @IBOutlet weak var tblview: UITableView!
    
    @IBOutlet weak var lblprofileName: UILabel!
    @IBOutlet weak var imgProfileimg: UIImageView!
    @IBOutlet weak var viewimg: UIView!
    @IBOutlet weak var viewContent: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Uidesign()
        self.userDetails()
        self.tblview.tableFooterView = UIView()
     
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.userDetails()
        
        self.limit = 20
        self.offset = 0
        self.arrownerTenantList.removeAll()
        self.tblview.delegate = self
        self.tblview.dataSource = self
        self.OwnerPropertyList()
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBAction func btnback(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func Uidesign(){
        self.imgProfileimg.setImgCircle()
        self.viewimg.setviewCirclewhite()
        self.viewimg.setshadowViewCircle()
        self.viewContent.setViewRadius10()
        self.viewContent.setshadowView()
        
        
        //  self.viewAlertContainer.setshadowViewCircle()
        
    }
    func userDetails(){
        ownerid = UserDefaults.standard.value(forKey: UserDefaults.KeysDefault.ownerid) as! Int
        
        let firstname = UserDefaults.standard.value(forKey: UserDefaults.KeysDefault.firstname)
        let profileimg = UserDefaults.standard.value(forKey: UserDefaults.KeysDefault.profile)
        lblprofileName.text = firstname as? String
        let strimage = profileimg
        let urlImg = URL(string: strimage as! String)
        self.imgProfileimg.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "profile_ico"))
    }
}
//MARK: UITableViewDelegate,UITableViewDataSource  -


extension ContactOwnerVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrownerTenantList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "OwnerContactCell", for: indexPath) as! OwnerContactCell
        let obj1 = arrownerTenantList[indexPath.row]
        cell1.lblPropertyName.text = obj1.name
        cell1.lblPropertyAddress.text = obj1.address
        let strimage = obj1.property_image ?? ""
        let urlImg = URL(string: strimage)
        cell1.imgMyProperty.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "property-placeholder"))
        
        return cell1
    }
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TanantDetailsVC") as! TanantDetailsVC
    //        let obj = arrownerTenantList[indexPath.row]
    //        // print("name is \(obj.)")
    //
    //        self.navigationController?.pushViewController(vc, animated: true)
    //    }
    //
    
}

extension ContactOwnerVC{
    func OwnerPropertyList(){
        SVProgressHUD.show()
        self.view.endEditing(true)
        objWebServiceManager.requestGet(strURL: WsUrl.OwnerProTenantlist+String(ownerid)+"/property?"+"limit="+String(self.limit)+"&offset="+String(self.offset), params: nil, queryParams: [:], strCustomValidation: "",success: { (response) in
            print(response)
            self.totalRecords = response["total_records"] as? Int ?? 0
            
            let message = response["message"] as? String ?? ""
            let status = response["status"] as? String ?? ""
            let datafound = Int(response["data_found"] as? String ?? "") ?? 0
            print(datafound)
            
            if   status == "success" {
                SVProgressHUD.dismiss()
                if let data = response["data"]as? [String:Any]{
                    
                    if let arrTenantList = data["owner_property_list"]as? [[String:Any]]{
                        for dic in arrTenantList{
                            let obj = PropertyDetail.init(dict: dic)
                            self.arrownerTenantList.append(obj)
                            print(obj)
                        }
                        
                    }else{
                        self.tblview.reloadData()
                        
                    }
                    self.tblview.reloadData()
                    
                }
            }
                
            else{
                
                SVProgressHUD.dismiss()
                if message == "k_sessionExpire"{
                    objAlert.showAlert(message: k_sessionExpire, title: kAlertTitle, controller: self)
                    objAppShareData.resetDefaultsAlluserInfo()
                    objAppDelegate.showLogInNavigation()
                }  else{
                    objAlert.showAlert(message:message, title: kAlertTitle, controller: self)
                }
            }
            
            
            
        }, failure: { (error) in
            print(error)
            SVProgressHUD.dismiss()
            objAlert.showAlert(message: kErrorMessage, title: kAlertTitle, controller: self)
        })
        
    }
    
    
}
//MARK:- Paggination Logic
extension ContactOwnerVC{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isdataLoading = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < 0 {
            print("up")
        }else{
            if ((tblview.contentOffset.y + tblview.frame.size.height) >= tblview.contentSize.height)
            {
                if !isdataLoading{
                    isdataLoading = true
                    
                    self.offset = self.offset+self.limit
                    
                    if arrownerTenantList.count != totalRecords {
                        OwnerPropertyList()
                    }else {
                        print("All records fetched")
                    }
                }
            }
        }
    }
}
