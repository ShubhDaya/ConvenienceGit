//
//  AddPropertyVC.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 11/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import GooglePlaces
import SVProgressHUD
import SDWebImage
import GoogleMaps
import INTULocationManager



class AddPropertyVC: UIViewController{
    
    var address = ""
    var strCity = ""
    var strState = ""
    var strCountry = ""
    var strlat = ""
    var strlong = ""
    // MARK: - Variables
    var latitude = 0.0
    var langtitue = 0.0
//    var formatedlong = 0.0
//    var formatedLat = 0.0
    let imagePicker = UIImagePickerController()
    var SelectedPropertyImage:UIImage? = nil
    
    // MARK: -  Outlets
    
    @IBOutlet weak var imgBackArrow: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var viewtxt2: UIView!
    @IBOutlet weak var viewtxt1: UIView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var imgproperty: UIImageView!
    @IBOutlet weak var txtPropertyName: UITextField!
    @IBOutlet weak var txtPropertyAddress: UITextField!
    @IBOutlet weak var imgCloseSelectedImage: UIImageView!
    @IBOutlet weak var btnCloseSelectedImage: UIButton!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblImage: UILabel!
    
    
    //MARK: - Variables
    var strLongitude = ""
    var strLatitude = ""
    
    
    // MARK: -  AppLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.txtPropertyAddress.delegate = self
        self.txtPropertyName.delegate = self
        self.imgCloseSelectedImage.isHidden = true
        self.btnCloseSelectedImage.isHidden = true
        print(iscame)

        self.iscome()
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIDesign()
        self.iscome()
     
    
        
    }
    func iscome(){
        if  iscame == true{
                     self.btnBack.isHidden = false
                     self.imgBackArrow.isHidden = false
                 }else {
                     self.btnBack.isHidden = true
                     self.imgBackArrow.isHidden = true

                 }
    }
    
    // MARK: -  Buttons-
    
    @IBAction func btnCloseSelectedImage(_ sender: Any) {
        self.view.endEditing(true)
        
        self.imgproperty.image =  nil
        self.lblImage.isHidden = false
        self.imgIcon.isHidden = false
        self.imgCloseSelectedImage.isHidden = true
        self.btnCloseSelectedImage.isHidden = true
        self.imgCloseSelectedImage.isHidden = true
    }
    
    @IBAction func btnUploadProperty(_ sender: Any) {
        self.view.endEditing(true)
        
        //        self.btnUploadImage.setTitleColor(UIColor.white, for: .normal)
        //        self.btnPicker.isUserInteractionEnabled = true
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera1()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { _ in
            if  self.imgproperty.image != nil {
                self.lblImage.isHidden = true
                self.imgIcon.isHidden = true
            }
            else {
                self.lblImage.isHidden = false
                self.imgIcon.isHidden = false
            }
        }))
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender as? UIView
            alert.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func btnAddProperty(_ sender: Any) {
        self.view.endEditing(true)
        self.onboarding()
        self.addPropertyValidation()
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated:true)
    }
    //MARK: ButtonPlacePickerAddress-
    
    @IBAction func btnSelecteAddressPlacePicker(_ sender: Any) {

        
        PlacePicker.shared.openPicker(controller: self, success: { (placeDict) in
            print("place info = \(placeDict)")
            self.txtPropertyAddress.text = placeDict["formattedAddress"] as? String ?? ""
            let straddress = self.txtPropertyAddress.text
            print(straddress ?? "")
            //self.txtCity.resizeForHeight()
            self.strLatitude = placeDict["lat"] as? String ?? ""
            print(self.strLatitude)
            self.strLongitude = placeDict["long"]
                as? String ?? ""
            print(self.strLongitude)

            let coordLat = placeDict["clat"] as? CLLocationDegrees ?? 0.0
            let coordLong = placeDict["clong"] as? CLLocationDegrees ?? 0.0
            
            let Cordinate = CLLocationCoordinate2D.init(latitude: coordLat, longitude: coordLong)
            PlacePicker.shared.reverseGeocodeCoordinate(Cordinate, success: { (addressModel) in
                self.txtPropertyAddress.text = addressModel.address ?? ""
                self.strCity = addressModel.city ?? ""
                self.strState = addressModel.state ?? ""
                self.strCountry = addressModel.country ?? ""

                if self.strCity == ""{
                    if self.strState == ""{
                        //self.txtCity.text = self.strCountry
                    }else{
                        // self.txtCity.text = self.strState
                    }
                }else{
                    // self.txtCity.text = self.strCity
                }
            }) { (error) in

                print("error in getting address.")
            }
        }) { (error) in
            print("error = \(error.localizedDescription)")
        }
        
    }
    
    //MARK:Local methods-
    func onboarding(){
       
         if AccountManager.sharedInstance.isonboarding == true{
             checkOnboarding = "true"
             UserDefaults.standard.set(AccountManager.sharedInstance.isonboarding, forKey:"onboard")
             UserDefaults.standard.set(checkOnboarding, forKey: "onboarding" )
             print(AccountManager.sharedInstance.isonboarding)
            //print(checkOnboarding)
             
        }else if AccountManager.sharedInstance.isonboarding == false {
                 
             checkOnboarding = "false"
             UserDefaults.standard.set(AccountManager.sharedInstance.isonboarding, forKey:"onboard")
             UserDefaults.standard.set(checkOnboarding, forKey: "onboarding" )
             //print(checkOnboarding)
             print(AccountManager.sharedInstance.isonboarding)
          }
        }

    func UIDesign (){
        viewtxt1.textviewRadius()
        viewtxt2.textviewRadius()
        viewContent.setViewRadius()
        imgproperty.setImgRadius()
        viewContent.setshadowView()
    }
    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D, success: @escaping (AddressModel)->(), failure: @escaping (Error)-> ()) {
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(coordinate.latitude)")!
        //21.228124
        let lon: Double = Double("\(coordinate.longitude)")!
        //72.833770
        let _: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        //let geocoder = GMSGeocoder()
        let geocoder: CLGeocoder = CLGeocoder()
        //print("coordinate = \(coordinate)")
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        geocoder.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                
                let pm = placemarks! as [CLPlacemark]
                placemarks
                if pm.count > 0 {
                    let pm = placemarks![0]
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    print(addressString)
                    
                    let currentAddress = AddressModel()
                    currentAddress.address = addressString
                    currentAddress.city = pm.locality
                    currentAddress.state = pm.administrativeArea
                    currentAddress.country = pm.country
                    currentAddress.zipCode = pm.postalCode
                    currentAddress.lat = String(center.latitude)
                    currentAddress.lng = String(center.longitude)
                    success(currentAddress)
                }
        })
    }
    
}
//MARK: Validation -

