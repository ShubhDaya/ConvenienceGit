//
//  AlertVc.swift
//  Hoggz
//
//  Created by MACBOOK-SHUBHAM V on 27/12/19.
//  Copyright © 2019 MACBOOK-SHUBHAM V. All rights reserved.
//
//


import UIKit
var objAlert:AlertClass = AlertClass()

class AlertClass: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
    func showAlert(message: String, title: String = "", controller: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Customization alert view  below comment code- for border color ,styles
        
//        let subview = alertController.view.subviews.first! as UIView
//        let alertContentView = subview.subviews.first! as UIView
//        alertContentView.layer.cornerRadius = 10
//        alertContentView.alpha = 1
//        alertContentView.layer.borderWidth = 1
//
//   alertContentView.layer.borderColor = UIColor(named: "AppThimColor")?.cgColor
//      alertController.view.tintColor = UIColor(named: "AppThimColor")
        let OKAction = UIAlertAction(title: NSLocalizedString("OK", tableName: nil, comment: ""), style: .default, handler: nil)
        alertController.addAction(OKAction)
        controller.present(alertController, animated: true, completion: nil)
        view.endEditing(true)
    }
    
   // Alert call back function
    func showAlertCallBack(alertLeftBtn:String, alertRightBtn:String,  title: String, message: String ,controller: UIViewController, callback: @escaping (_ isAlertRightBtn:Bool) -> ()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
         alert.addAction(UIAlertAction(title: alertRightBtn, style: .default, handler: {
           alertAction in
            callback(true)
            
         }))
        alert.addAction(UIAlertAction(title:alertLeftBtn, style: .cancel, handler: {
          alertAction in
            callback(false)

        
        }))
        
         controller.present(alert, animated: true, completion: nil)
       }

    func showAlertCallBackother(alertLeftBtn:String, alertRightBtn:String,  title: String, message: String ,controller: UIViewController, callback: @escaping (_ isAlertRightBtn:Bool) -> () , callbackCancel:@escaping()  -> ()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
         alert.addAction(UIAlertAction(title: alertRightBtn, style: .default, handler: {
           alertAction in
            callback(true)
         }))
        alert.addAction(UIAlertAction(title:alertLeftBtn, style: .cancel, handler: {
          alertAction in
            
           callbackCancel()
        
        }))
        
         controller.present(alert, animated: true, completion: nil)
       }

    
    
    
    func showAlertCallBackOk(alertLeftBtn:String,  title: String, message: String ,controller: UIViewController , callbackCancel:@escaping()  -> ()) {
           
           let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
           
           alert.addAction(UIAlertAction(title:alertLeftBtn, style: .cancel, handler: {
             alertAction in
               
              callbackCancel()
           
           }))
           
            controller.present(alert, animated: true, completion: nil)
          }

    
  // For alert show on UIWindow if you have no Viewcontroller then show this alert.
    func showAlertVc(message: String = "", title: String , controller: UIWindow) {
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let subView = alertController.view.subviews.first!
            let alertContentView = subView.subviews.first!
            alertContentView.backgroundColor = UIColor.gray
            alertContentView.layer.cornerRadius = 20
            
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            
            
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        })
    }
    
   // Session Expired Alert Show...
    func showSessionFailAlert() {
        let alert = UIAlertController(title: "Session Expired", message: "Please Login Again", preferredStyle: .alert)
        let yesButton = UIAlertAction(title: "LOGOUT", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            //objAppDelegate.logOut()
        })
        alert.addAction(yesButton)
        present(alert, animated: true) {() -> Void in }
    }
    
    
    func showAlert(message: String = "", title: String , controller: UIWindow) {
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let subView = alertController.view.subviews.first!
            let alertContentView = subView.subviews.first!
            alertContentView.backgroundColor = UIColor.gray
            alertContentView.layer.cornerRadius = 20
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        })
    }

}





