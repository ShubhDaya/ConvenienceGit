//
//  EditProfileVC.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 04/02/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import SVProgressHUD
import IQKeyboardManagerSwift


class EditProfileVC: UIViewController,UITextFieldDelegate {
    //MARK: Variables-
    var imagePicker = UIImagePickerController()
    //MARK: IBOutlet-
    
    @IBOutlet weak var lbltenantFirstName: UILabel!
    @IBOutlet weak var FirstNameView: customView!
    @IBOutlet weak var viewProfileImg: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var viewCamera: UIView!
    
    //MARK: AppLifeCycle-
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UIViewDesign()
        self.FirstNameView.isHidden = true
        imagePicker.delegate = self
        self.txtFirstName.delegate = self
        self.txtLastName.delegate = self
        if objAppShareData.UserDetail.strUserType == "tenant"{
            self.FirstNameView.isHidden = false
            self.lbltenantFirstName.text = objAppShareData.UserDetail.strFirstName
        }
        let strimage = objAppShareData.UserDetail.strProfilePicture
        let urlImg = URL(string: strimage)
        self.imgProfile.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "user_img"))
        self.txtFirstName.text = objAppShareData.UserDetail.strFirstName
        self.txtLastName.text = objAppShareData.UserDetail.strLastName
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: Buttons--
    @IBAction func btnUpdateProfile(_ sender: Any) {
        self.view.endEditing(true)
        
        editProfileValidation()
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.view.endEditing(true)
        
        navigationController?.popViewController(animated: true)
    }
    @IBAction func btnUploadImage(_ sender: Any) {
        self.view.endEditing(true)
        
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
    //MARK: Local Methods--
    
    func UIViewDesign(){
        self.view1.setViewRadius()
        self.view1.setshadowView()
        self.imgProfile.setImgCircle()
        self.viewProfileImg.setviewCirclewhite()
        self.viewProfileImg.setshadowViewCircle()
        self.viewCamera.setviewCircle()
    }
    //MARK:TextFiedFunction-
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.txtFirstName{
            self.txtFirstName.resignFirstResponder()
            self.txtLastName.becomeFirstResponder()
        }else{
            self.txtLastName.resignFirstResponder()
        }
        return true
    }
}

extension EditProfileVC{
    
    func editProfileValidation(){
        let usertype = objAppShareData.UserDetail.strUserType
        print(usertype)
        if usertype == "owner"{
            let strFirstName = self.txtFirstName.text?.count ?? 0
            let strLastname = self.txtLastName.text?.count ?? 0
            
            self.txtFirstName.text = self.txtFirstName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            self.txtLastName.text = self.txtLastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if txtFirstName.text?.isEmpty == true{
                objAlert.showAlert(message: BlankFirstName, title: kAlertTitle, controller: self)
                
            }else if strFirstName < 3  {
                objAlert.showAlert(message: UserFirstNamelenght, title: kAlertTitle, controller: self)
            }else if txtLastName.text?.isEmpty == true {
                
                objAlert.showAlert(message: BlankLastName, title: kAlertTitle, controller: self)
            }else if strLastname < 3  {
                objAlert.showAlert(message: Userlastnamelenght, title: kAlertTitle, controller: self)
            }
            
            else {
                self.callWebserviceForEditProfile()
            }
            
        }else {
            
            // let strFirstName = self.txtFirstName.text?.count ?? 0
            let strLastName = self.txtLastName.text?.count ?? 0
            
            self.txtLastName.text = self.txtLastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //                 self.txtLastName.text = self.txtLastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if txtLastName.text?.isEmpty == true{
                objAlert.showAlert(message: BlankLastName, title: kAlertTitle, controller: self)
                
            }else if strLastName < 3  {
                objAlert.showAlert(message: Userlastnamelenght, title: kAlertTitle, controller: self)
            }else {
                self.callWebserviceForEditProfile()
            }
        }
    }
}


//MARK: Imagepicker - Functions -
extension EditProfileVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
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
        
        imgProfile.image = nil
        imgProfile.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        selectedProfileImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        imgProfile.layer.cornerRadius = imgProfile.frame.size.height / 2
        imgProfile.layer.masksToBounds = true
        selectedProfileImage = imgProfile.image
        self.dismiss(animated: true, completion: nil)
    }
}
extension  EditProfileVC{
    func callWebserviceForEditProfile(){
        SVProgressHUD.show()
        self.view.endEditing(true)
        var param = [String:Any]()
        if objAppShareData.UserDetail.strUserType == "owner"{
            param = [WsParam.first_name:txtFirstName.text ?? "" ,WsParam.last_name:self.txtLastName.text ?? ""] as [String : Any]
        }else {
            param = [WsParam.first_name:objAppShareData.UserDetail.strFirstName,WsParam.last_name:self.txtLastName.text ?? ""] as [String : Any]
        }
        
        
        self.view.endEditing(true)
        var imageData : Data?
        if selectedProfileImage !=  nil{
            imageData = (selectedProfileImage.jpegData(compressionQuality: 1.0))!
        }
        
        objWebServiceManager.uploadMultipartData(strURL:WsUrl.updateProfile, params:param as! [String : Any], queryParams:[:],strCustomValidation:"", showIndicator: true, imageData: imageData, fileName: WsParam.profilePic, mimeType: "image/jpeg", success: { response in
            print(response)
            let status = (response["status"] as? String)
            let message = response["message"] as? String ?? ""
            print("___________________\(message)")
            
            let strImage = ""
            if status == k_success {
                SVProgressHUD.dismiss()
                if (response["data"]as? [String:Any]) != nil{
                    if status == "success" || status == "Success"
                    {
                        let dic = response["data"] as? [String:Any]
                        let user_details  = dic!["user_details"] as? [String:Any]
                        objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details ?? [:])
                        objAppShareData.fetchUserInfoFromAppshareData()
                        
                        UserDefaults.standard.setValue(objAppSharedata.UserDetail.strAuthToken, forKey: UserDefaults.KeysDefault.kAuthToken)
                        
                        UserDefaults.standard.setValue(objAppSharedata.UserDetail.strOnboardingCompled, forKey: UserDefaults.KeysDefault.konbordingCompled)
                        UserDefaults.standard.setValue(objAppSharedata.UserDetail.strkonboardingstep, forKey: UserDefaults.KeysDefault.konboardingstep)
                        UserDefaults.standard.setValue(objAppSharedata.UserDetail.strUserType, forKey: UserDefaults.KeysDefault.kUserType)
                        //UserDefaults.standard.set(objAppSharedata.UserDetail.strAuthToken, forKey: UserDefaults.KeysDefault.kAuthToken)
                        
                        let usertype = objAppShareData.UserDetail.strUserType
                        //                        objAlert.showAlert(message: message , title: kAlertTitle, controller: self)
                        let refreshAlert = UIAlertController(title: kAlertTitle, message: message, preferredStyle: UIAlertController.Style.alert)
                        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(refreshAlert, animated: true, completion: nil)  
                    }
                }
            }else{
                SVProgressHUD.dismiss()
                if message == "k_sessionExpire"{
                    objAlert.showAlert(message: k_sessionExpire, title: kAlertTitle, controller: self)
                    objAppShareData.resetDefaultsAlluserInfo()
                    objAppDelegate.showLogInNavigation()
                } else{
                    objAlert.showAlert(message:message, title: kAlertTitle, controller: self)
                }
            }
            
        }, failure: { (error) in
            print(error)
            SVProgressHUD.dismiss()
            objAlert.showAlert(message:kErrorMessage, title: "Alert", controller: self)
        })
    }
    
}
