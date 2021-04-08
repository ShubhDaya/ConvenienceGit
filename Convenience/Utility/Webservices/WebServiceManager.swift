//
//  WebServiceClass.swift
//  Link
//
//  Created by MINDIII on 10/3/17.
//  Copyright © 2017 MINDIII. All rights reserved.

import UIKit
import Alamofire
import SVProgressHUD

//let stripeKey = "Bearer sk_test_pXfonFNmJUWOcoMit0S71cSB00XK9umyVW"

var strAuthToken : String = ""
let objWebServiceManager = WebServiceManager.sharedObject()

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

class WebServiceManager: NSObject {
    
    //MARK: - Shared object
    fileprivate var window = UIApplication.shared.keyWindow
    
    private static var sharedNetworkManager: WebServiceManager = {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        SVProgressHUD.setRingThickness(3)
        SVProgressHUD.setRingRadius(22)
        let networkManager = WebServiceManager()
        return networkManager
    }()
    
    // MARK: - Accessors
    class func sharedObject() -> WebServiceManager {
        return sharedNetworkManager
    }
    
    private let manager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    func isNetworkAvailable() -> Bool{
        if !NetworkReachabilityManager()!.isReachable{
            return false
        }else{
            return true
        }
    }
    
}

//MARK:- Webservice methods
extension WebServiceManager{
    
    //MARK: - Request Post method ----
    public func requestPost(strURL:String,queryParams : [String:Any], params : [String:Any], strCustomValidation:String , showIndicator:Bool, success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void) {
        if !NetworkReachabilityManager()!.isReachable{
                 let app = UIApplication.shared.delegate as? AppDelegate
                      let window = app?.window
                        objAlert.showAlertVc(title: NoNetwork, controller: window!)
                        SVProgressHUD.dismiss()

            DispatchQueue.main.async {
                   ()
            }
            return
        }
        strAuthToken = ""
        if let token = UserDefaults.standard.string(forKey:UserDefaults.KeysDefault.kAuthToken){
            strAuthToken = "Bearer" + " " + token
        }
        
        var strUdidi = ""
        if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.Keys.strVenderId) {
            print("defaults VenderID: \(MyUniqueId)")
            strUdidi = MyUniqueId
        }
        
        let currentTimeZone = getCurrentTimeZone()
        
        let header: HTTPHeaders = [
            "Authorization": strAuthToken,
            "Accept": "application/json",
            WsHeader.deviceId:strUdidi,
            WsHeader.deviceType:"1",
            WsHeader.deviceTimeZone: currentTimeZone
        ]
        
        var StrCompleteUrl = ""
        if strCustomValidation ==  WsParamsType.PathVariable
        {
            let pathvariable = queryParams.PathString
            StrCompleteUrl  = "\(strURL)"   + (pathvariable )
            print("pathvariablepathvariable.....\(pathvariable )")
            
        }
        else if  strCustomValidation ==  WsParamsType.QueryParams
        {
            StrCompleteUrl = self.queryString(strURL, params: queryParams ) ?? ""
        }
        else
        {
            StrCompleteUrl = strURL
        }
        
