//
//  SelectPropertyVC.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 13/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage


class SelectPropertyVC: UIViewController {
    
    //MARK: Variables -
    //   var selecteddata = [OwnerPropertyModel]()
    var arrSelectProperty = [SelectePropertyModel]()
    var arrPropertyLiSt = [OwnerPropertyModel]()
    
    var selectedIndexPath: IndexPath?
    var showImageIndex : Int?
    var userid = 0
    
    var isDataLoading:Bool=false
    var limit:Int=20
    var offset:Int=0
    var totalRecords = Int()
    
    //MARK:IBOutlet-
    @IBOutlet weak var viewNoDataFound: UIView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var imgback: UIImageView!
    @IBOutlet weak var btnbone: customButton!
    @IBOutlet weak var txteRentAmount: UITextField!
    @IBOutlet weak var viewAlert: UIView!
    @IBOutlet weak var viewAlertContainer: UIView!
    @IBOutlet weak var viewheaderAlert: customView!
    
    //MARK:AppLifeCycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userid)
        
        
        self.viewAlert.isHidden = true
        self.TableView.allowsMultipleSelection = false
        self.TableView.tableFooterView = UIView()
        
        self.UIDesign()
        //print(AccountManager.sharedInstance.userInfo)
        //    print(objAppShareData.arrSelectedData.count)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated )
        self.getPropertyListApi()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:buttons-
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnAlertDone(_ sender: Any) {
           
        
    }
    
    
    @IBAction func btnDone(_ sender: Any) {
        
        
        let storyBoard = UIStoryboard(name: "Tanentside", bundle:nil)
        let GrabBetterPropertyVC = storyBoard.instantiateViewController(withIdentifier: "GrabBetterPropertyVC") as! GrabBetterPropertyVC
 
        self.navigationController?.pushViewController(GrabBetterPropertyVC, animated: true)
        
        
}
    //MARK: Local Function-
    
    func UIDesign(){
        btnbone.layer.cornerRadius = 20
        btnbone.clipsToBounds = true
        viewheaderAlert.setViewRadius10()
        viewheaderAlert.setshadowView()
        viewContent.setViewRadius()
        viewContent.setshadowView()
        viewAlertContainer.setViewCornerRadius()
        viewAlertContainer.setShadowAllView10()
        // Do any additional setup after loading the view.
        
        
    }
}
//MARK:UITableViewDelegate,UITableViewDataSource-

extension SelectPropertyVC : UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPropertyLiSt.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "SelectPropertyCell", for: indexPath) as! SelectPropertyCell
        let obj = arrPropertyLiSt[indexPath.row]
        
        cell.lblPropertyName.text? = obj.name ?? ""
        cell.lblPropertyAddress.text? = obj.address ?? ""
        let strimage = obj.image ?? ""
        let urlImg = URL(string: strimage)
        cell.imgPropertyImage.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "property-placeholder"))
    
       
        if objAppShareData.selecteddata.contains(obj){
            cell.imgPropertySelection.image = #imageLiteral(resourceName: "select_ico")
            
        }else{
            cell.imgPropertySelection.image = nil
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.arrPropertyLiSt[indexPath.row]
        
        if objAppShareData.selecteddata.contains(obj){
            let index = objAppShareData.selecteddata.index(of: obj)
            objAppShareData.selecteddata.remove(at:index!)
            
        }else{
            objAppShareData.selecteddata.append(obj)
        }

        print(objAppShareData.selecteddata.count)
        tableView.reloadData()
    }
}

extension SelectPropertyVC{
    func getPropertyListApi(){
        SVProgressHUD.show()
        self.view.endEditing(true)
        
        objWebServiceManager.requestGet(strURL: WsUrl.SelectedPropertyList+String(self.userid)+"/near-property?"+"offset="+String(self.offset)+"&limit="+String(self.limit), params: nil, queryParams: [:], strCustomValidation: "",success: { (response) in
            print(response)
            
            let message = response["message"] as? String ?? ""
            let status = response["status"] as? String ?? ""
            let datafound = Int(response["data_found"] as? String ?? "") ?? 0
            self.totalRecords = Int(response["total_records"] as? String ?? "") ?? 0
            print(datafound)
            
            if   status == "success" {
                SVProgressHUD.dismiss()
                if let data = response["data"]as? [String:Any]{
                    if let arrOwnerlist = data["property_list"]as? [[String:Any]]{
                        
                        for dic in arrOwnerlist{
                            let obj = OwnerPropertyModel.init(dict: dic)
                            self.arrPropertyLiSt.append(obj)
                            print(obj)
                        }
                    }
                    print(self.arrPropertyLiSt.count)
                    print(self.arrPropertyLiSt)
                    self.TableView.reloadData()
                    
                }
                if datafound == 0{
                    if self.arrPropertyLiSt.count == 0{
                        self.viewNoDataFound.isHidden = false
                        
                    }else{
                        self.viewNoDataFound.isHidden = true
                        
                    }
                }else{
                    self.viewNoDataFound.isHidden = true
                    
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
        }, failure: { (error) in
            print(error)
            SVProgressHUD.dismiss()
            //  objAppShareData.showAlert(title: "Something went wrong.", message: kErrorMessage, view: self)
        })
        
    }
}

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}

/*

 }
 }
 //MARK:UITableViewDelegate,UITableViewDataSource-
 
 extension SelectPropertyVC : UITableViewDelegate,UITableViewDataSource{

 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
 let cell=tableView.dequeueReusableCell(withIdentifier: "SelectPropertyCell", for: indexPath) as! SelectPropertyCell
 let obj = arrPropertyLiSt[indexPath.row]
 
 cell.lblPropertyName.text? = obj.name ?? ""
 cell.lblPropertyAddress.text? = obj.address ?? ""
 let strimage = obj.image ?? ""
 let urlImg = URL(string: strimage)
 cell.imgPropertyImage.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "user_img"))
 
 if obj.isSelected == true{
 cell.imgPropertySelection.image = #imageLiteral(resourceName: "select_ico")
 
 }else{
 cell.imgPropertySelection.image = nil
 
 }
 
 
 return cell
 }
 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 let obj = self.arrPropertyLiSt[indexPath.row]
 
 if obj.isSelected == true{
 obj.isSelected = false
 }else{
 for obj1 in self.arrPropertyLiSt{
 obj1.isSelected = false
 //selecteddata.removeAll()
 
 }
 //selecteddata.removeAll()
 obj.isSelected = true
 selecteddata.append(obj)
 }
 print(self.selecteddata.count)
 
 tableView.reloadData()

 }
 }
 */
