//
//  AddCardVC.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 13/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import SVProgressHUD
import Stripe

class AddCardVC: UIViewController ,UITextFieldDelegate{
    
    //MARK: variables--
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    var cardNumberForCardAdd = "" //cardnumber text without spaces
    
    //variable for date picker-
    var MONTH = 0
    var YEAR = 1
    var selectedMonthName = ""
    var selectedyearName = ""
    var months = [Any]()
    var years = [Any]()
    var minYear: Int = 0
    var maxYear: Int = 0
    var rowHeight: Int = 0
    
    var strMonth = ""
    var strYear = ""
    var stripeToken:String = ""
    
    var strCardId = ""
    var strCardBrand = ""
    var strLastDigit = ""
    
    //MARK:IBOutlet-
    
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var imgback: UIImageView!
    @IBOutlet weak var viewDatePicker: customView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var txtNameOnCard: UITextField!
    @IBOutlet weak var txtEnterTextCardNumber: UITextField!
    @IBOutlet weak var txtExpiryDate: UITextField!
    @IBOutlet weak var txtCVV: UITextField!
    
    @IBOutlet weak var picker_monthYear: UIPickerView!
    
    //MARK:AppLifeCycle-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDefaultsParameters()
        viewDatePicker.isHidden = true
        self.txtNameOnCard.delegate = self
        self.txtEnterTextCardNumber.delegate = self
        self.txtExpiryDate.delegate = self
        self.txtCVV.delegate = self
        self.txtEnterTextCardNumber.addTarget(self, action: #selector(reformatAsCardNumber(_:)), for: .editingChanged)
    }
    func resetNewCardInput(){
        
        self.txtNameOnCard.text = ""
        self.txtEnterTextCardNumber.text = ""
        self.txtCVV.text = ""
        self.txtExpiryDate.text = ""
        self.selectedMonthName = ""
        self.selectedyearName = ""
        
        self.picker_monthYear.delegate = self
        self.picker_monthYear.dataSource = self
        loadDefaultsParameters()
        self.picker_monthYear.reloadAllComponents()
        self.picker_monthYear.selectRow(0, inComponent: 0, animated: true)
        self.picker_monthYear.selectRow(0, inComponent: 1, animated: true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIDisgn()
        self.onboarding()
    }
    //MARK:buttons-
    
    
    @IBAction func btnOpenDatePicker(_ sender: Any) {
        self.viewDatePicker.isHidden = false
        self.txtNameOnCard.resignFirstResponder()
        self.txtEnterTextCardNumber.resignFirstResponder()
        self.txtCVV.resignFirstResponder()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.view.endEditing(true)
        navigationController?.popViewController(animated: true)
        
        if isCommingFrom == true {
            if isnocard == true{
                self.view.endEditing(true)
                navigationController?.popViewController(animated: true)

            }else if isNocardForPayment == true{
                navigationController?.popViewController(animated: true)
            }else if isNocardForPaymentAlert == true {
                navigationController?.popViewController(animated: false)
                           let storyBoard = UIStoryboard(name: "PaymentTanTab", bundle:nil)
                                  let SelectOwnerVC = storyBoard.instantiateViewController(withIdentifier: "SendPaymentAlertVC") as! SendPaymentAlertVC
                                  self.navigationController?.pushViewController(SelectOwnerVC, animated: false)            }
        
            else {
           // self.view.endEditing(true)
            navigationController?.popViewController(animated: false)
            let storyBoard = UIStoryboard(name: "Settings", bundle:nil)
                   let SelectOwnerVC = storyBoard.instantiateViewController(withIdentifier: "PaymentMethodVC") as! PaymentMethodVC
                   self.navigationController?.pushViewController(SelectOwnerVC, animated: false)
            }
            
        }else{
           
        }
    }
    
    @IBAction func btnPickerDoneAction(_ sender: UIButton) {
        view.endEditing(true)
        self.viewDatePicker.isHidden = true
        
        if selectedMonthName.count > 0 && selectedyearName.count > 0
        {
            let str = "\(selectedMonthName)/\(selectedyearName)"
            txtExpiryDate.text = str
            strMonth = selectedMonthName
            strYear = selectedyearName
            print(strMonth)
            print(strYear)
            print(str)
        }
    }
    
    @IBAction func btnPickerCancelAction(_ sender: UIButton) {
        view.endEditing(true)
        self.viewDatePicker.isHidden = true
    }
    
    @IBAction func btnAddCard(_ sender: Any) {
        self.view.endEditing(true)
        //  objAlert.showAlert(message: kunderDevelopment, title: kAlertTitle, controller: self)
        AddCardValidation()
        print("All fields are corrects ")
    }
    
    func onboarding(){
        
        if AccountManager.sharedInstance.isonboarding == true{
            //checkOnboarding = "true"
            UserDefaults.standard.set(AccountManager.sharedInstance.isonboarding, forKey:"onboard")
            UserDefaults.standard.set(checkOnboarding, forKey: "onboarding" )
            print(AccountManager.sharedInstance.isonboarding)
            //print(checkOnboarding)
            
        }else if AccountManager.sharedInstance.isonboarding == false     {
            //checkOnboarding = "false"
            UserDefaults.standard.set(AccountManager.sharedInstance.isonboarding, forKey:"onboard")
            UserDefaults.standard.set(checkOnboarding, forKey: "onboarding" )
            //print(checkOnboarding)
            print(AccountManager.sharedInstance.isonboarding)
        }
    }
    
    //MARK: TextField Delegate -
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtNameOnCard{
            self.viewDatePicker.isHidden = true
            self.txtNameOnCard.resignFirstResponder()
            self.txtEnterTextCardNumber.becomeFirstResponder()
        }else if textField == self.txtEnterTextCardNumber{
            self.viewDatePicker.isHidden = true
            self.txtNameOnCard.resignFirstResponder()
        }else if textField == self.txtExpiryDate{
            self.txtExpiryDate.resignFirstResponder()
            self.txtCVV.resignFirstResponder()
            self.viewDatePicker.isHidden = false
        }else if textField == self.txtCVV{
            self.viewDatePicker.isHidden = true
            self.txtCVV.becomeFirstResponder()
        }else{
            self.txtCVV.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "" {
            return true
        }
        if textField == txtCVV{
            let maxLength = 3
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            if newString.length == 4{
                textField.resignFirstResponder()
            }
            return newString.length <= maxLength
        }else if textField == txtEnterTextCardNumber{
            previousTextFieldContent = textField.text;
            previousSelection = textField.selectedTextRange;
            
            return true
        }else{
            return true
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        // hidePickerWithOutAnimation()
        self.viewDatePicker.isHidden = true
        
        return true
    }
    
    //MARK:Local Function-
    func UIDisgn(){
        viewContent.setViewRadius()
        viewDatePicker.setViewRadius()
        viewContent.setshadowView()
    }
    
    func showPicker() {
        view.endEditing(true)
        picker_monthYear.reloadAllComponents()
    }
    
}

// MARK: Extension --
extension AddCardVC {
    
    // MARK: Func  SigninValidation
    func AddCardValidation() {
        _ = txtEnterTextCardNumber.text
        _ = txtExpiryDate.text
        let userCVV = self.txtCVV.text?.count ?? 0
        
        _  =  objValidationManager.isValidCardNUmber(testStr: txtEnterTextCardNumber.text ?? "")
        
        self.txtNameOnCard.text = self.txtNameOnCard.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtEnterTextCardNumber.text = self.txtEnterTextCardNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtExpiryDate.text = self.txtExpiryDate.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtCVV.text = self.txtCVV.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if self.txtNameOnCard.text?.isEmpty == true{
            objAlert.showAlert(message: InvalideInformation, title: kinvalid, controller: self)
        }else if self.txtNameOnCard.text?.count ?? 0 < 3{
            objAlert.showAlert(message: NameonCard, title: kinvalid, controller: self)
        }else if txtEnterTextCardNumber.text?.isEmpty  == true  {
            objAlert.showAlert(message: InvalideInformation, title: kinvalid, controller: self)
        }else if txtExpiryDate.text?.isEmpty == true  {
            objAlert.showAlert(message: InvalideInformation, title: kinvalid, controller: self)
        }else if txtCVV.text?.isEmpty == true{
            objAlert.showAlert(message: InvalideInformation, title: kinvalid, controller: self)
        }else if userCVV > 3 {
            objAlert.showAlert(message: InvalideInformation, title: kinvalid, controller: self)
        }else{
            let strip1 = objAppShareData.UserDetail.strstripe_customer_id
            print(strip1)
            var strip = ""
            strip = UserDefaults.standard.value(forKey: UserDefaults.KeysDefault.KStripe_customer_id) as? String ?? ""
            print(" userdefault \(strip)")
            print(" appsharedata stripe id  \(strip1)")
            
            if  strip == ""{
                self.Call_For_WebService_CreateCustomer()
            }else{
                self.getStripeToken()
            }
        }
    }
}

extension AddCardVC : UIPickerViewDelegate,UIPickerViewDataSource {
    
    // MARK:- Picker View Delegates
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        view.endEditing(true)
        
        if component == MONTH {
            return months.count
        }
        else {
            return years.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == MONTH {
            let monthName: String = months[row] as! String
            return monthName
        }
        else {
            let yearName: String = years[row] as! String
            let str = "\(yearName)"
            return str
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        view.endEditing(true)
        if component == self.MONTH {
            selectedMonthName = months[row] as! String
        }else {
            let str = "\(years[row])"
            if (str.count ) > 2 {
                let strLastTwoDigits: String! = (str as? NSString)?.substring(from: (str.count ) - 2)
                selectedyearName = strLastTwoDigits!
            }
        }
    }
    
    
    func loadDefaultsParameters() {
        let components: DateComponents? = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        let year: Int? = components?.year
        minYear = year!
        maxYear = year! + 30
        rowHeight = 44
        months = nameOfMonths()
        years = nameOfYears()
        picker_monthYear.delegate = self
        picker_monthYear.dataSource = self
        let str = "\(Int(year!))"
        if (str.count ) > 2 {
            let strLastTwoDigits: String = ((str as? NSString)?.substring(from: (str.count ) - 2))!
            selectedyearName = strLastTwoDigits
        }
        selectedMonthName = "01"
    }
    
    func nameOfMonths() -> [Any] {
        return ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    }
    
    func nameOfYears() -> [Any] {
        var years = [AnyHashable]()
        for year in minYear...maxYear {
            let yearStr = "\(Int(year))"
            years.append(yearStr)
        }
        return years
    }
    
    
    func getStripeToken(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            SVProgressHUD.show()
            objAlert.showAlert(message: "", title: "NoConnection", controller: self)
            return
        }
        SVProgressHUD.show()
        
        let stripCard = STPCardParams()
        
        let expM = self.strMonth
        let expY = self.strYear
        
        let expMonth = UInt(expM)
        let expYear = UInt(expY)
        
        // Send the card info to Strip to get the token
        stripCard.number = self.cardNumberForCardAdd
        stripCard.cvc = self.txtCVV.text!
        stripCard.expMonth = expMonth ?? 0
        stripCard.expYear = expYear ?? 0
        stripCard.name = self.txtNameOnCard.text!
        
        STPAPIClient.shared().createToken(withCard: stripCard) { (token: STPToken?, error: Error?) in
            guard let token = token, error == nil else {
                // Present error to user...
                
                objAlert.showAlert(message: "Your card details are not valid", title: kAlertTitle, controller: self)
                SVProgressHUD.dismiss()
                return
            }
            // self.dictPayData["stripe_token"] = token.tokenId
            self.stripeToken = token.tokenId
            print(self.stripeToken)
            self.callWebServiceFor_CreateCard()
        }
    }
}

//MARK:- custom methods for stripe payment

extension AddCardVC{
    
    func Call_For_WebService_CreateCustomer(){
        SVProgressHUD.show()
        var strStatusCode : Int = 0
        objWebServiceManager.uploadMultipartData(strURL: WsUrl.create_Customer, params: [:], queryParams: [:], strCustomValidation: "", showIndicator: false, imageData: nil, fileName: "", mimeType: "", success: { (response) in
            print(response)
            let status = response["success"] as? String
            if status == "success"{
                SVProgressHUD.dismiss()
                
            }
            strStatusCode = response["status_code"] as? Int ?? 0
            let strMessage = response["message"] as? String ?? ""
            if let data = response["data"] as? [String:Any]{
                let Str_stripe_customer_id = data["stripe_customer_id"] as? String ?? ""
                
                UserDefaults.standard.set(Str_stripe_customer_id, forKey: UserDefaults.KeysDefault.KStripe_customer_id)
            }
            if strStatusCode == 200{
                self.getStripeToken()
            }else{
                SVProgressHUD.dismiss()
                objAlert.showAlert(message:strMessage, title: kAlertTitle, controller: self)
            }
        }) { (Error) in
            print(Error)
            SVProgressHUD.dismiss()
        }
    }
    
    func callWebServiceFor_CreateCard(){
        SVProgressHUD.show()
        self.view.endEditing(true)
        let param = ["source":self.stripeToken] as [String : AnyObject]
        let strStripe_Id = UserDefaults.standard.string(forKey: UserDefaults.KeysDefault.KStripe_customer_id)
        print(strStripe_Id ?? "")
        print(param)
        
        let url = "https://api.stripe.com/v1/customers" + "/" + strStripe_Id! + "/sources"
        print(url)
        
        objWebServiceManager.requestAddCardOnStripe(strURL: url, params: param, success: { (response) in
            print(response)
            SVProgressHUD.dismiss()
            
            self.strCardBrand = response["brand"] as? String ?? ""
            self.strCardId = response["id"] as? String ?? ""
            self.strLastDigit = response["last4"] as? String ?? ""
            
            if (response["error"] as? [String:Any]) != nil {
                SVProgressHUD.dismiss()
                objAlert.showAlert(message: "Card details is invalid", title: kAlertTitle, controller: self)
                return
            }else{
                self.Call_For_WebService_AddCard()
            }
        }) { (error) in
            print(error)
            SVProgressHUD.dismiss()
            objAlert.showAlert(message: "FAIL", title: "Alert", controller: self)
        }
    }
    
    
}
//MARK: - Api Create Card
extension AddCardVC{
    /*
     func ShowAlertForCardAdded(){
     let alertController = UIAlertController(title: kTitle, message: "Card added successfully.", preferredStyle: .alert)
     let yesButton = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
     self.callWSForGetCardList(isFromMakeDefault: false)
     })
     alertController.addAction(yesButton)
     present(alertController, animated: true) {() -> Void in }
     }
     
     */
    
    func Call_For_WebService_AddCard(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            SVProgressHUD.dismiss()
            
            objAlert.showAlert(message: "", title: "NoConnection", controller: self)
            return
        }
        
        if isCommingFrom == false{
            AccountManager.sharedInstance.isonboarding = true
            
        }else if isCommingFrom == true{
            AccountManager.sharedInstance.isonboarding = false
        }
        
        var param = [String:Any]()
        let expM = self.selectedMonthName
        let expY = "20\(self.selectedyearName)"
        print(checkOnboarding)
        
        
        param = ["stripeCardId" :self.strCardId ,
                 "cardHolderName" : self.txtNameOnCard.text!,
                 "cardLast4Digits" :String(self.strLastDigit),
                 "expiryMonth" : expM,
                 "expiryYear": expY,
                 "cardBrandType":self.strCardBrand,
                 "onboarding" : checkOnboarding
        ]
        
        print("ggg",param)
        
        objWebServiceManager.requestPost(strURL: WsUrl.addCard, queryParams: [:], params: param, strCustomValidation: "", showIndicator: false, success: { (response) in
            print(response)
            
            SVProgressHUD.dismiss()
            
            let message = response["message"] as? String ?? ""
            if let status = response["success"] as?  [String:Any]{
            }
            let statusCode = response["status_code"] as? Int ?? 0
            if statusCode == 200{
                SVProgressHUD.dismiss()
                isnocard = false

                
                if isCommingFrom == true {
                    if isNocardForPayment == true {
                        self.navigationController?.popViewController(animated: true)

                    }else if  isNocardForPaymentAlert == true{
                        self.navigationController?.popViewController(animated: true)

                    }else{
                        AccountManager.sharedInstance.isonboarding = true
                       self.navigationController?.popViewController(animated: true)
                    }
                   
                }else {
                    objAppDelegate.showTenantTabbarNavigation()
                }
                
            }else{
                SVProgressHUD.dismiss()

                objAlert.showAlert(message: message, title: kAlertTitle, controller: self)
            }
        }) { (Error) in
            print(Error)
            SVProgressHUD.dismiss()
            
            objAlert.showAlert(message: "No_Connection", title: kAlertTitle, controller: self)
        }
    }
    
    
}
extension AddCardVC{
    @objc func reformatAsCardNumber(_ textField: UITextField) {
        var targetCursorPosition = 0
        if let startPosition = textField.selectedTextRange?.start {
            targetCursorPosition = textField.offset(from:textField.beginningOfDocument, to: startPosition)
        }
        
        var cardNumberWithoutSpaces = ""
        if let text = textField.text {
            cardNumberWithoutSpaces = removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
        }
        
        if cardNumberWithoutSpaces.count > 16 {
            textField.text = previousTextFieldContent
            textField.selectedTextRange = previousSelection
            return
        }
        
        self.cardNumberForCardAdd = cardNumberWithoutSpaces
        
        let cardNumberWithSpaces = self.insertSpacesEveryFourDigitsIntoString(string: cardNumberWithoutSpaces, andPreserveCursorPosition: &targetCursorPosition)
        
        textField.text = cardNumberWithSpaces
        
        if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
            textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
        }
    }
    
    func removeNonDigits(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var digitsOnlyString = ""
        let originalCursorPosition = cursorPosition
        
        for i in stride(from: 0, to: string.count, by: 1) {
            let characterToAdd =  string[string.index(string.startIndex, offsetBy: i)]
            if characterToAdd >= "0" && characterToAdd <= "9" {
                digitsOnlyString.append(characterToAdd)
            }
            else if i < originalCursorPosition {
                cursorPosition -= 1
            }
        }
        return digitsOnlyString
    }
    
    func insertSpacesEveryFourDigitsIntoString(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var stringWithAddedSpaces = ""
        let cursorPositionInSpacelessString = cursorPosition
        
        for i in stride(from: 0, to: string.count, by: 1) {
            if i > 0 && i==4 || i==8{
                stringWithAddedSpaces.append("  ")
                if i < cursorPositionInSpacelessString {
                    cursorPosition += 2
                }
            }else if i == 12{
                stringWithAddedSpaces.append(" ")
                if i < cursorPositionInSpacelessString {
                    cursorPosition += 1
                }
            }
            
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            stringWithAddedSpaces.append(characterToAdd)
        }
        return stringWithAddedSpaces
    }
}