        Alamofire.upload(multipartFormData:{ multipartFormData in
            for (key, value) in params {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }},
                         usingThreshold:UInt64.init(),
                         to:StrCompleteUrl,
                         method:.post,
                         headers: header,
                         
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    
                                    do {
                                        let dictionary = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                                        success(dictionary as! Dictionary<String, Any>)
                                    }catch{
                                        
                                        
                                    }
                                    
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                                SVProgressHUD.dismiss()
                                failure(encodingError)
                            }

        })
    }

    
    
    func queryString(_ value: String, params: [String: Any]) -> String? {
        var components = URLComponents(string: value)
        components?.queryItems = params.map { element in URLQueryItem(name: element.key, value: element.value as? String ) }
        
        return components?.url?.absoluteString
    }
    

    //MARK: - Request Put method ----
    public func requestPut(strURL:String,queryParams : [String:Any], params : [String:Any]?,strCustomValidation:String,showIndicator:Bool, success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void ) {
    if !NetworkReachabilityManager()!.isReachable{
    let app = UIApplication.shared.delegate as? AppDelegate
    let window = app?.window
    objAlert.showAlertVc(title: NoNetwork, controller: window!)
    DispatchQueue.main.async {
    SVProgressHUD.dismiss()
    }
    return
    }

    strAuthToken = ""

    if let token = UserDefaults.standard.string(forKey:UserDefaults.KeysDefault.kAuthToken){
    strAuthToken = "Bearer " + token
    }
    var strUdidi = ""
    if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.Keys.strVenderId) {
    print("defaults VenderID: \(MyUniqueId)")
    strUdidi = MyUniqueId
    }
    let currentTimeZone = getCurrentTimeZone()
    let header: HTTPHeaders = ["Authorization":strAuthToken,
    "Accept": "application/json",

    WsHeader.deviceId:strUdidi,
    WsHeader.deviceType:"2",
    WsHeader.deviceTimeZone: currentTimeZone]

    var StrCompleteUrl = ""
    if strCustomValidation == WsParamsType.PathVariable
    {
    let pathvariable = queryParams.PathString
    StrCompleteUrl = "\(strURL)" + (pathvariable )
    print("pathvariablepathvariable.....\(pathvariable )")

    }
    else if strCustomValidation == WsParamsType.QueryParams
    {
    StrCompleteUrl = self.queryString(strURL, params: queryParams ) ?? ""
    }
    else
    {
    StrCompleteUrl = strURL
    }


    print(header)
    print(StrCompleteUrl)
    Alamofire.request(StrCompleteUrl, method: .put, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON{ responseObject in
    // if !objAppShareData.isPutApiFromUpload{
    // self.StopIndicator()
    // }
    print(responseObject )
    if responseObject.result.isSuccess {

    do {
    let dictionary = try JSONSerialization.jsonObject(with: responseObject.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
    success(dictionary as! Dictionary<String, Any>)
    // print(dictionary)
    }catch{

    }
    }
    if responseObject.result.isFailure {
    //SVProgressHUD.dismiss()
    // self.StopIndicator()
    let error : Error = responseObject.result.error!
    failure(error)

    }
    }
    }
    
    //MARK: - Request get method ----
    public func requestGet(strURL:String, params : [String : AnyObject]?,queryParams : [String:Any], strCustomValidation:String , success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void ) {
      if !NetworkReachabilityManager()!.isReachable{
                       let app = UIApplication.shared.delegate as? AppDelegate
                            let window = app?.window
                              objAlert.showAlertVc(title: NoNetwork, controller: window!)
                              SVProgressHUD.dismiss()

                  DispatchQueue.main.async {
                         ()
                  }
                  return
              }
        
        strAuthToken = ""
        if let token = UserDefaults.standard.string(forKey:UserDefaults.KeysDefault.kAuthToken){
            strAuthToken = "Bearer" + " " + token
        }
        
        let currentTimeZone = getCurrentTimeZone()
        
        var strUdidi = ""
        if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.Keys.strVenderId) {
            print("defaults VenderID: \(MyUniqueId)")
            strUdidi = MyUniqueId
        }
        
        let headers: HTTPHeaders = [
            "Authorization": strAuthToken ,
            "Accept": "application/json",
            WsHeader.deviceId:strUdidi,
            WsHeader.deviceType:"1",
            WsHeader.deviceTimeZone: currentTimeZone
        ]
        
        print("url....\(strURL)")
        print("header....\(headers)")
        //
        var urlString = strURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        var StrCompleteUrl = ""
        if strCustomValidation ==  WsParamsType.PathVariable{
            let pathvariable = queryParams.PathString
            StrCompleteUrl  = "\(urlString)"   + (pathvariable)
            print("pathvariablepathvariable.....\(pathvariable)")
            
        }
        else if  strCustomValidation ==  WsParamsType.QueryParams{
            StrCompleteUrl = self.queryString(urlString, params: queryParams ?? [:]) ?? ""
        }
        else{
            StrCompleteUrl = urlString
        }
        Alamofire.request(StrCompleteUrl, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { responseObject in
            
            //self.StopIndicator()
            
            if responseObject.result.isSuccess {
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: responseObject.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    success(dictionary as! Dictionary<String, Any>)
                    print(dictionary)
                }catch{
                    
                    let error : Error = responseObject.result.error!
                    failure(error)
                    let str = String(decoding: responseObject.data!, as: UTF8.self)
                    print("PHP ERROR : \(str)")
                }
            }
            if responseObject.result.isFailure {
                //self.StopIndicator()
                let error : Error = responseObject.result.error!
                failure(error)
                
                let str = String(decoding: responseObject.data!, as: UTF8.self)
                print("PHP ERROR : \(str)")
            }
        }
    }
    
    public func uploadMultipartData(strURL:String, params :  [String:Any]?,queryParams : [String:Any],strCustomValidation:String ,showIndicator:Bool, imageData:Data?, fileName:String?, mimeType:String?, success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void){
        
      if !NetworkReachabilityManager()!.isReachable{
                let app = UIApplication.shared.delegate as? AppDelegate
                let window = app?.window
                objAlert.showAlertVc(title: NoNetwork, controller: window!)
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
                return
            }
            
        strAuthToken = ""
        if let token = UserDefaults.standard.string(forKey:UserDefaults.KeysDefault.kAuthToken){
            strAuthToken = "Bearer" +  " " + token
        }
        
        var strUdidi = ""
        if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.Keys.strVenderId) {
            print("defaults VenderID: \(MyUniqueId)")
            strUdidi = MyUniqueId
        }
        print(strURL)
        let currentTimeZone = getCurrentTimeZone()
        let header: HTTPHeaders = [
            "Authorization": strAuthToken,
            "Accept": "application/json",
            WsHeader.deviceId:strUdidi,
            WsHeader.deviceType:"1",
            WsHeader.deviceTimeZone: currentTimeZone
        ]
        var StrCompleteUrl = ""
        if strCustomValidation ==  WsParamsType.PathVariable{
            let pathvariable = queryParams.PathString
            StrCompleteUrl  = "\(strURL)"   + (pathvariable)
            print("pathvariablepathvariable.....\(pathvariable)")
            
        }
        else if  strCustomValidation ==  WsParamsType.QueryParams{
            StrCompleteUrl = self.queryString(strURL, params: queryParams ?? [:]) ?? ""
        }
        else{
            StrCompleteUrl = strURL
        }
        
        Alamofire.upload(multipartFormData:{ multipartFormData in
            if let data = imageData {
                multipartFormData.append(data,
                                         withName:fileName!,
                                         fileName: "file.jpeg",
                                         mimeType:mimeType!)
            }
            
            for (key, value) in params ?? [:] {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        },
                         usingThreshold:UInt64.init(),
                         to:StrCompleteUrl,
                         method:.post,
                         headers: header,
                         
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    
                                    do {
                                        let dictionary = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                                        success(dictionary as! Dictionary<String, Any>)
                                    }catch{
                                    }
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                               // SVProgressHUD.dismiss()

                                failure(encodingError)
                            }
        })
    }
    
    
    //MARK: - Request Delete method ----
    public func requestDelete(strURL:String, params : [String : AnyObject]?,queryParams : [String:Any], strCustomValidation:String , success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void ) {
       if !NetworkReachabilityManager()!.isReachable{
                let app = UIApplication.shared.delegate as? AppDelegate
                let window = app?.window
                objAlert.showAlertVc(title: NoNetwork, controller: window!)
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
                return
            }
            
        
        strAuthToken = ""
        
        
        if let token = UserDefaults.standard.string(forKey:UserDefaults.KeysDefault.kAuthToken){
            print(token)
            strAuthToken = "Bearer" + " " + token
        }
        
        let currentTimeZone = getCurrentTimeZone()
        
        var strUdidi = ""
        if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.Keys.strVenderId) {
            print("defaults VenderID: \(MyUniqueId)")
            strUdidi = MyUniqueId
        }
        
        let headers: HTTPHeaders = [
            "Authorization": strAuthToken ,
            "Accept": "application/json",
            WsHeader.deviceId:strUdidi,
            WsHeader.deviceType:"1",
            WsHeader.deviceTimeZone: currentTimeZone
        ]
        
        var StrCompleteUrl = ""
        
        if strCustomValidation ==  WsParamsType.PathVariable{
            let pathvariable = queryParams.PathString
            StrCompleteUrl  = "\(strURL)"   + (pathvariable)
            print("pathvariablepathvariable.....\(pathvariable)")
            
        }
        else if  strCustomValidation ==  WsParamsType.QueryParams{
            StrCompleteUrl = self.queryString(strURL, params: queryParams ) ?? ""
        }
        else{
            StrCompleteUrl = strURL
        }
        
        print("url....\(strURL)")
        print("header....\(headers)")
        Alamofire.request(StrCompleteUrl, method: .delete, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { responseObject in
            
            if responseObject.result.isSuccess {
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: responseObject.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    success(dictionary as! Dictionary<String, Any>)
                    print(dictionary)
                }catch{
                    
                    let error : Error = responseObject.result.error!
                    failure(error)
                    let str = String(decoding: responseObject.data!, as: UTF8.self)
                    print("PHP ERROR : \(str)")
                }
            }
            if responseObject.result.isFailure {
               // SVProgressHUD.dismiss()
                let error : Error = responseObject.result.error!
                failure(error)
                
                let str = String(decoding: responseObject.data!, as: UTF8.self)
                print("PHP ERROR : \(str)")
            }
        }
    }
    
    public func uploadMultipartDataDelete(strURL:String, params :  [String:Any]?,showIndicator:Bool, imageData:Data?, fileName:String?, mimeType:String?, success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void){
         
         if !NetworkReachabilityManager()!.isReachable{
             let app = UIApplication.shared.delegate as? AppDelegate
             let window = app?.window
             objAlert.showAlertVc(title: NoNetwork, controller: window!)
             DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
            }
             return
         }
         ///////
                strAuthToken = ""
         
         if let token = UserDefaults.standard.string(forKey:UserDefaults.KeysDefault.kAuthToken){
             print(token)
             strAuthToken = "Bearer" + " " + token
         }
         
         let currentTimeZone = getCurrentTimeZone()
         
         var strUdidi = ""
         if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.Keys.strVenderId) {
             print("defaults VenderID: \(MyUniqueId)")
             strUdidi = MyUniqueId
         }
         
         let headers: HTTPHeaders = [
             "Authorization": strAuthToken ,
             "Accept": "application/json",
             WsHeader.deviceId:strUdidi,
             WsHeader.deviceType:"1",
             WsHeader.deviceTimeZone: currentTimeZone
         ]

        print("url....\(strURL)")

        
         Alamofire.upload(multipartFormData:{ multipartFormData in
             if let data = imageData {
                 multipartFormData.append(data,
                                          withName:fileName!,
                                          fileName: "file.jpeg",
                                          mimeType:mimeType!)
             }
             
             for (key, value) in params ?? [:] {
                 multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
             }
             
         },
                          usingThreshold:UInt64.init(),
                          to:strURL,
                          method:.delete,
                          headers: headers,
                          
                          encodingCompletion: { encodingResult in
                             switch encodingResult {
                             case .success(let upload, _, _):
                                 upload.responseJSON { response in
                                     
                                     do {
                                         let dictionary = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                                         success(dictionary as! Dictionary<String, Any>)
                                     }catch{
                                     }
                                     
                                 }
                             case .failure(let encodingError):
                               // SVProgressHUD.dismiss()

                                 print(encodingError)
                                 failure(encodingError)
                             }
         })
     }
    
    //MARK:- Show/hide Indicator
    func showIndicator(){
        
        SVProgressHUD.setOffsetFromCenter(.init(horizontal: (UIApplication.shared.keyWindow?.center.x)!, vertical: (UIApplication.shared.keyWindow?.center.y)!))
        SVProgressHUD.show()
    }
    
    func hideIndicator(){
        SVProgressHUD.dismiss()
    }
    
    //get current timezone
    func getCurrentTimeZone() -> String{
        return TimeZone.current.identifier
    }
    
    
    
    // MARK: - Request Patch method ----
    
    public func requestPatch(strURL:String, params : [String:Any]?, strCustomValidation:String , success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void ) {
        if !NetworkReachabilityManager()!.isReachable{
                let app = UIApplication.shared.delegate as? AppDelegate
                let window = app?.window
                objAlert.showAlertVc(title: NoNetwork, controller: window!)
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
                return
            }
            
        
        strAuthToken = ""
        
        if let token = UserDefaults.standard.string(forKey:UserDefaults.KeysDefault.kAuthToken){
            strAuthToken = "Bearer" + " " + token
        }
        
        //  let currentTimeZone = getCurrentTimeZone()
        
        var strUdidi = ""
        if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.Keys.strVenderId) {
            print("defaults VenderID: \(MyUniqueId)")
            strUdidi = MyUniqueId
        }
        let currentTimeZone = getCurrentTimeZone()
        
        
        let headers: HTTPHeaders = [
            "Authorization": strAuthToken ,
            "Accept": "application/json",
            WsHeader.deviceId:strUdidi,
            WsHeader.deviceType:"1",
            WsHeader.deviceTimeZone: currentTimeZone
        ]
        
        print("url....\(strURL)")
        print("header....\(headers)")
        Alamofire.request(strURL, method: .patch, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { responseObject in
            
            //            self.StopIndicator()
            
            if responseObject.result.isSuccess {
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: responseObject.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    if let errorCode = dictionary["status_code"] as? String{
                        if errorCode == "400"{
                            let strErrorType = dictionary["error_type"] as? String
                            if strErrorType == "USER_NOT_FOUND" || strErrorType == "INVALID_TOKEN" || strErrorType == "SESSION_EXPIRED"{
                                SVProgressHUD.dismiss()
                                objAlert.showSessionFailAlert()
                                return
                            }
                        }
                    }else if let errorCode = dictionary["status_code"] as? Int{
                        if errorCode == 400{
                            let strErrorType = dictionary["error_type"] as? String
                            if strErrorType == "USER_NOT_FOUND" || strErrorType == "INVALID_TOKEN" || strErrorType == "SESSION_EXPIRED"{
                                SVProgressHUD.dismiss()
                                objAlert.showSessionFailAlert()
                                return
                            }
                        }
                    }
                    success(dictionary as! Dictionary<String, Any>)
                    print(dictionary)
                    let status = dictionary["status"] as? String
                    if status == "error"
                    {
                        let error = dictionary["error_type"] as? String
                        
                        if error == "SESSION_EXPIRED"
                        {
                            //                            self.setRootSessionExpired()
                            //                            self.StopIndicator()
                        }
                    }
                    
                }catch{
                    
                    let error : Error = responseObject.result.error!
                    failure(error)
                    let str = String(decoding: responseObject.data!, as: UTF8.self)
                    print("PHP ERROR : \(str)")
                }
            }
            if responseObject.result.isFailure {
                //                self.StopIndicator()
                let error : Error = responseObject.result.error!
                failure(error)
                
                let str = String(decoding: responseObject.data!, as: UTF8.self)
                print("PHP ERROR : \(str)")
            }
        }
    }
    
    //MARK: - Request Not Form Data Patch ---
    
    public func requestNotMultipartPatch(strURL:String, params : [String : Any]?, strCustomValidation:String , success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void ) {
        if !NetworkReachabilityManager()!.isReachable{
                let app = UIApplication.shared.delegate as? AppDelegate
                let window = app?.window
                objAlert.showAlertVc(title: NoNetwork, controller: window!)
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
                return
            }
            
        
        strAuthToken = ""
        if let token = UserDefaults.standard.string(forKey:UserDefaults.KeysDefault.kAuthToken){
            strAuthToken = "Bearer" + " " + token
        }
        
        let currentTimeZone = getCurrentTimeZone()
        
        var strUdidi = ""
        if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.Keys.strVenderId) {
            print("defaults VenderID: \(MyUniqueId)")
            strUdidi = MyUniqueId
        }
        
        let headers: HTTPHeaders = [
            "Authorization": strAuthToken ,
            "Accept": "application/json",
            WsHeader.deviceId:strUdidi,
            WsHeader.deviceType:"1",
            WsHeader.deviceTimeZone: currentTimeZone
        ]
        
        print("url....\(strURL)")
        print("header....\(headers)")
        Alamofire.request(strURL, method: .patch, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { responseObject in
            
            //self.StopIndicator()
            
            if responseObject.result.isSuccess {
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: responseObject.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    if let errorCode = dictionary["status_code"] as? String{
                        if errorCode == "400"{
                            let strErrorType = dictionary["error_type"] as? String
                            if strErrorType == "USER_NOT_FOUND" || strErrorType == "INVALID_TOKEN" || strErrorType == "SESSION_EXPIRED"{
                                objAlert.showSessionFailAlert()
                                return
                            }
                        }
                    }else if let errorCode = dictionary["status_code"] as? Int{
                        if errorCode == 400{
                            let strErrorType = dictionary["error_type"] as? String
                            if strErrorType == "USER_NOT_FOUND" || strErrorType == "INVALID_TOKEN" || strErrorType == "SESSION_EXPIRED"{
                                SVProgressHUD.dismiss()
                                objAlert.showSessionFailAlert()
                                return
                            }
                        }
                    }
                    success(dictionary as! Dictionary<String, Any>)
                    print(dictionary)
                }catch{
                    
                    let error : Error = responseObject.result.error!
                    failure(error)
                    let str = String(decoding: responseObject.data!, as: UTF8.self)
                    print("PHP ERROR : \(str)")
                }
            }
            if responseObject.result.isFailure {
                //self.StopIndicator()
                let error : Error = responseObject.result.error!
                failure(error)
                
                let str = String(decoding: responseObject.data!, as: UTF8.self)
                print("PHP ERROR : \(str)")
            }
        }
    }
}

