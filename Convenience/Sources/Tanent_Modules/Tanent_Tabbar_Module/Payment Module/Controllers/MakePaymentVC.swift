//
//  MakePaymentVC.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 10/02/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import Foundation

var finalvalue = ""
var FinalPayment = ""
var payment = ""
var paymentDone = ""

var strClearCount = ""

var strMyValue = ""
class MakePaymentVC: UIViewController,UITextFieldDelegate {
    
    
    var numberOnScreen : Int = 0
    
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    @IBOutlet weak var btn9: UIButton!
    @IBOutlet weak var btn10: UIButton!
    @IBOutlet weak var btn11: UIButton!
    
    @IBOutlet weak var lblNOAmount: UILabel!
    @IBOutlet weak var viewProfileImg: UIView!
    @IBOutlet weak var lblTenantName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var viewAlert: UIView!
    @IBOutlet weak var viewAlertContsiner: UIView!
    @IBOutlet weak var viewAlertHeader: UIView!
    @IBOutlet weak var btnOk: customButton!
    @IBOutlet weak var imgSelectedCheckBox: UIImageView!
    @IBOutlet weak var lblPropertyName: UILabel!
    @IBOutlet weak var lblDisplay: UILabel!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lblNoAmount: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        isNocardForPayment = false
        self.UiDesign()
        self.lblNoAmount.isHidden = false
        
        PropertyID = ""
        month = ""
        Year = ""
        FinalPayment = ""
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.lblTenantName.text = "\(objAppShareData.UserDetail.strFirstName) \(objAppShareData.UserDetail.strLastName)"
        isNocardForPayment = false
        
