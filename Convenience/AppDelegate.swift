//
//  AppDelegate.swift
//  Convenience
//  Created by MACBOOK-SHUBHAM V on 08/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
////
//  AppDelegate.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 08/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import IQKeyboardManagerSwift
import GooglePlaces
import GoogleMaps
import Stripe
import Foundation

let objAppDelegate = AppDelegate.AppDelegateObject()
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,CLLocationManagerDelegate, MessagingDelegate, UNUserNotificationCenterDelegate{
    var locationManager:CLLocationManager!
    var currentLocation: CLLocation!
    
    //MARK: - Shared object
    private static var AppDelegateManager: AppDelegate = {
        let manager = UIApplication.shared.delegate as! AppDelegate
        return manager
    }()
    // MARK: - Accessors
    class func AppDelegateObject() -> AppDelegate {
        return AppDelegateManager
    }
    var window: UIWindow?
    var navController: UINavigationController?
    var isFromNotification = false
    var notificationType = ""
    var notificationId = ""
    var kDeviceToken = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        objAppShareData.fetchUserInfoFromAppshareData()
        self.setupLocationManager()
        let center = UNUserNotificationCenter.current()
        center.delegate = self
       // Stripe.setDefaultPublishableKey("pk_test_coXpD8lSWMdC7LLucjeVjXke00dVJdt6qc")
        Stripe.setDefaultPublishableKey(PublishKey)
        //AIzaSyBj6W7zUHkvo3H74j7ihnpNxVMfxPsoBHk
        GMSServices.provideAPIKey("AIzaSyD9lAcTNov-rnhrGCp7F8K5XK9D8EyQsU4")
        GMSPlacesClient.provideAPIKey("AIzaSyD9lAcTNov-rnhrGCp7F8K5XK9D8EyQsU4")

        //GMSServices.provideAPIKey("AIzaSyBq6cU767SYwb8ycm8lBmqVrEFCOXELT7Q")
       // GMSPlacesClient.provideAPIKey("AIzaSyBq6cU767SYwb8ycm8lBmqVrEFCOXELT7Q")
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        let onboarding = UserDefaults.standard.bool(forKey: "onboard")
        let str = UserDefaults.standard.string(forKey: "onboarding")
        
        print(onboarding)
        print(str ?? "")
        let usertype = objAppShareData.UserDetail.strUserType
        let token = objAppShareData.UserDetail.strAuthToken ?? ""
        let onboardinstep = objAppSharedata.UserDetail.stronboarding_step
        print(onboardinstep)
        let customerstripe = UserDefaults.standard.value(forKey: UserDefaults.KeysDefault.KStripe_customer_id)
        let id = objAppShareData.UserDetail.strstripe_customer_id
        print(id)
       // print(customerstripe as Any)
        _ = UserDefaults.standard.value(forKey: UserDefaults.KeysDefault.strEmail)
        _ = UserDefaults.standard.value(forKey: UserDefaults.KeysDefault.strPassword)

        self.GetContent()
        let userID = UserDefaults.standard.value(forKey: UserDefaults.KeysDefault.kUserId)
        
        if token == nil{
            self.showLogInNavigation()
        }else if userID == nil{
            // for if user in tab bar we check user id
            if usertype == "owner" {
                self.showLogInNavigation()
            }else if usertype == "tenant" {
                self.showLogInNavigation()
            }
            else {
                self.showLogInNavigation()
            }
        }else {
            // if user id not == nil then we naviagte root tab bar
            if usertype == "owner"{
                showTabbarNavigation()
            }else if usertype == "tenant"{
                showTenantTabbarNavigation()
            }
        }
        let getudid = getUUID()
        let defaults = UserDefaults.standard
        defaults.set(getudid ?? "", forKey:UserDefaults.Keys.strVenderId)
        if let myString = defaults.string(forKey:UserDefaults.Keys.strVenderId) {
            print("defaults savedString: \(myString)")
        }
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        self.registerForRemoteNotification()
        
        return true
    }
        func registerForRemoteNotification() {
            // iOS 10 support
            if #available(iOS 10, *) {
                let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(options:authOptions){ (granted, error) in
                    self.registerCategory()
                    // For iOS 10 display notification (sent via APNS)
                    UNUserNotificationCenter.current().delegate = self
                    // For iOS 10 data message (sent via FCM)
                    Messaging.messaging().delegate = self
                }
                UIApplication.shared.registerForRemoteNotifications()
            }else {
                
                let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(settings)
                self.registerCategory()
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        func registerCategory() -> Void{
            let callNow = UNNotificationAction(identifier: "Open Action", title: "Open Action", options: [])
            //let clear = UNNotificationAction(identifier: "Open Action", title: "Clear", options: [])
            let category : UNNotificationCategory = UNNotificationCategory.init(identifier: "CALLINNOTIFICATION", actions: [callNow], intentIdentifiers: [], options: [])
            let center = UNUserNotificationCenter.current()
            center.setNotificationCategories([category])
        }
        
    func showAlertFromAppDelegates(){
        let alertVC = UIAlertController(title: "Need Authorization" , message: "This app is unusable if you don't authorize this app to use your location!", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Settings", style: UIAlertAction.Style.cancel) { (alert) in
            let url = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        }
        alertVC.addAction(okAction)
        DispatchQueue.main.async {
            var presentVC = self.window?.rootViewController
            while let next = presentVC?.presentedViewController {
                presentVC = next
            }
            presentVC?.present(alertVC, animated: true, completion: nil)
        }
    }
    
    
    func showLogInNavigation() {
        
        // switch root view controllers
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let nav = storyboard.instantiateViewController(withIdentifier: "MainNavigation")
        
        self.window?.rootViewController = nav
        //  self.window?.makeKeyAndVisible()
    }
    func showTabbarNavigation() {
        
        let storyboard:UIStoryboard = UIStoryboard(name: "TabBar", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "OwnerNav") as? UINavigationController
        //                     let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
        //
        //                    navigationController!.viewControllers = [rootViewController]
        checkOnboarding = "false"
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
    }
    func showTenantTabbarNavigation() {
        let storyboard:UIStoryboard = UIStoryboard(name: "TenantTab", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "tenantNav") as? UINavigationController
        checkOnboarding = "false"
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    
    func getUUID() -> String? {
        // create a keychain helper instance
        let keychain = KeychainAccess()
        // this is the key we'll use to store the uuid in the keychain
        let uuidKey = "DeviceUniqueId"
        // check if we already have a uuid stored, if so return it
        if let uuid = try? keychain.queryKeychainData(itemKey: uuidKey), uuid != nil {
            return uuid
        }
        // generate a new id
        guard let newId = UIDevice.current.identifierForVendor?.uuidString else {
            return nil
        }
        
        // store new identifier in keychain
        try? keychain.addKeychainData(itemKey: uuidKey, itemValue: newId)
        
        // return new id
        return newId
    }
    
    func setupLocationManager(){
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
               locationManager.startUpdatingLocation()
               if CLLocationManager.locationServicesEnabled() {
                   locationManager.requestLocation();
               }
//        }
    }
    
    // Below method will provide you current location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if currentLocation == nil {
            currentLocation = locations.last
            locationManager?.stopMonitoringSignificantLocationChanges()
            let locationValue:CLLocationCoordinate2D = manager.location!.coordinate
            print("locations = \(locationValue)")
            objAppShareData.strLat = String(locationValue.latitude)
            objAppShareData.strLong = String(locationValue.longitude)
            locationManager?.stopUpdatingLocation()
        }
    }
    
    // Below Mehtod will print error if not able to update location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
    }
}

