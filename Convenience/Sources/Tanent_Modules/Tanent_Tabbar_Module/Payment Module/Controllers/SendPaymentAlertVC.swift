//
//  SendPaymentAlertVC.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 19/05/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import SVProgressHUD

var isNocardForPaymentAlert = false

class SendPaymentAlertVC: UIViewController {
    
      var numberOnScreen : Int = 0
      @IBOutlet weak var lblNOAmount: UILabel!
      @IBOutlet weak var viewProfileImg: UIView!
      @IBOutlet weak var lblTenantName: UILabel!
      @IBOutlet weak var imgProfile: UIImageView!
      @IBOutlet weak var viewAlert: UIView!
      @IBOutlet weak var viewAlertContsiner: UIView!
      @IBOutlet weak var viewAlertHeader: UIView!
      @IBOutlet weak var btnMakePayment: customButton!

      @IBOutlet weak var btnOk: customButton!
      @IBOutlet weak var imgSelectedCheckBox: UIImageView!
      @IBOutlet weak var lblPropertyName: UILabel!
    @IBOutlet weak var lblNoAmount: UILabel!

      @IBOutlet weak var lblDisplay: UILabel!
      @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var viewDueMonthList: UIView!
    @IBOutlet weak var viewdueMonthForRadius: UIView!
    @IBOutlet weak var tblDuemonthLIst: UITableView!
   
    @IBOutlet weak var tblduehiegthConst: NSLayoutConstraint!
    @IBOutlet weak var ViewALert: UIView!
    @IBOutlet weak var viewPaymetnSuccesAlert: UIView!
    @IBOutlet weak var viewConfirmALert: UIView!
    @IBOutlet weak var viewPaymentSuccesHeaderForRadius: UIView!
    @IBOutlet weak var viewConALertForRadiuse: UIView!
    
    
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
    
    //MARK:Local Variables -
    var arrpendingmonthAlert = [PaymentModel]()
    var isrowselected = false
    var PropertyId = ""
    var arCardListAlert = [CardListModel]()
    var prpertyStatusForPayment = ""

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isNocardForPayment = false
        self.lblNoAmount.isHidden = false

