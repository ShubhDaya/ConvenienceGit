//
//  GrabBetterPropertyVC.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 13/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import SVProgressHUD
import UIKit
import GooglePlaces
import GoogleMaps

var isaddMoreProperty = false

class GrabBetterPropertyVC: UIViewController{
    
    //MARK: Variables -
    var address = ""
    var strCity = ""
    var strState = ""
    var strCountry = ""
    var strlat = ""
    var strlong = ""
    var isFromAdd = false
    var GrabProperty = [OwnerPropertyModel]()
    var OwnerArray2 = [String]()
    var Sortedarray  = [String]()
    var arrnewshared = [""]
    let OwnerPicArray = [#imageLiteral(resourceName: "3-1"),#imageLiteral(resourceName: "3-4"),#imageLiteral(resourceName: "7-1"),#imageLiteral(resourceName: "7-1"),#imageLiteral(resourceName: "4-3"),#imageLiteral(resourceName: "img 1"),#imageLiteral(resourceName: "7"),#imageLiteral(resourceName: "3"),#imageLiteral(resourceName: "4"),#imageLiteral(resourceName: "4")]
    var id = ""
    var ids = ""
    var isFromSignUp = false
    
    //MARK: IBOutlet-
    
    @IBOutlet weak var btnSkipOnboarding: UIButton!
    @IBOutlet weak var lblHeaderName: UILabel!
    @IBOutlet weak var viewNodata: UIView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var imgBackArrow: UIImageView!
    
    //MARK: AppLifeCycle-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.tableFooterView = UIView()
        self.btnSkipOnboarding.isHidden = false
        self.imgBackArrow.isHidden = true
        self.btnback.isHidden = true
        
        print(iscome)
        print(GrabProperty.count)
        
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if  iscome == true{
            self.btnSkipOnboarding.isHidden = true
            self.btnback.isHidden = false
            self.imgBackArrow.isHidden = false
            iscome = false
            
        }else if isCommingFrom == true{
            
            self.btnSkipOnboarding.isHidden = true
        }
        
        else {
            self.btnback.isHidden = true
            self.imgBackArrow.isHidden = true
        }
        
        if objAppShareData.selecteddata.count != 0{
            self.viewNodata.isHidden = true
            
            for i in objAppShareData.selecteddata{
                id  = String(id)+","+String(i.propertyID ?? 0)
            }
            print(id)
            id.removeFirst()
            print(id)
        }else{
            self.btnback.isHidden = false
            self.imgBackArrow.isHidden = false
            self.viewNodata.isHidden = false
            self.lblHeaderName.text = "Property List"
        }
        
        
        let isEnable = self.checkForLocation()
        if !isEnable{
            self.showAlertForLocation()
        }else{
            self.getLocation()
        }
        viewContent.setViewRadius()
        viewContent.setshadowView()
        viewNodata.setViewRadius()
        viewNodata.setshadowView()
        //        GrabProperty.append(objAppShareData.arrSelectedData)
        //        Sortedarray = uniqueElementsFrom(array:OwnerArray2)
        print(Sortedarray)
        if objAppShareData.selecteddata.count == 0{
            self.viewNodata.isHidden = false
            
        }
    }
    
    //MARK:  Buttons-
    @IBAction func btnAddMorProperty(_ sender: Any) {
        // var isaddMoreProperty = true
        
        let storyBoard = UIStoryboard(name: "Tanentside", bundle:nil)
        let SelectOwnerVC = storyBoard.instantiateViewController(withIdentifier: "SelectOwnerVC") as! SelectOwnerVC
        self.navigationController?.pushViewController(SelectOwnerVC, animated: false)
    }
    
