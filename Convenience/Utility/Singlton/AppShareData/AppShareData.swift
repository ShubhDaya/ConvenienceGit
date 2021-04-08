//
//  File.swift
//  Hoggz
//
//  Created by MACBOOK-SHUBHAM V on 26/12/19.
//  Copyright © 2019 MACBOOK-SHUBHAM V. All rights reserved.
//
//
//  File.swift
//  Hoggz
//
//  Created by MACBOOK-SHUBHAM V on 26/12/19.
//  Copyright © 2019 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

let objAppSharedata = AppShareData.sharedObject()

class AppShareData {
//MARK: - Shared object
private static var sharedManager: AppShareData = {
let manager = AppShareData()
  

return manager
}()
// MARK: - Accessors
class func sharedObject() -> AppShareData {
return sharedManager
}
//var objNonUserType = "0"
    var UserDetail = userDetailModel(dict: [:])
    var arrOwnerProperty = PropertyDetail(dict: [:])
    var user_type = ""
    var onboardingPropertyAdded_Ow = false
    var strLat = ""
    var strLong = ""
    var str = ""
    var strFirebaseToken = ""
    var strAlertStatuss = -1
    var isFromNotification = false
    var strNotificationType = ""
    var notificationDict : [String:Any] = [:]
    var selecteddata = [OwnerPropertyModel]()
    
    var strPolicy = ""
    var strTermsCondition = ""

      // MARK: - saveUpdateUserInfoFromAppshareData ---------------------
      func SaveUpdateUserInfoFromAppshareData(userDetail:[String:Any])
      {
          let outputDict = self.removeNSNull(from:userDetail)
          UserDefaults.standard.set(outputDict, forKey: UserDefaults.Keys.userInfo)
          
      }
      
      // MARK: - FetchUserInfoFromAppshareData -------------------------
      func fetchUserInfoFromAppshareData()
      {
          if let userDic = UserDefaults.standard.value(forKey:  UserDefaults.Keys.userInfo) as? [String : Any]{
            self.UserDetail = userDetailModel.init(dict: userDic)
    
          }
      }
    
    func removeNSNull(from dict: [String: Any]) -> [String: Any] {
         var mutableDict = dict
         let keysWithEmptString = dict.filter { $0.1 is NSNull }.map { $0.0 }
         for key in keysWithEmptString {
             mutableDict[key] = ""
             print(key)
         }
         return mutableDict
     }
    
    
    func resetDefaultsAlluserInfo()
    {
    let defaults = UserDefaults.standard
    let myVenderId = defaults.string(forKey:UserDefaults.Keys.strVenderId)
        let email = defaults.string(forKey: UserDefaults.KeysDefault.strEmail)
        let password = defaults.string(forKey: UserDefaults.KeysDefault.strPassword)
        let isRemember = defaults.string(forKey: UserDefaults.KeysDefault.isRemember)


    let dictionary = defaults.dictionaryRepresentation()
    dictionary.keys.forEach { key in
    defaults.removeObject(forKey: key)
    }

    if let bundleID = Bundle.main.bundleIdentifier {
    UserDefaults.standard.removePersistentDomain(forName: bundleID)
    }

    defaults.set(myVenderId ?? "", forKey:UserDefaults.Keys.strVenderId)
    defaults.set(email ?? "", forKey:UserDefaults.KeysDefault.strEmail)
    defaults.set(password ?? "", forKey:UserDefaults.KeysDefault.strPassword)
    defaults.set(isRemember ?? "", forKey:UserDefaults.KeysDefault.isRemember)

    UserDetail = userDetailModel(dict: [:])
    }
}

//MARK:- Logout Api
extension AppShareData {
    
    func callWebserviceForLogoutDelete(){
        objWebServiceManager.requestDelete(strURL: WsUrl.logout, params: nil, queryParams: [:], strCustomValidation: "", success:{response in
          
           let status = (response["status"] as? String)
        //   let message = (response["message"] as? String)
           if status == k_success{
            objAppSharedata.resetDefaultsAlluserInfo()
            
              objWebServiceManager.hideIndicator()
//               if #available(iOS 13.0, *) {
//                   objSceneDelegate.showLogInNavigation()
//               }else{
                  objAppSharedata.resetDefaultsAlluserInfo()

                   objAppDelegate.showLogInNavigation()
               //}
           }else{
                objWebServiceManager.hideIndicator()
//               if #available(iOS 13.0, *) {
//                   objSceneDelegate.showLogInNavigation()
//               }else{
                   objAppDelegate.showLogInNavigation()
               //}
            }
           }, failure: { (error) in
              print(error)
                objWebServiceManager.hideIndicator()
             // objAppShareData.showAlert(title: kAlertTitle, message: message ?? "", view: self)
           })
        
    }
    
    
//    func callWebserviceForLogout(){
//        objWebServiceManager.showIndicator()
//        objWebServiceManager.requestGet(strURL: WsUrl.logout, params: nil, queryParams: [:], strCustomValidation: "", success: {response in
//
//            let status = (response["status"] as? String)
//         //   let message = (response["message"] as? String)
//            if status == k_success{
//               objWebServiceManager.hideIndicator()
//                if #available(iOS 13.0, *) {
//                    objSceneDelegate.showLogInNavigation()
//                }else{
//                    objAppDelegate.showLogInNavigation()
//                }
//            }else{
//                 objWebServiceManager.hideIndicator()
//                if #available(iOS 13.0, *) {
//                    objSceneDelegate.showLogInNavigation()
//                }else{
//                    objAppDelegate.showLogInNavigation()
//                }
//             }
//            }, failure: { (error) in
//               print(error)
//                 objWebServiceManager.hideIndicator()
//              // objAppShareData.showAlert(title: kAlertTitle, message: message ?? "", view: self)
//            })
//    }
 
    
}














