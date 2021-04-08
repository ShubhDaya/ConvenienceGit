//
//  WelcomeViewController.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 08/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

var userType = ""

class WelcomeVC: UIViewController {
    
    //MARK: Variables-
    
    var strUserType = "Tenent"
    let yourAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.init(name: "OpenSans-Regular", size: 12.0) ?? "",
        .foregroundColor: UIColor.init(cgColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)),
        .underlineStyle: NSUnderlineStyle.single.rawValue]
//    let yourAttributess: [NSAttributedString.Key: Any] = [
//        .font: UIFont.systemFont(ofSize: 15.0),
//        .foregroundColor: UIColor.init(cgColor: #colorLiteral(red: 0.4352941176, green: 0.4509803922, blue: 0.462745098, alpha: 1)),
//        .underlineStyle: NSUnderlineStyle.single.rawValue]
    // MARK: IBOutlets-
    
    @IBOutlet weak var btnOwner: UIButton!
    @IBOutlet weak var btntenant: UIButton!
    @IBOutlet weak var lblterent: UILabel!
    @IBOutlet weak var lblowner: UILabel!
    @IBOutlet weak var viewOwner: UIView!
    @IBOutlet weak var imgOwner: UIImageView!
    @IBOutlet weak var viewTenant: UIView!
    @IBOutlet weak var imgTenant: UIImageView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var btnPrivacy: UIButton!
    
    //MARK: AppLifeCycle-
    override func viewDidLoad() {
        super.viewDidLoad()
        viewShowOnAppLounch()
        let attributeString = NSMutableAttributedString(string: "Terms & Condition ",
                                                        attributes: yourAttributes)
        self.btnTerms.setAttributedTitle(attributeString, for: .normal)
        let attributeStrings = NSMutableAttributedString(string: "and Privacy Policy.",
                                                        attributes: yourAttributes)
        self.btnPrivacy.setAttributedTitle(attributeStrings, for: .normal)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewShowOnAppLounch()
        
    }
    
    //MARK: Button Actions
    @IBAction func btnOwner(_ sender: Any) {
        InitialOwnerView()
        userType = "owner"
        
        if  objAppSharedata.user_type == "owner"{
            //            objAlert.showAlert(message: "please Select UserType", title:"Oops!!", controller: self)
            print("User Owner is selected")
            let storyBoard = UIStoryboard(name: "Main", bundle:nil)
            let LoginVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            LoginVC.userType = "owner"
            self.navigationController?.pushViewController(LoginVC, animated: true)
            
        }else{
            print("Error")
        }
    }
    
    @IBAction func btnTenant(_ sender: Any) {
        InitialTenantView()
        userType = "tenant"
        
        if objAppSharedata.user_type  == "tenant"{
            print("User Tenant is selected")
            let storyBoard = UIStoryboard(name: "Main", bundle:nil)
            let LoginVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            LoginVC.userType = "tenant"
            self.navigationController?.pushViewController(LoginVC, animated: true)
            
        }else {
            print("user not selected")
            objAlert.showAlert(message:"SelectUserType", title: "Oops!!", controller: self)
        }
        
        
    }
    
    @IBAction func btnTerms(_ sender: Any) {
        self.view.endEditing(true)
        let storyBoard = UIStoryboard(name: "Settings", bundle:nil)
        let AddPropertyVC = storyBoard.instantiateViewController(withIdentifier: "TermConditionVC") as! TermConditionVC
        // AddPropertyVC.strTermsCondition = "https://convenienceco.com/public/assets/contents/Convenience_TermsOfService.pdf"
        AddPropertyVC.strTermsCondition = objAppShareData.strTermsCondition
        self.navigationController?.pushViewController(AddPropertyVC, animated: true)
                
        
    }
    
    @IBAction func btnPrivacy(_ sender: Any) {
        self.view.endEditing(true)
        let storyBoard = UIStoryboard(name: "Settings", bundle:nil)
        let AddPropertyVC = storyBoard.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
       // AddPropertyVC.strPolicy = "https://convenienceco.com/public/assets/contents/Convenience_PrivacyPolicy.pdf"
        AddPropertyVC.strPolicy = objAppShareData.strTermsCondition
        self.navigationController?.pushViewController(AddPropertyVC, animated: true)
    }
    
    //MARK: Local Methods
    
    func viewShowOnAppLounch(){
        self.viewTenant.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5978763204)
        self.viewOwner.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5978763204)
        self.viewTenant.setViewRadius18()
        self.viewOwner.setViewRadius18()
        lblowner.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lblterent.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    func InitialOwnerView(){
        objAppSharedata.user_type = "owner"
        lblowner.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        viewOwner.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7561619718)
        lblterent.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        viewTenant.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5950704225)
    }
    
    func InitialTenantView(){
        objAppSharedata.user_type = "tenant"
        lblterent.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        lblowner.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        viewTenant.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7616087148)
        viewOwner.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6113831426)


    }
}