        let strimage = objAppShareData.UserDetail.strProfilePicture
        let urlImg = URL(string: strimage)
        self.imgProfile.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "profile_ico"))
        self.lblDisplay.text = ""
        PropertyID = ""
        month = ""
        Year = ""
        FinalPayment = ""
        if  self.lblDisplay?.text == "" {
            self.lblNoAmount.isHidden = false
            
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        lblDisplay.minimumScaleFactor = 10/UIFont.labelFontSize
        lblDisplay.adjustsFontSizeToFitWidth = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func btnNumberTapped(sender: AnyObject) {
        print(sender)
        
        self.lblNoAmount.isHidden = true
        let text = lblDisplay.text ?? ""
        let value = text.replacingOccurrences(of: ",", with: "")
        let value2 = value.replacingOccurrences(of: "$", with: "")
        let MYValueCount = Double(value2) ?? 0.0
        // print("label value \(text)")
        if  MYValueCount > 100000{
            self.btn1.isEnabled = false
            self.btn2.isEnabled = false
            self.btn3.isEnabled = false
            self.btn4.isEnabled = false
            self.btn5.isEnabled = false
            self.btn6.isEnabled = false
            self.btn7.isEnabled = false
            self.btn8.isEnabled = false
            self.btn9.isEnabled = false
            self.btn10.isEnabled = false
            self.btn11.isEnabled = false
            print("my value greater than 100000")
            
        }else{
            self.btn1.isEnabled = true
            self.btn2.isEnabled = true
            self.btn3.isEnabled = true
            self.btn4.isEnabled = true
            self.btn5.isEnabled = true
            self.btn6.isEnabled = true
            self.btn7.isEnabled = true
            self.btn8.isEnabled = true
            self.btn9.isEnabled = true
            self.btn10.isEnabled = true
            self.btn11.isEnabled = true
            print("my value less  than 100000")
            
            
            guard let button = sender as? UIButton else {
                return
            }
            switch button.tag  {
            case  1:
                lblDisplay.text = String((lblDisplay.text ?? "") + "1")
            case  2:
                lblDisplay.text = String((lblDisplay.text ?? "") + "2")
            case  3:
                lblDisplay.text = String((lblDisplay.text ?? "") + "3")
            case  4:
                lblDisplay.text = String((lblDisplay.text ?? "") + "4")
            case  5:
                lblDisplay.text = String((lblDisplay.text ?? "") + "5")
            case  6:
                lblDisplay.text = String((lblDisplay.text ?? "") + "6")
            case  7:
                lblDisplay.text = String((lblDisplay.text ?? "") + "7")
            case  8:
                lblDisplay.text = String((lblDisplay.text ?? "") + "8")
            case  9:
                lblDisplay.text = String((lblDisplay.text ?? "") + "9")
            case  10:
                lblDisplay.text = String((lblDisplay.text ?? "") + "0")
            case  11:
                if lblDisplay.text?.contains(".") == true{
                    
                    
                }else{
                    
                    lblDisplay.text = String((lblDisplay.text ?? "") + ".")
                }
            default:
                print(".....")
            }
            
            let strvar = lblDisplay.text ?? ""
            if lblDisplay.text?.contains("$") == true{
                
            }else{
                
                lblDisplay.text = "$\(strvar)"
            }
            let strText = lblDisplay.text ?? ""
            FinalPayment = lblDisplay.text ?? ""
            let value1 = strText.replacingOccurrences(of: ",", with: "")
            let value22 = value1.replacingOccurrences(of: "$", with: "")
            let myValue = Double(value22) ?? 0.0
            FinalPayment = "\(myValue)"
            print("Final payment is -\(FinalPayment)")
            
            if lblDisplay.text?.contains(".") == true{
                let array = lblDisplay.text?.components(separatedBy: ".")
                if array?.count  == 2
                {
                    let ZeroIndex = array?[0]
                    let firstValue = String(ZeroIndex  ?? "")
                    let firsIndex = array?[1]
                    let secondValue = String(firsIndex?.prefix(2) ?? "sss")
                    lblDisplay.text = firstValue + "." + secondValue
                    print("complete value     \(firstValue + "." + secondValue)")
                    let obj = "\(firstValue + "." + secondValue)"
                    let Finalvaluef = obj.replacingOccurrences(of: ",", with: "")
                    let Finalvalueg = Finalvaluef.replacingOccurrences(of: "$", with: "")
                    
                    FinalPayment = Finalvalueg
                    print("Final payment is -\(FinalPayment)")
                    
                }
            }
            
            if myValue >= 1000 && myValue < 10000{
                
                let valu = lblDisplay.text
                finalvalue = valu?.replacingOccurrences(of: ",", with: "") ?? ""
                let valu1 = lblDisplay.text
                finalvalue = valu1?.replacingOccurrences(of: ",", with: "") ?? ""
                finalvalue.insert(",", at: finalvalue.index(finalvalue.startIndex, offsetBy: 2))
                lblDisplay.text = "\(finalvalue)"
                let value2 = finalvalue.replacingOccurrences(of: ",", with: "")
                let value3 = value2.replacingOccurrences(of: "$", with: "")
                FinalPayment = value3
                print("Final payment is - \(FinalPayment)")
                
                if lblDisplay.text?.contains(".") == true{
                    let array = lblDisplay.text?.components(separatedBy: ".")
                    if array?.count  == 2
                    {
                        let ZeroIndex = array?[0]
                        let firstValue = String(ZeroIndex  ?? "")
                        let firsIndex = array?[1]
                        let secondValue = String(firsIndex?.prefix(2) ?? "sss")
                        lblDisplay.text = firstValue + "." + secondValue
                        print("complete value     \(firstValue + "." + secondValue)")
                        let obj = "\(firstValue + "." + secondValue)"
                        let Finalvaluef = obj.replacingOccurrences(of: ",", with: "")
                        let Finalvaluee = Finalvaluef.replacingOccurrences(of: ",", with: "")
                        FinalPayment = Finalvaluee
                        print("Final payment is -\(FinalPayment)")
                        
                    }
                }
                
                
            }else  if myValue >= 10000 && myValue < 99999{
                
                let valu2 = lblDisplay.text
                finalvalue = valu2?.replacingOccurrences(of: ",", with: "") ?? ""
                let valu1 = lblDisplay.text
                FinalPayment = valu1?.replacingOccurrences(of: ",", with: "") ?? ""
                FinalPayment.insert(",", at: FinalPayment.index(FinalPayment.startIndex, offsetBy: 3))
                let removecomma = FinalPayment.replacingOccurrences(of: ",", with: "")
                let removedoller = removecomma.replacingOccurrences(of: "$", with: "")
                let finalyvalue = Double(removedoller) ?? 0.0
                
            
                    
                    
                    lblDisplay.text = FinalPayment
                    let value3 = FinalPayment.replacingOccurrences(of: ",", with: "")
                    let value4 = value3.replacingOccurrences(of: "$", with: "")
                    FinalPayment = value4
                    print("Final payment is -\(FinalPayment)")
                    
                    
                    if lblDisplay.text?.contains(".") == true{
                        
                        let array = lblDisplay.text?.components(separatedBy: ".")
                        if array?.count  == 2
                        {
                            let ZeroIndex = array?[0]
                            let firstValue = String(ZeroIndex  ?? "")
                            let firsIndex = array?[1]
                            let secondValue = String(firsIndex?.prefix(2) ?? "")
                            lblDisplay.text = firstValue + "." + secondValue
                            print("complete value     \(firstValue + "." + secondValue)")
                            let obj = "\(firstValue + "." + secondValue)"
                            let Finalvaluef = obj.replacingOccurrences(of: ",", with: "")
                            let Finalvalueg = Finalvaluef.replacingOccurrences(of: "$", with: "")
                            FinalPayment = Finalvalueg
                            print("Final payment is -\(FinalPayment)")
                        }
                }
                
            }else if myValue == 100000{
                
                
                
                let value = self.lblDisplay.text ?? ""
                finalvalue = value.replacingOccurrences(of: ",", with: "")
                finalvalue.insert(",", at: finalvalue.index(finalvalue.startIndex, offsetBy: 2))
                finalvalue.insert(",", at: finalvalue.index(finalvalue.startIndex, offsetBy: 5))
                lblDisplay.text = "\(finalvalue)"
                
                var valuewithout$ = finalvalue.replacingOccurrences(of: "$", with: "")
                strClearCount = "\(valuewithout$)"
                FinalPayment = "\(valuewithout$)"
                
    
            }
            else if myValue >= 100000{
                
                let value = self.lblDisplay.text ?? ""
                var valuewithoutcomma = value.replacingOccurrences(of: ",", with: "")
                valuewithoutcomma.remove(at: valuewithoutcomma.index(before: valuewithoutcomma.endIndex))    // "d"
                print(valuewithoutcomma)
                
                var myvalwith$ = valuewithoutcomma.replacingOccurrences(of: "$", with: "")
                var myvalugreater = Double(myvalwith$) ?? 0.0
                
                if myvalugreater < 100000{
                    
                    finalvalue = valuewithoutcomma.replacingOccurrences(of: ",", with: "")
                    FinalPayment = finalvalue.replacingOccurrences(of: ",", with: "")
                    FinalPayment.insert(",", at: FinalPayment.index(FinalPayment.startIndex, offsetBy: 3))
                    lblDisplay.text = "\(FinalPayment)"
                    var valuewithout$ = valuewithoutcomma.replacingOccurrences(of: "$", with: "")
                    finalvalue = valuewithout$.replacingOccurrences(of: ",", with: "")
                    strClearCount = "\(finalvalue)"
                    FinalPayment = "\(finalvalue)"
                                   
                }else if myvalugreater > 100000{
                    
                    finalvalue = valuewithoutcomma.replacingOccurrences(of: ",", with: "")
                    FinalPayment = finalvalue.replacingOccurrences(of: ",", with: "")
                    FinalPayment.insert(",", at: FinalPayment.index(FinalPayment.startIndex, offsetBy: 3))
                    lblDisplay.text = "\(FinalPayment)"
                    var valuewithout$ = valuewithoutcomma.replacingOccurrences(of: "$", with: "")
                    finalvalue = valuewithout$.replacingOccurrences(of: ",", with: "")
                    strClearCount = "\(finalvalue)"
                    FinalPayment = "\(finalvalue)"
                    print("************** my value grater than 1 lakh ")
                }
                else if myvalugreater == 100000{
                    
                    finalvalue = valuewithoutcomma.replacingOccurrences(of: ",", with: "")
                    FinalPayment = finalvalue.replacingOccurrences(of: ",", with: "")
                    FinalPayment.insert(",", at: FinalPayment.index(FinalPayment.startIndex, offsetBy: 2))
                    FinalPayment.insert(",", at: FinalPayment.index(FinalPayment.startIndex, offsetBy: 5))

                    lblDisplay.text = "\(FinalPayment)"
                    var valuewithout$ = valuewithoutcomma.replacingOccurrences(of: "$", with: "")
                    finalvalue = valuewithout$.replacingOccurrences(of: ",", with: "")
                    strClearCount = "\(finalvalue)"
                    FinalPayment = "\(finalvalue)"
                    print("************** my value grater than 1 lakh ")
                }
                
//                lblDisplay.text = "\(FinalPayment)"
//
//                var valuewithout$ = valuewithoutcomma.replacingOccurrences(of: "$", with: "")
//                finalvalue = valuewithout$.replacingOccurrences(of: ",", with: "")
//
//                strClearCount = "\(finalvalue)"
//                FinalPayment = "\(finalvalue)"
  
            }
            
        }
    }
    @IBAction func btnPoint(_ sender: Any) {
    }
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSendPayment(sender: AnyObject) {
        let stramount = lblDisplay.text ?? ""
        let myAmount = stramount.replacingOccurrences(of: ",", with: "")
        let myAmount2 = myAmount.replacingOccurrences(of: "$", with: "")
        let DblAmount = Double(myAmount2) ?? 0.0
        
        print(FinalPayment)
        print(DblAmount)
        
        
        
        print("Final value \(FinalPayment)")
        if myAmount2 == "" ||  FinalPayment == "" {
            objAlert.showAlert(message: "Please Enter Amount", title: kAlertTitle, controller: self)
        }else if DblAmount > 90000{
            objAlert.showAlert(message:"Payments must not exceed $90,000 per transaction.  Please renter a lesser amount to complete transaction.", title: kAlertTitle, controller: self)
        }
            
            
        else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentTanTabVC") as! PaymentTanTabVC
            self.navigationController?.pushViewController(vc, animated: true)
            // self.lblDisplay.text = ""
        }
    }
    @IBAction func btnClearAmount(_ sender: Any) {
        let value = self.lblDisplay.text ?? ""
        let objclrcomma = value.replacingOccurrences(of: ",", with: "")
        let objclrcdoller = objclrcomma.replacingOccurrences(of: "$", with: "")
        let Doublevalue = Double(objclrcdoller) ?? 0.0
        
        
        if  Doublevalue > 100000{
            self.btn1.isEnabled = false
            self.btn2.isEnabled = false
            self.btn3.isEnabled = false
            self.btn4.isEnabled = false
            self.btn5.isEnabled = false
            self.btn6.isEnabled = false
            self.btn7.isEnabled = false
            self.btn8.isEnabled = false
            self.btn9.isEnabled = false
            self.btn10.isEnabled = false
            self.btn11.isEnabled = false
            print("my value greater than 90000")
            
        }else{
            self.btn1.isEnabled = true
            self.btn2.isEnabled = true
            self.btn3.isEnabled = true
            self.btn4.isEnabled = true
            self.btn5.isEnabled = true
            self.btn6.isEnabled = true
            self.btn7.isEnabled = true
            self.btn8.isEnabled = true
            self.btn9.isEnabled = true
            self.btn10.isEnabled = true
            self.btn11.isEnabled = true
            print("my value less  than 90000")
            
        }
        if value != "" {
            let value = self.lblDisplay.text ?? ""
            var valuewithoutcomma = value.replacingOccurrences(of: ",", with: "") ?? ""
            valuewithoutcomma.remove(at: valuewithoutcomma.index(before: valuewithoutcomma.endIndex))    // "d"
            print(valuewithoutcomma)
            var valuewithout$ = valuewithoutcomma.replacingOccurrences(of: "$", with: "") ?? ""
            strClearCount = "\(valuewithoutcomma)"
            lblDisplay.text = "\(valuewithoutcomma)"
            FinalPayment = "\(valuewithout$)"
            
            print("Final paymet is - \(FinalPayment)")
            if FinalPayment == ""{
                self.lblNoAmount.isHidden = false
                
                
            }
        }
        else{
            
            self.lblNoAmount.isHidden = false
        }
        
        
        
    }
    //MARK:Local function -
    func UiDesign(){
        self.imgProfile.setImgCircle()
        self.viewProfileImg.setviewCirclewhite()
        self.viewProfileImg.setshadowViewCircle()
    }
}