    @IBAction func btnAddProperty(_ sender: Any) {
        let isEnable = self.checkForLocation()
        if !isEnable{
            self.showAlertForLocation()
        }else{
            if self.strlat.count == 0{
                self.isFromAdd = true
                self.getLocation()
            }else{
                self.callWebserviceForUpdateLocation()
            }
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        if isCommingFrom == true {
            self.navigationController?.popToRootViewController(animated: false)
            if let tabBarController = objAppDelegate.window!.rootViewController as? TabBarVC {
                tabBarController.selectedIndex = 1
            }
        }else{
            navigationController?.popViewController(animated: true)
            
        }
    }
    
    @IBAction func btnSkipOnboarding(_ sender: Any) {
        
        self.callWSForEmailSip()
    }
    
    @IBAction func btnContinue(_ sender: Any) {
        self.onboarding()
        self.GrabPropertyTenantApi()
        //        let storyBoard = UIStoryboard(name: "Tanentside", bundle:nil)
        //        let AddPaymentVC = storyBoard.instantiateViewController(withIdentifier: "AddPaymentVC") as! AddPaymentVC
        //        self.navigationController?.pushViewController(AddPaymentVC, animated: true)
    }
    
    func checkForLocation() -> Bool {
        var isEnable = false
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted:
                print("No access")
            // self.showAlertForLocation()
            case .denied:
                print("No access")
            // self.showAlertForLocation()
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                if objAppShareData.strLat.count == 0{
                    self.showAlertForLocation()
                }else{
                    isEnable = true
                }
            default:
                break
            }
        } else {
            self.showAlertForLocation()
            print("Location services are not enabled")
        }
        return isEnable
    }
    func showAlertForLocation(){
        let alertVC = UIAlertController(title: "Alert" , message: "If you want to grab new property first you have to enable your location!", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Go to Settings", style: UIAlertAction.Style.cancel) { (alert) in
            let url = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        }
        alertVC.addAction(okAction)
        DispatchQueue.main.async {
            //            var presentVC = self.window?.rootViewController
            //            while let next = presentVC?.presentedViewController {
            //                presentVC = next
            //            }
            //            presentVC?.present(alertVC, animated: true, completion: nil)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func onboarding(){
        
        if AccountManager.sharedInstance.isonboarding == true{
            // checkOnboarding = "true"
            UserDefaults.standard.set(AccountManager.sharedInstance.isonboarding, forKey:"onboard")
            UserDefaults.standard.set(checkOnboarding, forKey: "onboarding" )
            print(AccountManager.sharedInstance.isonboarding)
            // print(checkOnboarding)
            
        }else if AccountManager.sharedInstance.isonboarding == false {
            
            // checkOnboarding = "false"
            UserDefaults.standard.set(AccountManager.sharedInstance.isonboarding, forKey:"onboard")
            UserDefaults.standard.set(checkOnboarding, forKey: "onboarding" )
            //print(checkOnboarding)
            print(AccountManager.sharedInstance.isonboarding)
        }
    }
}

extension GrabBetterPropertyVC : UITableViewDelegate,UITableViewDataSource{
    
    //MARK:TableView-
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objAppShareData.selecteddata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "BetterPropertyCell", for: indexPath) as! BetterPropertyCell
        let obj = objAppShareData.selecteddata[indexPath.row]
        
        cell.btnDeleteRow.tag = indexPath.row
        
        let strimage = objAppShareData.selecteddata[indexPath.row].image ?? ""
        let urlImg = URL(string: strimage)
        cell.imgPropertyImage.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "property-placeholder"))
        cell.lblPropertyName.text = objAppShareData.selecteddata[indexPath.row].name
        cell.lblPropertyAddress.text = objAppShareData.selecteddata[indexPath.row].address
        //        cell.indexPath = indexPath
        //        cell.btnDeleteRow{}
        cell.btnDeleteRow.addTarget(self, action: #selector(btnDeleteRow), for: .touchUpInside)
        
        return cell
    }
    
    @objc func btnDeleteRow(sender : UIButton!) {
        
        let point =  sender.convert(CGPoint.zero, to: tableview)
        guard let indexPath = tableview.indexPathForRow(at: point)else{return}
        objAppShareData.selecteddata.remove(at: indexPath.row)
        tableview.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: UITableView.RowAnimation.left)
        tableview.reloadData()
        if objAppShareData.selecteddata.count == 0 {
            self.btnback.isHidden = false
            self.imgBackArrow.isHidden = false
            self.viewNodata.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = objAppShareData.selecteddata[indexPath.row]
    }
}

