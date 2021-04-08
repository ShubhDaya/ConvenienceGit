//
//  BankAccountDetailVC.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 04/02/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class BankAccountDetailVC: UIViewController {
    
    //MARK: Varaibles-
    
    //MARK: IBOutlet-
    @IBOutlet weak var txtBankName: UITextField!
    @IBOutlet weak var txtAccountNumber: UITextField!
    @IBOutlet weak var txtRoutingNumber: UITextField!
    @IBOutlet weak var view1: UIView!
    
    //MARK: AppLifeCycle-
    override func viewDidLoad() {
        super.viewDidLoad()
        UIViewDesign()
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: Button-
    
    @IBAction func btnRemoveAccount(_ sender: Any) {
        self.view.endEditing(true)
        objAlert.showAlert(message: kunderDevelopment, title: kAlertTitle, controller: self)
        
    }
    
    @IBAction func btnBackToSetting(_ sender:Any) {
        self.view.endEditing(true)
        
        navigationController?.popViewController(animated: true)
        
        
    }
    
    //MARK: Local Methods-
    
    func UIViewDesign(){
        
        self.view1.setViewRadius()
        self.view1.setshadowView()
    }
    
}
//MARK: Validation-

extension BankAccountDetailVC {
    func AddBankAccountValidation (){
        
        self.txtBankName.text = self.txtBankName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtAccountNumber.text = self.txtAccountNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtRoutingNumber.text = self.txtRoutingNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let strBankName = self.txtBankName.text?.count ?? 0
        
        let isAccountNumberValid = objValidationManager.isValidBankAccountNUmber(testStr: txtAccountNumber.text ?? "")
        let isRautingNumberValid = objValidationManager.isValidBankRautingNumber(testStr: txtRoutingNumber.text ?? "")
        
        if txtBankName.text?.isEmpty == true  {
            objAlert.showAlert(message: BlankBankName, title: kAlertTitle, controller: self
            )
        }
        else if strBankName < 3  {
            objAlert.showAlert(message: BankNameLenght, title:kAlertTitle, controller: self
            )
        }
        else if txtAccountNumber.text?.isEmpty == true  {
            objAlert.showAlert(message: BlankAccountNumber, title: kAlertTitle, controller: self
            )
        }
        else if !isAccountNumberValid {
            objAlert.showAlert(message: InvaldAccountNUumber, title: kAlertTitle, controller: self
            )
        }
        else if txtRoutingNumber.text?.isEmpty == true  {
            objAlert.showAlert(message: BlankRoutingNumber, title: kAlertTitle, controller: self
            )
        }else if !isRautingNumberValid {
            objAlert.showAlert(message: InvalidRoutingNumber, title: kAlertTitle, controller: self
            )
        }
        else {
            
            print("All fields are correct !!!")
            
        }
    }
}

extension BankAccountDetailVC : UITextFieldDelegate {
    
    //MARK:KeyboardFunctions-
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.txtBankName{
            self.txtBankName.resignFirstResponder()
            self.txtAccountNumber.becomeFirstResponder()
            
            
        }else if textField == self.txtAccountNumber{
            self.txtAccountNumber.resignFirstResponder()
            self.txtRoutingNumber.becomeFirstResponder()
        }
        else{
            self.txtRoutingNumber.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "" {
            return true
        }
        if textField == self.txtAccountNumber{
            if self.txtAccountNumber.text?.count ?? 0 >= 18 {
                // RESIGN FIRST RERSPONDER TO HIDE KEYBOARD
                self.txtAccountNumber.resignFirstResponder()
                self.txtRoutingNumber.becomeFirstResponder()
                return false
            }
        }
        else if textField == self.txtRoutingNumber{
            if self.txtRoutingNumber.text?.count ?? 0 >= 9 {
                self.txtRoutingNumber.resignFirstResponder()
                return false
            }
        }
        return true
    }
    
}