// formatting text for currency textField
extension String {
    // formatting text for currency textField
    func currencyFormatting() -> String {
        if let value = Double(self) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.allowsFloats = true
            
            formatter.maximumFractionDigits = 2
            if let str = formatter.string(for: value) {
                
                finalvalue = "\(str)"
                // paymentDone = "\(str).0"
                print(finalvalue)
                return str
            }
        }
        return ""
    }
}
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
extension String {
    func substring(from: Int?, to: Int?) -> String {
        if let start = from {
            guard start < self.count else {
                return ""
            }
        }
        
        if let end = to {
            guard end >= 0 else {
                return ""
            }
        }
        
        if let start = from, let end = to {
            guard end - start >= 0 else {
                return ""
            }
        }
        
        let startIndex: String.Index
        if let start = from, start >= 0 {
            startIndex = self.index(self.startIndex, offsetBy: start)
        } else {
            startIndex = self.startIndex
        }
        
        let endIndex: String.Index
        if let end = to, end >= 0, end < self.count {
            endIndex = self.index(self.startIndex, offsetBy: end + 1)
        } else {
            endIndex = self.endIndex
        }
        
        return String(self[startIndex ..< endIndex])
    }
    
    func substring(from: Int) -> String {
        return self.substring(from: from, to: nil)
    }
    
