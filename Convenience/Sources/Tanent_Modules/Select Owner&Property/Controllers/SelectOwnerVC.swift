//
//  SelectOwnerVC.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 13/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import SVProgressHUD
import GooglePlaces
import GoogleMaps
import INTULocationManager
import SDWebImage

class SelectOwnerVC: UIViewController{
    
    //MARK:IBOutlet-
    
    @IBOutlet weak var viewNoDataFound: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var imgSearchIcon: UIImageView!
    @IBOutlet weak var viewSearchbar: UIView!
    @IBOutlet weak var btnView: UIView!
    
    //MARK:Variables-
    var address = ""
    var strCity = ""
    var strState = ""
    var strCountry = ""
    var strlat = ""
    var strlong = ""
    var selectedUserId = Int()
    
    var isSearching:Bool=false
    var isDataLoading:Bool=false
    var limit:Int=10
    var offset:Int=0
    var totalRecords = 0
    var strSearchText = ""
    
    var isSearch = false
    var arrownerList = [OwnerModel]()
    var modelarray = [OwnerModel]()
    var ownerFilterList  = [OwnerModel]()
    
    
    //MARK:AppLifeCycle-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewNoDataFound.isHidden = true
        self.txtSearch.delegate = (self as UITextFieldDelegate)
        
