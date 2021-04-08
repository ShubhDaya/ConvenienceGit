//
//  SignUpViewController.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 09/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD


var selectedProfileImage : UIImage!
class SignUpVC: UIViewController,UITextFieldDelegate {
    
    //MARK:Variables -
    var imagePicker = UIImagePickerController()
    var convertedImage : UIImage!
    
    //Save image
    
    //MARK: IBOutlets-
    @IBOutlet weak var viewProfileImg: UIView!
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfrimPassword: UITextField!
    @IBOutlet weak var viewLogo: UIView!
    
    @IBOutlet weak var viewCamera: UIView!
    
    //MARK: AppLifeCycle-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UiDesign()
        imagePicker.delegate = self
        self.txtFirstName.delegate = self
        self.txtLastName.delegate = self
        self.txtEmail.delegate = self
        self.txtPassword.delegate = self
        self.txtConfrimPassword.delegate = self
  
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.UiDesign()
        
    }
    
    //MARK: Buttons-
    @IBAction func btnback(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnUploadImage(_ sender: Any) {
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { _ in
            
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
    
    @IBAction func btnSignUp(_ sender: Any) {
        self.view.endEditing(true)
        
        self.SignUpValidation()
        
    }
    
    @IBAction func btnSIgnIn(_ sender: Any) {
        self.view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.txtFirstName{
            self.txtFirstName.resignFirstResponder()
            self.txtLastName.becomeFirstResponder()
        }else if textField == self.txtLastName{
            self.txtLastName.resignFirstResponder()
            self.txtEmail.becomeFirstResponder()
        }
            
        else if textField == self.txtEmail{
            self.txtEmail.resignFirstResponder()
            self.txtPassword.becomeFirstResponder()
        }
        else if textField == self.txtPassword{
            self.txtPassword.resignFirstResponder()
            self.txtConfrimPassword.becomeFirstResponder()
        }
        else{
            self.txtConfrimPassword.resignFirstResponder()
        }
        return true
    }
    
    
    //MARK: Local Methods-
    
    func UiDesign(){
        // content view radius and shadow --
        self.ContentView.setViewRadius() //set radius to view top left and top right
        self.ContentView.setshadowView()// set shadow to view top left and top right
        self.viewCamera.setviewCircle() // set view circle with border color
        self.imgUser.setImgCircle()
        self.viewProfileImg.setviewCircle()
    }
}
extension  SignUpVC{
    func callWebserviceForSignUp(){
        SVProgressHUD.show()
        self.view.endEditing(true)
        let param = [WsParam.first_name:self.txtFirstName.text ?? "",
                     WsParam.last_name:self.txtLastName.text ?? "",
                     WsParam.email:self.txtEmail.text ?? "",
                     WsParam.password:self.txtPassword.text ?? "",
                     WsParam.Confirm_password:self.txtConfrimPassword.text ?? "",
                     WsParam.user_type:userType,
                     WsParam.device_token:objAppShareData.strFirebaseToken,
            ] as [String : Any]
        print(param)
        
        self.view.endEditing(true)
        var imageData : Data?
        if selectedProfileImage !=  nil{
            imageData = (selectedProfileImage.jpegData(compressionQuality: 1.0))!
        }
        
        objWebServiceManager.uploadMultipartData(strURL:WsUrl.signup, params:param, queryParams:[:],strCustomValidation:"", showIndicator: true, imageData: imageData, fileName: WsParam.profilePic, mimeType: "image/jpeg", success: { response in
            print(response)
            let status = (response["status"] as? String)
            let message = (response["message"] as? String)

            
            let strImage = ""
            if status == k_success {
                SVProgressHUD.dismiss()
                if (response["data"]as? [String:Any]) != nil{
                    if status == "success" || status == "Success"
                    {
                        let dic = response["data"] as? [String:Any]
                        let user_details  = dic!["user_details"] as? [String:Any]
                        let alertStatus = user_details?["push_alert_status"] as? Int ?? 2
                        print(alertStatus)
                        PushAlertStatus = alertStatus
                        UserDefaults.standard.set(PushAlertStatus, forKey:"PushAlertStatus")

                        objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details ?? [:])
                        objAppShareData.fetchUserInfoFromAppshareData()
                        
                        UserDefaults.standard.setValue(objAppSharedata.UserDetail.strAuthToken, forKey: UserDefaults.KeysDefault.kAuthToken)
                        
                        UserDefaults.standard.set(objAppSharedata.UserDetail.strUserType, forKey: UserDefaults.KeysDefault.kUserType)
                        UserDefaults.standard.setValue(objAppSharedata.UserDetail.strOnboardingCompled, forKey: UserDefaults.KeysDefault.konbordingCompled)
                        UserDefaults.standard.setValue(objAppSharedata.UserDetail.strkonboardingstep, forKey: UserDefaults.KeysDefault.konboardingstep)
                        UserDefaults.standard.setValue(objAppSharedata.UserDetail.strUserType, forKey: UserDefaults.KeysDefault.kUserType)
                        //UserDefaults.standard.set(objAppSharedata.UserDetail.strAuthToken, forKey: UserDefaults.KeysDefault.kAuthToken)
                        
                        let usertype = objAppShareData.UserDetail.strUserType
                        
                        
                        if usertype == "owner"{
                            
                            
                            print("user is owner")
                            let storyBoard = UIStoryboard(name: "Main", bundle:nil)
                            let AddBankAccountVC = storyBoard.instantiateViewController(withIdentifier: "EmailVerifyVC") as! EmailVerifyVC
                            self.navigationController?.pushViewController(AddBankAccountVC, animated: true)
                            
                        }else if usertype == "tenant"{
                            print("user is tenant")
                            let storyBoard = UIStoryboard(name: "Main", bundle:nil)
                            let AddPropertieVC = storyBoard.instantiateViewController(withIdentifier: "EmailVerifyVC") as! EmailVerifyVC
                            self.navigationController?.pushViewController(AddPropertieVC, animated: true)
                        }
                    }
                    
                    let urlImg = URL(string: strImage)
                    self.imgUser.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "profile_ico"))
                }
            }else{
                SVProgressHUD.dismiss()
                objAlert.showAlert(message:message ?? "", title: "Alert", controller: self)
                
            }
        }, failure: { (error) in
            print(error)
            SVProgressHUD.dismiss()
            objAlert.showAlert(message:kErrorMessage, title: "Alert", controller: self)
        })
    }
    
    func saveDataUserDefaults(){
        
        //  userDefaults.set(objAppShareData.UserDetail.straAuthToken, forKey:strAuthToken)
    }
    
}
//MARK: Extension Validation
extension SignUpVC {
    func SignUpValidation (){
        
        let strFirstName = self.txtFirstName.text?.count ?? 0
        _ = self.txtLastName.text?.count ?? 0
        let strPassWord = self.txtPassword.text?.count ?? 0
        let strConfirmPassWord = self.txtConfrimPassword.text?.count ?? 0
        let isEmailAddressValid = objValidationManager.validateEmail(with: txtEmail.text ?? "")
        let isValidPassword = objValidationManager.ValidPassWord8digit(with: txtPassword.text ?? "")
        let isValidConfirmPassword = objValidationManager.ValidPassWord8digit(with: txtConfrimPassword.text ?? "")

        
        
        self.txtFirstName.text = self.txtFirstName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtLastName.text = self.txtLastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        self.txtEmail.text = self.txtEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtPassword.text = self.txtPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        self.txtConfrimPassword.text = self.txtConfrimPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if txtFirstName.text?.isEmpty == true  {
            objAlert.showAlert(message: BlankName, title: kAlertTitle, controller: self
            )
        }
        else if strFirstName < 3 {
            objAlert.showAlert(message: nameLength, title: kAlertTitle, controller: self
            )
        }
        else if txtEmail.text?.isEmpty  == true  {
            objAlert.showAlert(message:BlankEmail, title: kAlertTitle, controller: self)
        }else if !isEmailAddressValid  {
            objAlert.showAlert(message: InvalidEmail, title: kAlertTitle, controller: self)
       
        } else if txtPassword.text?.isEmpty == true  {
            objAlert.showAlert(message: BlankPassword, title: kAlertTitle, controller: self
            )
        }else if !isValidPassword  {
            objAlert.showAlert(message: InvalidPassword, title: kAlertTitle, controller: self)
        }
        else if strPassWord < 8{
            objAlert.showAlert(message: LengthPassword, title: kAlertTitle, controller: self
            )
        }
        else if txtConfrimPassword.text?.isEmpty == true{
            objAlert.showAlert(message: BlankconfirmPassword, title: kAlertTitle, controller: self
            )
        }
        else if strConfirmPassWord < 8{
            objAlert.showAlert(message:InvalidConfirmPassword, title: kAlertTitle, controller: self
            )
        }
        
       else if(txtPassword.text != self.txtConfrimPassword.text){
            objAlert.showAlert(message: ConfirmPasswordnotMatch, title: kAlertTitle, controller: self)
        }
            
        else {
    
            
            callWebserviceForSignUp()
            
        }
    }
}

//MARK: Imagepicker - Functions -
extension SignUpVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func openCamera()
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
        
        imgUser.image = nil
        imgUser.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        selectedProfileImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        selectedProfileImage = imgUser.image
        
        //convert the image to NSData first
        let _:NSData = selectedProfileImage.pngData()! as NSData
        // convert the NSData to base64 encoding
        imgUser.layer.cornerRadius = imgUser.frame.size.height / 2
        imgUser.layer.masksToBounds = true
        //        imgUser.setshadowimage()
        //  imgUser.layer.borderWidth = 2.0
        //  imgUser.layer.borderColor = UIColor.lightGray.cgColor
        self.dismiss(animated: true, completion: nil)
        
        
    }
    func convertImageToBase64(_ image: UIImage) -> String {
        let imageData:NSData = image.jpegData(compressionQuality: 0.4)! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        return strBase64
    }
}