        self.tblDuemonthLIst.dataSource = self
        self.tblDuemonthLIst.delegate = self
        self.viewDueMonthList.isHidden = true
        self.ViewALert.isHidden = true
        self.UiDesign()
  
    }
    
    override func viewDidLayoutSubviews() {
        self.lblDisplay.minimumScaleFactor = 10/UIFont.labelFontSize
        self.lblDisplay.adjustsFontSizeToFitWidth = true
       }
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(true)
    
        print("Property Id is \(PropertyID)")
         self.lblTenantName.text = "\(objAppShareData.UserDetail.strFirstName) \(objAppShareData.UserDetail.strLastName)"
          isNocardForPayment = false

         let strimage = objAppShareData.UserDetail.strProfilePicture
         let urlImg = URL(string: strimage)
         self.imgProfile.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "profile_ico"))

         self.lblDisplay?.text = ""
        
        self.GetProprtyDetails()

        if  self.lblDisplay?.text == "" {
                   self.lblNoAmount.isHidden = false
                   
               }
     }
    override var preferredStatusBarStyle: UIStatusBarStyle {
           return .lightContent
       }
 
     
    @IBAction func btnSuccessALertOOK(_ sender: Any) {
        self.ViewALert.isHidden = true

    }
    
    
    @IBAction func vwConfirmAlertDOne(_ sender: Any) {
      //  self.viewAlert.isHidden = true
        self.ViewALert.isHidden = true
       // self.callWSForGetCardListAlert()

        if DefaultCardId == ""{
            objAlert.showAlertCallBackOk(alertLeftBtn: "Ok", title: kAlertTitle, message: "You need to add card first", controller: self) {
                                     
                    self.RedirectAddCard()
                }
                    
        }else{
            self.webServiceMakePaymentAlert()
        }
    //  self.webServiceMakePaymentAlert()

    }
    
    @IBAction func btnConfirAlertCancel(_ sender: Any) {
        self.ViewALert.isHidden = true
        month = ""
        lblDisplay.text = ""
        lblNoAmount.isHidden = false
        self.tblDuemonthLIst.reloadData()

    }
     @IBAction func btnPoint(_ sender: Any) {
        
        }
    @IBAction func btnCloseDuemonthView(_ sender: Any) {
        self.viewDueMonthList.isHidden = true
        month = ""
        self.tblDuemonthLIst.reloadData()
    }
    
    @IBAction func btnMakePayment(_ sender: Any) {
        if month == ""{
                 print("id nil please select property ")
                 objAlert.showAlert(message: "You don't select month yet please select month", title: kAlertTitle, controller: self)
             }else {
                 self.viewDueMonthList.isHidden = true
                 self.ViewALert.isHidden = false
                 self.viewConfirmALert.isHidden = false
                 self.viewPaymetnSuccesAlert.isHidden = true
             }
    }
    
        @IBAction func btnBack(_ sender: Any) {
            navigationController?.popViewController(animated: true)
        }
        @IBAction func btnSendPayment(sender: AnyObject) {
            
         print("Final value \(FinalPayment)")
           
            if lblDisplay.text == ""{
                objAlert.showAlert(message: "Please Enter Amount", title: kAlertTitle, controller: self)
            }else{
                
                if Ispayable == 1 {
                             self.viewDueMonthList.isHidden = false
                             self.GetmonthList()
                    }else {
                    objAlert.showAlert(message: "You can not proceed with payment because owner's billing account setup is not correct, Please contact property owner.", title: kAlertTitle, controller: self)
                    self.lblDisplay.text = ""
                    FinalPayment = ""
                    self.lblNoAmount.isHidden = false
                    self.tblDuemonthLIst.reloadData()
                        
                         }
               
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentTanTabVC") as! PaymentTanTabVC
//
//                self.navigationController?.pushViewController(vc, animated: true)
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
            self.viewdueMonthForRadius.setViewRadius10()
            
           self.btnOk.setradiusbtn()
                  //self.viewAlertHeader.setViewRadius10()
                  self.viewConfirmALert.setViewCornerRadius()
                 self.viewPaymetnSuccesAlert.setViewCornerRadius()

           // self.viewConALertForRadiuse.setShadowAllView10()
                  self.viewConALertForRadiuse.setViewRadius10()
                  self.viewPaymentSuccesHeaderForRadius.setViewRadius10()
                //  self.viewPaymentSuccesHeaderForRadius.setShadowAllView10()

        }
       @IBAction func btnNumberTapped(sender: AnyObject) {
         print(sender)
        self.lblNoAmount.isHidden = true

               //  self.lblNoAmount.isHidden = true
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
                     FinalPayment = String(myValue)
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
                         
          
                         
                     }
                     
                 }     }
}
 extension SendPaymentAlertVC : UITableViewDataSource,UITableViewDelegate{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
     {
             self.tblduehiegthConst.constant = CGFloat(arrpendingmonthAlert.count * 60)
             return  arrpendingmonthAlert.count
     }
     
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
             let cellTwo = tblDuemonthLIst.dequeueReusableCell(withIdentifier: "PendingMonthCellAlertRedirection")  as! PendingMonthCellAlertRedirection
             let obj = arrpendingmonthAlert[indexPath.row]
             cellTwo.lblPendingMonth.text = obj.strtext
             if month == obj.strmonth{
                 cellTwo.imgSelection.image = #imageLiteral(resourceName: "ico_checkbox_active")
             }else{
                 cellTwo.imgSelection.image = #imageLiteral(resourceName: "complete_inactive_ico")
             }
             return cellTwo
             tblDuemonthLIst.reloadData()
         
     }
     
     
     func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
             print(indexPath)
             let cellTwo = tblDuemonthLIst.dequeueReusableCell(withIdentifier: "PendingMonthCellAlertRedirection")  as? PendingMonthCellAlertRedirection
             let obj = arrpendingmonthAlert[indexPath.row]
             
             isrowselected = true
             if month == obj.strmonth{
                 month = ""
                 Year = ""
             }else{
                 month = obj.strmonth
                 Year = obj.stryear
             }
             self.tblDuemonthLIst.reloadData()
         }

 }

    