extension GrabBetterPropertyVC{
    func GrabPropertyTenantApi(){
        print(checkOnboarding)
        if isCommingFrom == false{
            AccountManager.sharedInstance.isonboarding = true
            
        }else if isCommingFrom == true{
            AccountManager.sharedInstance.isonboarding = false
            
        }
        onboarding()
        
        SVProgressHUD.show()
        let param = [WsParam.property_id:String(self.id),
                     WsParam.onboarding:checkOnboarding] as [String : Any]
        print(param)
        objWebServiceManager.requestPost(strURL: WsUrl.GrabPropertyTenant, queryParams: [:], params: param, strCustomValidation: "", showIndicator: false, success: { response in
            print(response)
            SVProgressHUD.dismiss()
            
            let status = (response["status"] as? String)
            let message = response["message"] as? String ?? ""
            
            if status == k_success {
                SVProgressHUD.dismiss()
                objAppShareData.selecteddata.removeAll()
                AccountManager.sharedInstance.isonboarding = true
                let usertype = objAppSharedata.UserDetail.strUserType
                let usertype1 = UserDefaults.standard.string(forKey: UserDefaults.KeysDefault.kUserType)
                print(usertype1)
                print(usertype)
                if usertype == "tenant"{
                    
                    if isCommingFrom == true {
                        
                        // objAppDelegate.showTenantTabbarNavigation()
                        self.view.endEditing(true)
                        self.navigationController?.popToRootViewController(animated: false)
                        if let tabBarController = objAppDelegate.window!.rootViewController as? TabBarVC {
                            tabBarController.selectedIndex = 1
                        }
                        
                    }else{
                        let storyBoard = UIStoryboard(name: "Tanentside", bundle:nil)
                        let AddPaymentVC = storyBoard.instantiateViewController(withIdentifier: "AddPaymentVC") as! AddPaymentVC
                        self.navigationController?.pushViewController(AddPaymentVC, animated: true)
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
        },failure: { (error) in
            print(error)
            SVProgressHUD.dismiss()
            AccountManager.sharedInstance.isonboarding = false
            objAlert.showAlert(message:kErrorMessage, title: "Alert", controller: self)
        })
    }
}
extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var alreadyAdded = Set<Iterator.Element>()
        return self.filter { alreadyAdded.insert($0).inserted }
    }
}

extension GrabBetterPropertyVC {
    func  callWebserviceForUpdateLocation(){
        SVProgressHUD.show()
        self.view.endEditing(true)
        let param = [WsParam.current_location:self.address,
                     WsParam.current_city:self.strCity,
                     WsParam.current_country:self.strCountry,
                     WsParam.current_latitude:self.strlat,
                     WsParam.current_longitude:self.strlong
                     
        ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestPut(strURL: WsUrl.updateUserLocation, queryParams: [:], params: param, strCustomValidation: "", showIndicator: true, success:{response in
            SVProgressHUD.dismiss()
            
            print(response)
            let status = (response["status"] as? String)
            let status_code = (response["200"] as? String)
            let message = response["message"] as? String ?? ""
            
            
            if status == k_success{
                SVProgressHUD.dismiss()
                
                if (response["data"]as? [String:Any]) != nil{
                    if status == "success" || status_code == "200"
                    {
                        let dic = response["data"] as? [String:Any]
                        _  = dic!["user_details"] as? [String:Any]
                        
                        let storyBoard = UIStoryboard(name: "Tanentside", bundle:nil)
                        let SelectOwnerVC = storyBoard.instantiateViewController(withIdentifier: "SelectOwnerVC") as! SelectOwnerVC
                        self.navigationController?.pushViewController(SelectOwnerVC, animated: true)
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
        }, failure: { (error) in
            print(error)
            SVProgressHUD.dismiss()
            //  objAppShareData.showAlert(title: kAlertTitle, message: kErrorMessage, view: self)
        })
    }
}

extension GrabBetterPropertyVC {
    func getLocation(){
        if self.isFromAdd{
            SVProgressHUD.show()
        }
        PlacePicker.shared.getUsersCurrentLocation(success: { (CLLocationCoordinate2D) in
            print(CLLocationCoordinate2D)
            let lat = CLLocationCoordinate2D.latitude
            let long = CLLocationCoordinate2D.longitude
            print(lat)
            print(long)
            let Cordinate = type(of: CLLocationCoordinate2D).init(latitude: lat, longitude: long)
            
            PlacePicker.shared.reverseGeocodeCoordinate(Cordinate, success: { (addressModel) in
                self.address  = addressModel.address ?? ""
                self.strCity = addressModel.city ?? ""
                self.strState = addressModel.state ?? ""
                self.strCountry = addressModel.country ?? ""
                self.strlong = addressModel.lng ?? ""
                self.strlat = addressModel.lat ?? ""
                
                print(self.address)
                print(self.strCity)
                if self.isFromAdd {
                    self.isFromAdd = false
                    self.callWebserviceForUpdateLocation()
                }else{
                }
            }) { (error) in
                SVProgressHUD.dismiss()
            }
        }) { (Error) in
            SVProgressHUD.dismiss()
            print(Error)
        }
    }
}

extension GrabBetterPropertyVC{
    func callWSForEmailSip(){
        SVProgressHUD.show()
        
        let param = ["step":"2"]
        objWebServiceManager.requestPut(strURL: WsUrl.skip_onboardingsStep, queryParams: [:], params: param, strCustomValidation: "", showIndicator: false, success: { (response) in
            print(response)
            SVProgressHUD.dismiss()
            let message = response["message"] as? String ?? ""
            
            let status = response["status"] as? String ?? ""
            let data = response["data"] as? [String:Any] ?? [:]
            var nextStep = ""
            if let step = data["next_step"] as? Int{
                nextStep = String(step)
            }else if let step = data["next_step"] as? String{
                nextStep = step
            }
            
            if status == "success" {
                SVProgressHUD.dismiss()
                
                let usertype = objAppSharedata.UserDetail.strUserType
                
                if usertype == "tenant" && nextStep == "3"{
                    // objAppDelegate.showTenantTabbarNavigation()
                    let storyBoard = UIStoryboard(name: "Tanentside", bundle:nil)
                    let AddPaymentVC = storyBoard.instantiateViewController(withIdentifier: "AddPaymentVC") as! AddPaymentVC
                    self.navigationController?.pushViewController(AddPaymentVC, animated: true)
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
        })
        { (error) in
            print(error)
            SVProgressHUD.dismiss()
            
        }
    }
    
    
}