extension AddPropertyVC{
    
    func addPropertyValidation() {
        
        let strPropertyName = self.txtPropertyName.text?.count ?? 0
        let strPropertyAddressName = self.txtPropertyAddress.text?.count ?? 0
        self.txtPropertyName.text = self.txtPropertyName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtPropertyAddress.text = self.txtPropertyAddress.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if txtPropertyName.text?.isEmpty  == true  {
            objAlert.showAlert(message: BlankPropertyName, title:kAlertTitle, controller: self)
        }else if  strPropertyName < 4  {
            objAlert.showAlert(message: PropertyNameLenght, title:kAlertTitle, controller: self)
            
        } else if txtPropertyAddress.text?.isEmpty == true  {
            objAlert.showAlert(message: BlankPropertyAddress, title:kAlertTitle, controller: self
            )
        }
        else if strPropertyAddressName < 3{
            objAlert.showAlert(message: PropertyAddressLenght, title: kAlertTitle, controller: self)
        }else {
            self.onboarding()
            self.AddPropertyApiOwner()
        }
    }
    
    //MARK: Local Func -
    
}
//MARK: Imagepicker - Functions -
extension AddPropertyVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func openCamera1()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            imagePicker.modalPresentationStyle = .fullScreen
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Warning", message: "You don't have camera.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.modalPresentationStyle = .fullScreen
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imgproperty.image = nil
        imgproperty.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        SelectedPropertyImage = imgproperty.image
        self.imgCloseSelectedImage.isHidden = false
        self.btnCloseSelectedImage.isHidden = false
        self.lblImage.isHidden = true
        self.imgIcon.isHidden = true
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        if  self.imgproperty.image != nil {
            self.lblImage.isHidden = true
            self.imgIcon.isHidden = true
        }
        else {
            self.lblImage.isHidden = false
            self.imgIcon.isHidden = false
        }
        //        uploadImage(image: pickedImage)
        dismiss(animated: true, completion: nil)
    }
    
}


//MARK: UITextFiled Delegate-

extension AddPropertyVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.txtPropertyName{
            self.txtPropertyName.resignFirstResponder()
            self.txtPropertyName.resignFirstResponder()
           // self.txtPropertyAddress.becomeFirstResponder()
        }
//        else{
//           // self.txtPropertyName.resignFirstResponder()
//        }
        return true
    }
    
}

//MARK: AddPropertyAPI-

extension AddPropertyVC{
    
    func AddPropertyApiOwner(){
        print(checkOnboarding)
        if isCommingFrom == false{
            AccountManager.sharedInstance.isonboarding = true

        }else if isCommingFrom == true{
            AccountManager.sharedInstance.isonboarding = false
        }
        onboarding()
        SVProgressHUD.show()

        let param = [WsParam.propertyname:self.txtPropertyName.text ?? "",
                     WsParam.propertyAddress:self.txtPropertyAddress.text ?? "",
                     WsParam.Propertylatitude:String(self.strLatitude),
                     WsParam.Propertylongitude:String(self.strLongitude),
                     WsParam.onboarding:checkOnboarding] as [String : Any]
               print(strLongitude)
               print(strLatitude)
        print(param)
        
        self.view.endEditing(true)
        var imageData : Data?
        if SelectedPropertyImage !=  nil{
            imageData = (SelectedPropertyImage?.jpegData(compressionQuality: 1.0))!
        }
        objWebServiceManager.uploadMultipartData(strURL: WsUrl.AddProperty, params: param, queryParams: [:], strCustomValidation: "", showIndicator: true, imageData: imageData, fileName: WsParam.propertyImage, mimeType: "image/jpeg", success: { response in
            print(response)
            SVProgressHUD.dismiss()
            let message = response["message"] as? String ?? ""
            let status = (response["status"] as? String)
            if status == k_success {
                AccountManager.sharedInstance.isonboarding = true
                let usertype = objAppSharedata.UserDetail.strUserType
                let usertype1 = UserDefaults.standard.string(forKey: UserDefaults.KeysDefault.kUserType)
                print(usertype1 ?? "")
                print(usertype)
                if usertype == "owner"{
                    if iscame == true {
                        iscame = false 
            self.navigationController?.popToRootViewController(animated: false)
        if let tabBarController = objAppDelegate.window!.rootViewController as? TabBarVC {
                            tabBarController.selectedIndex = 2
                    }
                    }else{
                        objAppDelegate.showTabbarNavigation()
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

