//
//  PaymentMethodVC.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 11/02/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import SVProgressHUD
var selectIndex = 0
var defaultCardId = ""
class PaymentMethodVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var viewNoRecord: UIView!
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    var cardNumberForCardAdd = "" //txtcardnumber text without spaces
    var cellHeightDictionary: NSMutableDictionary = [:]
    var arrCardList = [CardListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isCommingFrom = false
        self.uiDesign()
        self.viewNoRecord.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tblView.tableFooterView = UIView()
        if isnocard == true{
            isnocard = false
            self.navigationController?.popViewController(animated: true)
        }else{
            self.callWSForGetCardList(isFromMakeDefault: false)

        }
        
      
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddNewCard(_ sender: Any) {
        if self.arrCardList.count >= 5{
            objAlert.showAlert(message: "Max 5 card's can be added.", title: kAlertTitle, controller: self)
        }else{
            isCommingFrom = true

            let storyBoard = UIStoryboard(name: "Tanentside", bundle:nil)
            let AddPropertyVC = storyBoard.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
            self.navigationController?.pushViewController(AddPropertyVC, animated: true)
        }
    }
    //MARK: Local Methods-
    
    func uiDesign(){
        self.view1.setshadowView()
        self.view1.setViewRadius10()
        self.viewNoRecord.setViewRadius()
    }
}

//MARK:- tableview methods
extension PaymentMethodVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.arrCardList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodCell") as? PaymentMethodCell
        let objCard = self.arrCardList[indexPath.row]
        
        cell?.lblCardName.text = objCard.strCard_brand_type
        cell?.lblCardNumbers.text = "XXXX" + "XXXX" + "XXXX" + objCard.strCard_last_4_digits
        if objCard.strCard_brand_type == "Visa"{
            cell?.imgCardDetail.image = #imageLiteral(resourceName: "visa")
        }else if objCard.strCard_brand_type == "MasterCard"{
            cell?.imgCardDetail.image = #imageLiteral(resourceName: "mastercard")
        }else{
            cell?.imgCardDetail.image = #imageLiteral(resourceName: "default_card_img")
        }
        if objCard.strIs_default == "1"{
            cell?.btnMakeCardDefult.isHidden = true
            cell?.viewDefault.isHidden = false
            defaultCardId = objCard.strcardID
            
            UserDefaults.standard.set(defaultCardId, forKey: UserDefaults.KeysDefault.DefaultCardId)
            print(UserDefaults.standard.value(forKey: UserDefaults.KeysDefault.DefaultCardId))
            print("Default card is ***** \(UserDefaults.standard.value(forKey: UserDefaults.KeysDefault.DefaultCardId))")
            
            
        }else{
            cell?.btnMakeCardDefult.isHidden = false
            cell?.viewDefault.isHidden = true
        }
        cell?.btnMakeCardDefult.tag = indexPath.row
        cell?.btnMakeCardDefult.addTarget(self, action: #selector(btnMakeDefaultt(_:)), for:.touchUpInside)
        
        return cell ?? UITableViewCell()
    }
    @objc func btnMakeDefaultt(_ sender : UIButton) {
        let obj = self.arrCardList[sender.tag]
        print(obj.strStripe_card_id)
        
        self.callWSForMakeDefaultCard(cardID: obj.strStripe_card_id,normalcardId:obj.strcardID)
    }

    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //let obj = self.arrCardList[indexPath.row]
        
        let obj = self.arrCardList[indexPath.row]
        // TODO: For SendMessageAction
        let SendMessageAction = UIContextualAction(style: .normal, title: "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
                             if obj.strIs_default == "1"{
                                 objAlert.showAlert(message: "You cannot delete the default card.", title: kAlertTitle, controller: self)
            
                             }else{
                                self.deleteCard(indexData: indexPath.row)

                        }
             }
        )
          
        SendMessageAction.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        SendMessageAction.image = UIImage(named: "delete_ico")

        return UISwipeActionsConfiguration(actions: [SendMessageAction,])
    }
    
    func deleteCard(indexData: Int) {
        print(indexData)
        let objData = self.arrCardList[indexData]
        let id = objData.strStripe_card_id
        self.ShowAlertForCardDelete(cardID: id, IndexData: indexData)
    }
}

extension PaymentMethodVC {
    func callWSForGetCardList(isFromMakeDefault:Bool){
        if isFromMakeDefault == true{
        }else{
            SVProgressHUD.show()
        }
        self.arrCardList.removeAll()
        objWebServiceManager.requestGet(strURL: WsUrl.CardList, params: [:], queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            let message = response["message"] as? String ?? ""

            let status = response["status"] as? String
            if status == "success"{
                self.arrCardList.removeAll()
                let data = response["data"] as? [String:Any] ?? [:]
                let dataFound = data["data_found"] as? Int ?? 0
                SVProgressHUD.dismiss()
                if dataFound == 0{
                    if self.arrCardList.count == 0 {
                        self.redirectAddCard()
                        self.tblView.isHidden = true
                    }
//                    self.viewNoRecord.isHidden = false
                }else{
                    let cardDetail = data["card_list"] as? [[String:Any]]
                    for obj in cardDetail ?? [[:]]{
                        let modelObject = CardListModel.init(dict: obj)
                        self.arrCardList.append(modelObject)
                    }
                    self.viewNoRecord.isHidden = true
                    self.tblView.isHidden = false
                    isnocard = false
                }
                self.tblView.reloadData()
                print(self.arrCardList.count)
            } else{
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
    
    func ShowAlertForCardDelete(cardID:String,IndexData:Int){
        let alertController = UIAlertController(title: kAlertTitle, message: "Are you sure you want to delete card?", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Confirm", style: .default) { (action:UIAlertAction!) in
            self.view.endEditing(true)
            self.callWSForDeleteCard(cardID: cardID, IndexData: IndexData)
        }
        let CancelAction = UIAlertAction(title: "Cancel", style: .default) { (action:UIAlertAction!) in
            self.view.endEditing(true)
        }
        alertController.addAction(CancelAction)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    func callWSForDeleteCard(cardID:String,IndexData:Int){
        SVProgressHUD.show()
        let param = [WsParam.stripeCardId:cardID]
        print(cardID)
        
        objWebServiceManager.uploadMultipartDataDelete(strURL: WsUrl.DeleteCard+String(cardID), params: param, showIndicator: false, imageData: nil, fileName: "", mimeType: "", success: { (response) in
            print(response)
            SVProgressHUD.dismiss()
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
            if status == "success"{
                SVProgressHUD.dismiss()
                self.arrCardList.remove(at: IndexData)
                self.tblView.reloadData()
            } else{
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
        }
    }
    func callWSForMakeDefaultCard(cardID:String,normalcardId:String){
        SVProgressHUD.show()
        print(cardID)
        // let param = ["id":cardID]
        objWebServiceManager.requestPatch(strURL: WsUrl.MakeCardDefault+String(cardID), params: [:], strCustomValidation: "", success: { (response) in
            print(response)
            let status = response["status"] as? String
            let message = response["message"] as? String ?? ""
            if status == "success"{
                self.callWSForGetCardList(isFromMakeDefault: true)
                self.tblView.reloadData()
            } else{
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
        }
    }
    
    func redirectAddCard(){
        isnocard = true 
        isCommingFrom = true

        let storyBoard = UIStoryboard(name: "Tanentside", bundle:nil)
                           let AddPropertyVC = storyBoard.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
                           self.navigationController?.pushViewController(AddPropertyVC, animated: false)
        
    }
    
}
