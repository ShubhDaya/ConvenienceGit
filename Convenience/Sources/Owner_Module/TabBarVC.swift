//
//  ViewController.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 20/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class TabBarVC : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(objAppSharedata.UserDetail.strUserID, forKey: UserDefaults.KeysDefault.kUserId)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
        //property_request
        //tenant_property_leave
        //>> Property Details
        //
        //payment_received
        //>> Property Info
        //
        //connect_account_verification_pending
        //>> Add/Update Bank Screen
             if objAppShareData.isFromNotification{
                if objAppShareData.strNotificationType == "payment_received"{
                    self.selectedIndex = 1
                    self.selectItem(withIndex: 1)
                }else if objAppShareData.strNotificationType == "property_request" || objAppShareData.strNotificationType == "tenant_property_leave"{
                       self.selectedIndex = 2
                       self.selectItem(withIndex: 2)
                }else if objAppShareData.strNotificationType == "connect_account_verification_pending"{
                    self.selectedIndex = 4
                    self.selectItem(withIndex: 4)
                }else if objAppShareData.strNotificationType == "Payment_due_system"{
                    self.selectedIndex = 1
                    self.selectItem(withIndex: 1)
                }
               }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for vc in self.viewControllers! {
            if #available(iOS 13.0, *) {
                vc.tabBarItem.imageInsets = UIEdgeInsets(top: 1, left: 0, bottom:2, right: 0)
            }else{
                vc.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom:-5, right: 0)
            }
        }
    }
    //Overriding this to get callback whenever its value is changes
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let items = tabBar.items {
            items.enumerated().forEach { if $1 == item { print("your index is: \($0)") } }
        }
    }
    func selectItem(withIndex index: Int) {

        if  let controller = tabBarController,
            let tabBar = tabBarController?.tabBar,
            let items = tabBarController?.tabBar.items
        {
            guard index < items.count else { return }
            controller.selectedIndex = index
            controller.tabBar(tabBar, didSelect: items[index])
        }
    }
}