//MARK: - FireBase Methods / FCM Token
extension AppDelegate {

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        objAppShareData.strFirebaseToken = fcmToken
        
        print("objAppShareData.firebaseToken = \(objAppShareData.strFirebaseToken)")
    }

    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        objAppShareData.strFirebaseToken = fcmToken
        
        ConnectToFCM()
    }

    func tokenRefreshNotification(_ notification: Notification) {
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            }else if let result = result {
                print("Remote instance ID token: \(result.token)")
                objAppShareData.strFirebaseToken = result.token
                print("objAppShareData.firebaseToken = \(result.token)")
            }
        }
        // Connect to FCM since connection may have failed when attempted before having a token.
        ConnectToFCM()
    }

    // Receive data message on iOS 10 devices while app is in the foreground.
    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
    }

    func ConnectToFCM() {
        InstanceID.instanceID().instanceID { (result, error) in
            
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            }else if let result = result {
                print("Remote instance ID token: \(result.token)")
                objAppShareData.strFirebaseToken = result.token
                print("objAppShareData.firebaseToken = \(result.token)")
            }
        }
    }

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if let userInfo = notification.request.content.userInfo as? [String : Any]{
            print(userInfo)
//            var notifincationType = ""
//            if let notiType = userInfo["type"] as? String{
//                notifincationType = notiType
//            }
            //self.handleNotificationWithNotificationData(dict: userInfo)
        }
        completionHandler([.alert,.sound,.badge])
    }

    @available(iOS 10.0, *)
     func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {
        
       
         print(response.notification.request.content.userInfo)
        print(response)
        switch response.actionIdentifier {
            
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Open Action")
            if let userInfo = response.notification.request.content.userInfo as? [String : Any]{
                print(userInfo)
                self.handleNotificationWithNotificationData(dict: userInfo)
            }
        case "Snooze":
            print("Snooze")
        case "Delete":
            print("Delete")
        default:
            print("default")
        }
        completionHandler()
     }
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//
//        print(response)
//        objAlert.showAlert(title: "test", controller: objAppDelegate.window!)
//        switch response.actionIdentifier {
//
//        case UNNotificationDismissActionIdentifier:
//            print("Dismiss Action")
//        case UNNotificationDefaultActionIdentifier:
//            print("Open Action")
//            if let userInfo = response.notification.request.content.userInfo as? [String : Any]{
//                print(userInfo)
//                self.handleNotificationWithNotificationData(dict: userInfo)
//            }
//        case "Snooze":
//            print("Snooze")
//        case "Delete":
//            print("Delete")
//        default:
//            print("default")
//        }
//        completionHandler()
//    }
    
    func handleNotificationWithNotificationData(dict:[String:Any]){
        var notifincationType = ""
        if let notiType = dict["notification_type"] as? String{
            notifincationType = notiType
        }
        objAppShareData.isFromNotification = true
        objAppShareData.strNotificationType = notifincationType
        objAppShareData.notificationDict = dict
        self.checkUserNavigation()
    }
    func checkUserNavigation(){
//   owner side- type- property_request,tenant_property_leave,property_request_accept,property_request_declined,owner_p_leave
//        redirect to - Property Details
//        type - payment_received
//        redirect to - Property_info
        objAppShareData.fetchUserInfoFromAppshareData()
        let userID = UserDefaults.standard.value(forKey: UserDefaults.KeysDefault.kUserId)
        let usertype = objAppShareData.UserDetail.strUserType
        let token = objAppShareData.UserDetail.strAuthToken
        if token == nil{
            self.showLogInNavigation()
        }else if userID == nil{
            // for if user in tab bar we check user id
            self.showLogInNavigation()
        }else {
            // if user id not == nil then we naviagte root tab bar
            if usertype == "owner"{
                self.showTabbarNavigation()
            }else if usertype == "tenant"{
                self.showTenantTabbarNavigation()
            }
        }
    }
    func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension AppDelegate{
    func GetContent(){
        ///SVProgressHUD.show()
        objWebServiceManager.requestGet(strURL: WsUrl.GetContent, params: nil, queryParams: [:], strCustomValidation: "",success: { (response) in
            print(response)
           // let message = response["message"] as? String ?? ""
            let status = response["status"] as? String ?? ""
            
            if   status == "success" {
                
                ///SVProgressHUD.dismiss()
                if let data = response["data"]as? [String:Any]{
                    
                   
                    
                    if let contents = data["contents"]as? [String:Any]{
                                       if let privacy = contents["privacy"]as? String{
                                           print("privacy is \(privacy)" )
                                        objAppShareData.strPolicy = privacy
                                       }
                        if let terms = contents["terms"]as? String{
                            print("terms is \(terms)" )
                            objAppShareData.strTermsCondition = terms
                                         
                        }
                        
                    }
                    
 
                }
            }
            else{
               // SVProgressHUD.dismiss()
               // objAlert.showAlert(message:message, title: kAlertTitle, controller: self)
            }
        }, failure: { (error) in
            print(error)
           // SVProgressHUD.dismiss()
           // objAlert.showAlert(message: kErrorMessage, title: kAlertTitle, controller: self)
        })
        
    }
    
}