    func substring(to: Int) -> String {
        return self.substring(from: nil, to: to)
    }
    
    func substring(from: Int?, length: Int) -> String {
        guard length > 0 else {
            return ""
        }
        
        let end: Int
        if let start = from, start > 0 {
            end = start + length - 1
        } else {
            end = length - 1
        }
        
        return self.substring(from: from, to: end)
    }
    
    func substring(length: Int, to: Int?) -> String {
        guard let end = to, end > 0, length > 0 else {
            return ""
        }
        
        let start: Int
        if let end = to, end - length > 0 {
            start = end - length + 1
        } else {
            start = 0
        }
        
        return self.substring(from: start, to: to)
    }
}

/*
 
 
 
 import UIKit
 import Foundation
 
 var finalvalue = ""
 var FinalPayment = ""
 var payment = ""
 var paymentDone = ""
 class MakePaymentVC: UIViewController,UITextFieldDelegate {
 
 
 var numberOnScreen : Int = 0
 
 
 @IBOutlet weak var lblNOAmount: UILabel!
 @IBOutlet weak var viewProfileImg: UIView!
 @IBOutlet weak var lblTenantName: UILabel!
 @IBOutlet weak var imgProfile: UIImageView!
 @IBOutlet weak var viewAlert: UIView!
 @IBOutlet weak var viewAlertContsiner: UIView!
 @IBOutlet weak var viewAlertHeader: UIView!
 @IBOutlet weak var btnOk: customButton!
 @IBOutlet weak var imgSelectedCheckBox: UIImageView!
 @IBOutlet weak var lblPropertyName: UILabel!
 @IBOutlet weak var lblDisplay: UILabel!
 @IBOutlet weak var viewContent: UIView!
 
 
 override func viewDidLoad() {
 super.viewDidLoad()
 isNocardForPayment = false
 self.UiDesign()
 
 }
 
 override func viewWillAppear(_ animated: Bool) {
 super.viewWillAppear(true)
 self.lblTenantName.text = "\(objAppShareData.UserDetail.strFirstName) \(objAppShareData.UserDetail.strLastName)"
 isNocardForPayment = false
 
 let strimage = objAppShareData.UserDetail.strProfilePicture
 let urlImg = URL(string: strimage)
 self.imgProfile.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "profile_ico"))
 
 self.lblDisplay?.text = ""
 
 }
 
 override var preferredStatusBarStyle: UIStatusBarStyle {
 return .lightContent
 }
 
 @IBAction func btnNumberTapped(sender: AnyObject) {
 print(sender)
 let text = lblDisplay.text ?? ""
 print("label value \(text)")
 
 
 guard let button = sender as? UIButton else {
 return
 }
 switch button.tag  {
 case  1:
 lblDisplay.text = String((lblDisplay.text ?? "") + "1")
 case  2:
 lblDisplay.text = String((lblDisplay.text ?? "") + "2")
 case  3:
 lblDisplay.text = String((lblDisplay.text ?? "") + "3")
 case  4:
 lblDisplay.text = String((lblDisplay.text ?? "") + "4")
 case  5:
 lblDisplay.text = String((lblDisplay.text ?? "") + "5")
 case  6:
 lblDisplay.text = String((lblDisplay.text ?? "") + "6")
 case  7:
 lblDisplay.text = String((lblDisplay.text ?? "") + "7")
 case  8:
 lblDisplay.text = String((lblDisplay.text ?? "") + "8")
 case  9:
 lblDisplay.text = String((lblDisplay.text ?? "") + "9")
 case  10:
 lblDisplay.text = String((lblDisplay.text ?? "") + "0")
 case  11:
 if lblDisplay.text?.contains(".") == true{
 
 
 }else{
 
 lblDisplay.text = String((lblDisplay.text ?? "") + ".")
 }
 default:
 print(".....")
 }
 
 
 
 
 let strText = lblDisplay.text ?? ""
 FinalPayment = lblDisplay.text ?? ""
 let value = strText.replacingOccurrences(of: ",", with: "")
 let myValue = Double(value) ?? 0.0
 FinalPayment = value
 
 if lblDisplay.text?.contains(".") == true{
 
 let array = lblDisplay.text?.components(separatedBy: ".")
 
 if array?.count  == 2
 {
 let ZeroIndex = array?[0]
 let firstValue = String(ZeroIndex  ?? "")
 let firsIndex = array?[1]
 let secondValue = String(firsIndex?.prefix(2) ?? "sss")
 lblDisplay.text = firstValue + "." + secondValue
 print("complete value     \(firstValue + "." + secondValue)")
 let obj = "\(firstValue + "." + secondValue)"
 let Finalvaluef = obj.replacingOccurrences(of: ",", with: "")
 
 FinalPayment = Finalvaluef
 }
 }
 
 
 
 if myValue >= 90000{
 objAlert.showAlert(message:"Payments must not exceed $90,000 per transaction.  Please renter a lesser amount to complete transaction.", title: kAlertTitle, controller: self)
 }else{
 // let dollar = NSNumber(value: myValue)
 if myValue > 1000 && myValue < 10000{
 
 let valu = lblDisplay.text
 finalvalue = valu?.replacingOccurrences(of: ",", with: "") ?? ""
 
 let valu1 = lblDisplay.text
 finalvalue = valu1?.replacingOccurrences(of: ",", with: "") ?? ""
 finalvalue.insert(",", at: finalvalue.index(finalvalue.startIndex, offsetBy: 1))
 lblDisplay.text = "\(finalvalue)"
 
 let value2 = finalvalue.replacingOccurrences(of: ",", with: "")
 FinalPayment = value2
 
 if lblDisplay.text?.contains(".") == true{
 
 let array = lblDisplay.text?.components(separatedBy: ".")
 if array?.count  == 2
 {
 let ZeroIndex = array?[0]
 let firstValue = String(ZeroIndex  ?? "")
 let firsIndex = array?[1]
 let secondValue = String(firsIndex?.prefix(2) ?? "sss")
 lblDisplay.text = firstValue + "." + secondValue
 print("complete value     \(firstValue + "." + secondValue)")
 let obj = "\(firstValue + "." + secondValue)"
 let Finalvaluef = obj.replacingOccurrences(of: ",", with: "")
 
 FinalPayment = Finalvaluef
 }
 }
 
 
 }else  if myValue > 10000 && myValue < 90000{
 
 let valu2 = lblDisplay.text
 finalvalue = valu2?.replacingOccurrences(of: ",", with: "") ?? ""
 let valu1 = lblDisplay.text
 FinalPayment = valu1?.replacingOccurrences(of: ",", with: "") ?? ""
 FinalPayment.insert(",", at: FinalPayment.index(FinalPayment.startIndex, offsetBy: 2))
 lblDisplay.text = FinalPayment
 let value3 = FinalPayment.replacingOccurrences(of: ",", with: "")
 FinalPayment = value3
 
 if lblDisplay.text?.contains(".") == true{
 
 let array = lblDisplay.text?.components(separatedBy: ".")
 if array?.count  == 2
 {
 let ZeroIndex = array?[0]
 let firstValue = String(ZeroIndex  ?? "")
 let firsIndex = array?[1]
 let secondValue = String(firsIndex?.prefix(2) ?? "")
 lblDisplay.text = firstValue + "." + secondValue
 print("complete value     \(firstValue + "." + secondValue)")
 let obj = "\(firstValue + "." + secondValue)"
 let Finalvaluef = obj.replacingOccurrences(of: ",", with: "")
 FinalPayment = Finalvaluef
 }
 
 }
 }
 
 }
 }
 @IBAction func btnPoint(_ sender: Any) {
 }
 @IBAction func btnBack(_ sender: Any) {
 navigationController?.popViewController(animated: true)
 }
 @IBAction func btnSendPayment(sender: AnyObject) {
 print("Final value \(FinalPayment)")
 if lblDisplay.text == ""{
 objAlert.showAlert(message: "Please Enter Amount", title: kAlertTitle, controller: self)
 }else{
 let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentTanTabVC") as! PaymentTanTabVC
 self.navigationController?.pushViewController(vc, animated: true)
 // self.lblDisplay.text = ""
 }
 }
 @IBAction func btnClearAmount(_ sender: Any) {
 let value = self.lblDisplay.text ?? ""
 
 if value != "" {
 let value = self.lblDisplay.text ?? ""
 var valuewithoutcomma = value.replacingOccurrences(of: ",", with: "") ?? ""
 valuewithoutcomma.remove(at: valuewithoutcomma.index(before: valuewithoutcomma.endIndex))    // "d"
 print(valuewithoutcomma)
 lblDisplay.text = "\(valuewithoutcomma)"
 FinalPayment = "\(valuewithoutcomma)"
 
 print("Final paymet is - \(FinalPayment)")
 
 }else{
 
 
 }
 
 
 }
 //MARK:Local function -
 func UiDesign(){
 self.imgProfile.setImgCircle()
 self.viewProfileImg.setviewCirclewhite()
 self.viewProfileImg.setshadowViewCircle()
 }
 }
 
 
 
 // formatting text for currency textField
 extension String {
 // formatting text for currency textField
 func currencyFormatting() -> String {
 if let value = Double(self) {
 let formatter = NumberFormatter()
 formatter.numberStyle = .decimal
 formatter.allowsFloats = true
 
 formatter.maximumFractionDigits = 2
 if let str = formatter.string(for: value) {
 
 finalvalue = "\(str)"
 // paymentDone = "\(str).0"
 print(finalvalue)
 return str
 }
 }
 return ""
 }
 }
 extension Double {
 /// Rounds the double to decimal places value
 func rounded(toPlaces places:Int) -> Double {
 let divisor = pow(10.0, Double(places))
 return (self * divisor).rounded() / divisor
 }
 }
 extension String {
 func substring(from: Int?, to: Int?) -> String {
 if let start = from {
 guard start < self.count else {
 return ""
 }
 }
 
 if let end = to {
 guard end >= 0 else {
 return ""
 }
 }
 
 if let start = from, let end = to {
 guard end - start >= 0 else {
 return ""
 }
 }
 
 let startIndex: String.Index
 if let start = from, start >= 0 {
 startIndex = self.index(self.startIndex, offsetBy: start)
 } else {
 startIndex = self.startIndex
 }
 
 let endIndex: String.Index
 if let end = to, end >= 0, end < self.count {
 endIndex = self.index(self.startIndex, offsetBy: end + 1)
 } else {
 endIndex = self.endIndex
 }
 
 return String(self[startIndex ..< endIndex])
 }
 
 func substring(from: Int) -> String {
 return self.substring(from: from, to: nil)
 }
 
 func substring(to: Int) -> String {
 return self.substring(from: nil, to: to)
 }
 
 func substring(from: Int?, length: Int) -> String {
 guard length > 0 else {
 return ""
 }
 
 let end: Int
 if let start = from, start > 0 {
 end = start + length - 1
 } else {
 end = length - 1
 }
 
 return self.substring(from: from, to: end)
 }
 
 func substring(length: Int, to: Int?) -> String {
 guard let end = to, end > 0, length > 0 else {
 return ""
 }
 
 let start: Int
 if let end = to, end - length > 0 {
 start = end - length + 1
 } else {
 start = 0
 }
 
 return self.substring(from: start, to: to)
 }
 }
 
 
 */