// formatting text for currency textField
extension String {
// formatting text for currency textField
func CurrencyFormatting() -> String {
if let value = Double(self) {
let formatter = NumberFormatter()
formatter.numberStyle = .decimal
formatter.maximumFractionDigits = 2
if let str = formatter.string(for: value) {
    finalvalue = "\(str)"
    print(finalvalue)
return str
}
}
    
return ""
}
}

extension SendPaymentAlertVC{
    func GetmonthList(){
        SVProgressHUD.show()
        arrpendingmonthAlert.removeAll()
        self.view.endEditing(true)
        objWebServiceManager.requestGet(strURL: WsUrl.GetMonthList+String(PropertyIdAlert), params: nil, queryParams: [:], strCustomValidation: "",success: { (response) in
            print(response)
            //self.totalRecords = response["total_records"] as? Int ?? 0
            let message = response["message"] as? String ?? ""
            let status = response["status"] as? String ?? ""
            let datafound = Int(response["data_found"] as? String ?? "") ?? 0
            print(datafound)
            
            if   status == "success" {
                
                SVProgressHUD.dismiss()
                if let data = response["data"]as? [String:Any]{
                    
                    if let arrTenantList = data["rent_months_list"]as? [[String:Any]]{
                        for dic in arrTenantList{
                            let obj = PaymentModel.init(dict: dic)
                            self.arrpendingmonthAlert.append(obj)

                            print(obj)
                        }
                        
                    }else{
                        self.tblDuemonthLIst.reloadData()
                        
                    }
                    self.tblDuemonthLIst.reloadData()
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
            objAlert.showAlert(message: kErrorMessage, title: kAlertTitle, controller: self)
        })
        
    }
}
extension SendPaymentAlertVC{
    func webServiceMakePaymentAlert(){
        SVProgressHUD.show()
        self.view.endEditing(true)
        
        let param = [WsParam.month:String(month),
                     WsParam.cardid:DefaultCardId,
                     WsParam.propertyid:String(PropertyIdAlert),
                     WsParam.year:String(Year),
                     WsParam.amount:String(FinalPayment)] as [String : Any]
        self.view.endEditing(true)
        print(param)
        
        objWebServiceManager.requestPost(strURL: WsUrl.PaymentProperty, queryParams: [:], params: param, strCustomValidation: "", showIndicator: true, success: { (response) in
            print(response)
            let message = response["message"] as? String ?? ""
            let status = response["status"] as? String ?? ""
            let datafound = Int(response["data_found"] as? String ?? "") ?? 0
            print(datafound)
            
            if   status == "success" {
              
                SVProgressHUD.dismiss()
                if message == "Property rent payment has successfully done"{
                    self.ViewALert.isHidden = false
                    self.viewPaymetnSuccesAlert.isHidden = false
                    self.viewConfirmALert.isHidden = true
                    month = ""
                    Year = ""
                    FinalPayment = ""
                    self.viewDueMonthList.isHidden = true
                    isNocardForPaymentAlert = false
                    isCommingFrom = false

                }else{
                    SVProgressHUD.dismiss()

                    self.viewAlert.isHidden = true
                  //  self.RedirectToMakePayment()
                     month = ""
                     Year = ""
                    objAlert.showAlert(message:message, title: kAlertTitle, controller: self)
                }
            }
          
            
            else{
               month = ""
                              Year = ""
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
            month = ""
            Year = ""
            SVProgressHUD.dismiss()
            self.viewAlert.isHidden = true

         //   self.RedirectToMakePayment()
            objAlert.showAlert(message: kErrorMessage, title: kAlertTitle, controller: self)
        })
        
    }
}
extension SendPaymentAlertVC{
    
    func callWSForGetCardListAlert(){
        SVProgressHUD.show()
        self.arCardListAlert.removeAll()
        objWebServiceManager.requestGet(strURL: WsUrl.CardList, params: [:], queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            let status = response["status"] as? String
            let message = response["message"] as? String ?? ""

            if status == "success"{
                SVProgressHUD.dismiss()

                self.arCardListAlert.removeAll()
                let data = response["data"] as? [String:Any] ?? [:]
                let dataFound = data["data_found"] as? Int ?? 0
                SVProgressHUD.dismiss()
                if dataFound == 0{
                    if self.arCardListAlert.count == 0 {
                        DefaultCardId = ""
 
                    }
                }else{
                    let cardDetail = data["card_list"] as? [[String:Any]]
                    for obj in cardDetail ?? [[:]]{
                        let modelObject = CardListModel.init(dict: obj)
                        self.arCardListAlert.append(modelObject)
                        if  modelObject.strIs_default == "1" {
                            DefaultCardId = modelObject.strcardID
                            print("Default Card Id Is \(DefaultCardId)")
                        }
                        print("***********\(DefaultCardId)")
                    }
                    print("***********\(DefaultCardId)")
                    if isNocardForPaymentAlert == true {
                        
                        self.webServiceMakePaymentAlert()
                    }

                }
               // self.tblView.reloadData()
                print(self.arCardListAlert.count)
            }  else{
                       
                          SVProgressHUD.dismiss()
                          if message == "k_sessionExpire"{
                              objAlert.showAlert(message: k_sessionExpire, title: kAlertTitle, controller: self)
                              objAppShareData.resetDefaultsAlluserInfo()
                              objAppDelegate.showLogInNavigation()
                          }  else{
                              objAlert.showAlert(message:message, title: kAlertTitle, controller: self)
                          }
                      }
        }) { (error) in
            print(error)
            SVProgressHUD.dismiss()
            
            objAlert.showAlert(message: "Something went wrong.", title: kAlertTitle, controller: self)
        }
    }
    
        func GetProprtyDetails(){
            SVProgressHUD.show()
            self.view.endEditing(true)
            objWebServiceManager.requestGet(strURL: WsUrl.PropetyDetails+String(PropertyId)+"?for="+String(objAppShareData.UserDetail.strUserType), params: nil, queryParams: [:], strCustomValidation: "",success: { (response) in
                print(response)
                
                let message = response["message"] as? String ?? ""
                let status = response["status"] as? String ?? ""
                let datafound = Int(response["data_found"] as? String ?? "") ?? 0
                print(datafound)
                
                if   status == "success" {
                    SVProgressHUD.dismiss()
                    if let data = response["data"]as? [String:Any]{
                        if let arrDetails = data["property_detail"]as? [[String:Any]]{
                            
                            for dic in arrDetails{
                                var statusN = 00
                                if let status = data["tenant_property_status"] as? Int{
                                    statusN = status
                                }else if let status = data["tenant_property_status"] as? String{
                                    statusN = Int(status)!
                                }
                                
                                if statusN == 0{
                                    objAlert.showAlertCallBackOk(alertLeftBtn: "OK", title: kAlertTitle, message: "you already leave this property.", controller: self) {
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                
                                }else{
                                    self.callWSForGetCardListAlert()
                                    
                                }
                                }
                            }
                        }
                
                }else{
                    SVProgressHUD.dismiss()
                    objAlert.showAlert(message:message, title: kAlertTitle, controller: self)

                }
            }, failure: { (error) in
                print(error)
                SVProgressHUD.dismiss()
                objAlert.showAlert(message: kErrorMessage, title: kAlertTitle, controller: self)
            })
            
        }
    
    func RedirectAddCard(){
        
        isNocardForPaymentAlert = true
        isCommingFrom = true
        let storyBoard = UIStoryboard(name: "Tanentside", bundle:nil)
        let AddPropertyVC = storyBoard.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
        self.navigationController?.pushViewController(AddPropertyVC, animated: false)
        
    }
    func RedirectToMakePayment(){
        
        self.navigationController?.popToRootViewController(animated: false)
        if let tabBarController = objAppDelegate.window!.rootViewController as? TabBarVC {
            tabBarController.selectedIndex = 0
            
        }
    }
}