        ownerFilterList=modelarray
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UiDesign()
        self.arrownerList.removeAll()
        self.limit = 10
        self.offset = 0
        self.getOwnerList()
        
    }
    
    //MARK:Buttons-
    
    @IBAction func btnSearchList(_ sender: Any) {
        
    }
    @IBAction func btnback(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:Local Functions-
    
    func UiDesign(){
        self.btnView.layer.masksToBounds = true
        self.btnView.layer.cornerRadius = 20
        btnView.layer.maskedCorners = [ .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        viewContent.setViewRadius()
        viewContent.setshadowView()
        viewSearchbar.setShadowAllView2()
        // btnView.setViewRadius()
    }
}


//MARK:TableView-

extension SelectOwnerVC : UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrownerList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "SelectOwerTableViewCell", for: indexPath) as! SelectOwerTableViewCell
        let obj = arrownerList[indexPath.row]
        
        let strimage = obj.profileimg ?? ""
        let urlImg = URL(string: strimage)
        let selectedUserId = obj.owner_id ?? 0
        print(selectedUserId)
        cell.imgOwnerImage.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "user_img"))
        let firstname = obj.firstName ?? ""
        let lastname = obj.lastName ?? ""
        cell.lblName.text = "\(firstname) \(lastname)"
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = arrownerList[indexPath.row]
        selectedUserId = obj.owner_id ?? 0
        print(selectedUserId)
        
        let vc = UIStoryboard.init(name: "Tanentside", bundle: Bundle.main).instantiateViewController(withIdentifier: "SelectPropertyVC") as? SelectPropertyVC
        
        vc?.userid = selectedUserId
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Swift 4.2 onwards
        return  65
    }
}
//MARK: - searching operation
extension SelectOwnerVC : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        let text = textField.text! as NSString
        
        if (text.length == 1) && (string == "") {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
            self.strSearchText = ""
            self.arrownerList.removeAll()
            self.limit = 10
            self.offset = 0
            //self.reload()
            self.isSearching = true
            self.perform(#selector(self.reload), with: nil, afterDelay: 0.5)
            
        }else{
            var substring: String = textField.text!
            substring = (substring as NSString).replacingCharacters(in: range, with: string)
            substring = substring.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            self.isSearching = true
            searchAutocompleteEntries(withSubstring: substring)
        }
        return true
    }
    
    
    func searchAutocompleteEntries(withSubstring substring: String) {
        if substring != "" {
            strSearchText = substring
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
            self.perform(#selector(self.reload), with: nil, afterDelay: 0.5)
        }
    }
    
    @objc func reload() {
        self.arrownerList.removeAll()
        self.limit = 10
        self.offset = 0
        self.getOwnerList()
    }
}
extension SelectOwnerVC{
    func getOwnerList(){
        if self.isSearching == false{
            SVProgressHUD.show()
        }
        if isaddMoreProperty == true {
            AccountManager.sharedInstance.isonboarding = false
        }else{
            AccountManager.sharedInstance.isonboarding = true
            
        }
        objWebServiceManager.requestGet(strURL: WsUrl.SelectOwnerlist+"offset="+String(self.offset)+"&limit="+String(self.limit)+"&term="+self.strSearchText, params: nil , queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            
            let message = response["message"] as? String ?? ""
            let status = response["status"] as? String ?? ""
            var datafound = 0
            let data = response["data"]as? [String:Any] ?? [:]
            if let df = data["data_found"] as? String{
                datafound = Int(df) ?? 0
            }else if let df = data["data_found"] as? Int{
                datafound = df
            }
            
            self.isSearching = false
            
            if let df = data["total_records"] as? String{
                self.totalRecords = Int(df) ?? 0
            }else if let df = data["total_records"] as? Int{
                self.totalRecords = df
            }
            
            if   status == "success" {
                SVProgressHUD.dismiss()
                if let data = response["data"]as? [String:Any]{
                    if let arrOwnerlist = data["owner_list"]as? [[String:Any]]{
                        for dic in arrOwnerlist{
                            let obj = OwnerModel.init(dict: dic)
                            self.arrownerList.append(obj)
                            print(obj)
                        }
                    }else{
                        //   self.arrownerList.removeAll()
                        self.tableView.reloadData()
                    }
                    print(self.arrownerList.count)
                    print(self.arrownerList)
                    self.tableView.reloadData()
                    
                }
                SVProgressHUD.dismiss()
                if datafound == 0{
                    if self.arrownerList.count == 0{
                        self.viewNoDataFound.isHidden = false
                    }else{
                        self.viewNoDataFound.isHidden = true
                    }
                }else{
                    self.viewNoDataFound.isHidden = true
                }
                self.tableView.reloadData()
            }else{
                
                self.arrownerList.removeAll()
                self.limit = 10
                self.offset = 0
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


//MARK:- Paggination Logic
extension SelectOwnerVC{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < 0 {
            print("up")
        }else{
            if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height)
            {
                if !isDataLoading{
                    isDataLoading = true
                    
                    self.offset = self.offset+self.limit
                    
                    if arrownerList.count != totalRecords {
                        getOwnerList()
                    }else {
                        print("All records fetched")
                    }
                }
            }
        }
    }
}





//MARK: - searching operation
//extension SelectOwnerVC : UITextFieldDelegate{
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
//
//        do {
//            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z] .*", options: [])
//            if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil {
//                return false
//            }
//        }
//        catch {
//            print("ERROR")
//        }
//
//        let text = textField.text! as NSString
//
//        if (text.length == 1) && (string == "") {
//            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
//            self.strSearchText = ""
//            self.arrownerList.removeAll()
//            self.limit = 10
//            self.offset = 0
//            self.perform(#selector(self.searchProduct), with: nil, afterDelay: 2)
//
//        }
//        var substring: String = textField.text!
//        substring = (substring as NSString).replacingCharacters(in: range, with: string)
//        substring = substring.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//        searchAutocompleteEntries(withSubstring: substring)
//        return true
//    }
//
//    @objc func searchProduct(){
//        print("called")
//        self.getOwnerList()
//    }
//
//    func searchAutocompleteEntries(withSubstring substring: String) {
//        if substring != "" {
//            self.strSearchText = substring
//            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
//            self.perform(#selector(self.reload), with: nil, afterDelay: 2)
//        }
//    }
//
//    @objc func reload() {
//        self.arrownerList.removeAll()
//        self.limit = 10
//        self.offset = 0
//        self.getOwnerList()
//    }
//
//}

