//
//  TenantTab.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 29/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class TenantTab: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(objAppSharedata.UserDetail.strUserID, forKey: UserDefaults.KeysDefault.kUserId)
        objAppShareData.selecteddata.removeAll()
    }
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
//payment_due (Some cases without select property manage)
//>> TenantSendPayment Screen
//property_request_accept
//property_request_declined
//owner_property_leave
//>> PropertyDetails
        if objAppShareData.isFromNotification{
         if objAppShareData.strNotificationType == "payment_due" || objAppShareData.strNotificationType == "payment_marked_due"{
             self.selectedIndex = 2
            //payment_due (Some cases without select property manage)
            //>> TenantSendPayment Screen
         }else if objAppShareData.strNotificationType == "property_request_accept" || objAppShareData.strNotificationType == "property_request_declined" || objAppShareData.strNotificationType == "owner_property_leave"{
                self.selectedIndex = 1
          }
        }
      }

      override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      for vc in self.viewControllers! {
     if #available(iOS 13.0, *) {
          vc.tabBarItem.imageInsets = UIEdgeInsets(top: 1, left: 0, bottom:2, right: 0)
      }else{
          vc.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom:-6, right: 0)
      }
      }
    }
}