//MARK:-  stripe payment method
//MARK:- stripe payment method
extension WebServiceManager{
    public func requestAddCardOnStripe(strURL:String, params :[String : Any]?, success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void ) {
        if !NetworkReachabilityManager()!.isReachable{
            let app = UIApplication.shared.delegate as? AppDelegate
            let window = app?.window
            objAlert.showAlertVc(title: NoNetwork, controller: window!)
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
            return
        }
        
        let url = strURL
        print("url = \(url)")
        
        let headers = ["Authorization" : stripeKey,"Content-Type":"application/x-www-form-urlencoded"]
        
        
        Alamofire.request(url, method: .post, parameters: params, headers: headers).responseJSON { responseObject in
            
            print(responseObject)
            if responseObject.result.isSuccess {
                do {
                    SVProgressHUD.show(withStatus: "Please wait..")
                    let dictionary = try JSONSerialization.jsonObject(with: responseObject.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    if let errorCode = dictionary["status_code"] as? String{
                        if errorCode == "400"{
                            let strErrorType = dictionary["error_type"] as? String
                            if strErrorType == "USER_NOT_FOUND" || strErrorType == "INVALID_TOKEN" || strErrorType == "SESSION_EXPIRED"{
                                SVProgressHUD.dismiss()
                                objAlert.showSessionFailAlert()
                                return
                            }
                        }
                    }else if let errorCode = dictionary["status_code"] as? Int{
                        if errorCode == 400{
                            let strErrorType = dictionary["error_type"] as? String
                            if strErrorType == "USER_NOT_FOUND" || strErrorType == "INVALID_TOKEN" || strErrorType == "SESSION_EXPIRED"{
                                SVProgressHUD.dismiss()
                                objAlert.showSessionFailAlert()
                                return
                            }
                        }
                    }
                    success(dictionary as! Dictionary<String, Any>)
                    // print(dictionary)
                    SVProgressHUD.dismiss()
                }catch{
                    SVProgressHUD.dismiss()
                    let error : Error = responseObject.result.error!
                    failure(error)
                }
            }
            if responseObject.result.isFailure {
                SVProgressHUD.dismiss()
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    // Delete card
    public func requestDeleteCardFromStripe(strURL:String, params :[String : Any]?, success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void ) {
        if !NetworkReachabilityManager()!.isReachable{
            let app = UIApplication.shared.delegate as? AppDelegate
            let window = app?.window
            objAlert.showAlertVc(title: NoNetwork, controller: window!)
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
            return
        }
        
        let url = strURL
        print("url = \(url)")
        
        let headers = ["Authorization" : stripeKey,"Content-Type":"application/x-www-form-urlencoded"]
        
        Alamofire.request(url, method: .delete, parameters: params, headers: headers).responseJSON { responseObject in
            
            print(responseObject)
            if responseObject.result.isSuccess {
                do {
                    SVProgressHUD.show(withStatus: "Please wait..")
                    let dictionary = try JSONSerialization.jsonObject(with: responseObject.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    if let errorCode = dictionary["status_code"] as? String{
                        if errorCode == "400"{
                            let strErrorType = dictionary["error_type"] as? String
                            if strErrorType == "USER_NOT_FOUND" || strErrorType == "INVALID_TOKEN" || strErrorType == "SESSION_EXPIRED"{
                                SVProgressHUD.dismiss()
                                objAlert.showSessionFailAlert()
                                return
                            }
                        }
                    }else if let errorCode = dictionary["status_code"] as? Int{
                        if errorCode == 400{
                            let strErrorType = dictionary["error_type"] as? String
                            if strErrorType == "USER_NOT_FOUND" || strErrorType == "INVALID_TOKEN" || strErrorType == "SESSION_EXPIRED"{
                                SVProgressHUD.dismiss()
                                objAlert.showSessionFailAlert()
                                return
                            }
                        }
                    }
                    success(dictionary as! Dictionary<String, Any>)
                    // print(dictionary)
                    SVProgressHUD.dismiss()
                }catch{
                    SVProgressHUD.dismiss()
                    let error : Error = responseObject.result.error!
                    failure(error)
                }
            }
            if responseObject.result.isFailure {
                SVProgressHUD.dismiss()
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    // Get all card List
    public func requestGetCardsFromStripe(strURL:String, params :[String : Any]?, success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void ) {
        if !NetworkReachabilityManager()!.isReachable{
            let app = UIApplication.shared.delegate as? AppDelegate
            let window = app?.window
            objAlert.showAlertVc(title: NoNetwork, controller: window!)
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
            return
        }
        
        let url = strURL
        print("url = \(url)")
        
        let headers = ["Authorization" : stripeKey,"Content-Type":"application/x-www-form-urlencoded"]
        
        Alamofire.request(url, method: .get, parameters: params, headers: headers).responseJSON { responseObject in
            
            // print(responseObject)
            if responseObject.result.isSuccess {
                do {
                    SVProgressHUD.show(withStatus: "Please wait..")
                    let dictionary = try JSONSerialization.jsonObject(with: responseObject.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    if let errorCode = dictionary["status_code"] as? String{
                        if errorCode == "400"{
                            let strErrorType = dictionary["error_type"] as? String
                            if strErrorType == "USER_NOT_FOUND" || strErrorType == "INVALID_TOKEN" || strErrorType == "SESSION_EXPIRED"{
                                SVProgressHUD.dismiss()
                                objAlert.showSessionFailAlert()
                                return
                            }
                        }
                    }else if let errorCode = dictionary["status_code"] as? Int{
                        if errorCode == 400{
                            let strErrorType = dictionary["error_type"] as? String
                            if strErrorType == "USER_NOT_FOUND" || strErrorType == "INVALID_TOKEN" || strErrorType == "SESSION_EXPIRED"{
                                SVProgressHUD.dismiss()
                                objAlert.showSessionFailAlert()
                                return
                            }
                        }
                    }
                    success(dictionary as! Dictionary<String, Any>)
                    // print(dictionary)
                    SVProgressHUD.dismiss()
                }catch{
                    SVProgressHUD.dismiss()
                    let error : Error = responseObject.result.error!
                    failure(error)
                }
            }
            if responseObject.result.isFailure {
                SVProgressHUD.dismiss()
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
}




extension Dictionary {
    var queryString: String {
        var output: String = ""
        for (key,value) in self {
            output += "\(key)=\(value)&"
        }
        output = String(output.dropLast())
        return output
    }
    
    var PathString: String {
        var output: String = ""
        for (_,value) in self {
            output += "\(value)"
        }
        output = String(output)
        return output
    }
    
}
