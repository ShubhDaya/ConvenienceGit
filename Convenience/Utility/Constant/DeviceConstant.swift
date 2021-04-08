//
//  DeviceConstant.swift
//  Hoggz
//
//  Created by MACBOOK-SHUBHAM V on 03/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import Foundation
import UIKit


let IS_IPHONE = UIUserInterfaceIdiom.phone ==  UIUserInterfaceIdiom.phone

let IS_IPHONE_4 = IS_IPHONE && UIScreen.main.bounds.size.height == 480.0
let IS_IPHONE_5 = IS_IPHONE && UIScreen.main.bounds.size.height == 568.0
let IS_IPHONE_6 = IS_IPHONE && UIScreen.main.bounds.size.height == 667.0
let IS_IPHONE_6PLUS = IS_IPHONE && UIScreen.main.nativeScale == 3.0
let IS_IPHONE_6_PLUS = IS_IPHONE && UIScreen.main.bounds.size.height == 736.0

let IS_IPHONE_X = IS_IPHONE && UIScreen.main.bounds.size.height == 812.0

let IS_IPHONE_XSMAX_XR = (IS_IPHONE && UIScreen.main.bounds.size.height == 896.0)

let IS_RETINA = UIScreen.main.scale == 2.0


let MAIN_FRAME : CGRect = UIScreen.main.bounds

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let SCREEN_WIDTH_RATIO = UIScreen.main.bounds.size.width/320
let SCREEN_HEIGHT_RATIO = UIScreen.main.bounds.size.height/568

let DEVICE_LANGUAGE = (Locale.current as NSLocale).object(forKey: NSLocale.Key.languageCode)!
