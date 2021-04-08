//
//  CustomExtension.swift
//  Mualab
//
//  Created by MINDIII on 11/1/17.
//  Copyright © 2017 MINDIII. All rights reserved.
//

import Foundation
import UIKit

class CustomExtension: NSObject {}

extension UIImageView
{
    
    func setImgeRadius(){
        clipsToBounds = true
        layer.cornerRadius = 5
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        
    }
    
    func setImageProperty() {
        layer.backgroundColor = UIColor.clear.cgColor
        layer.borderWidth = 1.5
        //self.layer.borderColor=[commenColorRed CGColor];
    }
    
    func setImageFream() {
        layer.cornerRadius = layer.frame.size.height / 2
        layer.masksToBounds = true
    }
    
    func setImgCircle(){
        
        layer.cornerRadius = layer.frame.size.height/2
        layer.masksToBounds = true
        layer.borderWidth = 2
        layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
    }
    
    func setImgCircleColor(){
        
        layer.cornerRadius = layer.frame.size.height/2
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = #colorLiteral(red: 0.1140634629, green: 0.2149929786, blue: 0.3579177461, alpha: 1)
    }
    func setImgRadius(){
        //top left top right
        
        clipsToBounds = true
        layer.cornerRadius = 15
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
    }
    func setshadowimage(){
        //only top left and top right of the view
        layer.masksToBounds = false
        //layer.borderColor = UIColor.gray.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
    
    
    
    
}

extension UIButton {
    func btnradius17(){
        layer.cornerRadius = 17
        layer.borderWidth = 0.5
        layer.borderColor = #colorLiteral(red: 0.4955472798, green: 0.4955472798, blue: 0.4955472798, alpha: 1)
        layer.masksToBounds = true
        
    }
    func btnRadNonCol17(){
        layer.cornerRadius = 17
        layer.borderWidth = 0.5
        layer.masksToBounds = true
        
    }
    func btnRadNonCol20(){
        layer.cornerRadius = 20
        layer.borderWidth = 0.5
        layer.masksToBounds = true
        
    }
    func btnRadNonCol10(){
          layer.cornerRadius = 10
          layer.borderWidth = 0.5
          layer.masksToBounds = true
          
      }
    func btnRadNonCol5(){
            layer.cornerRadius = 5
            layer.borderWidth = 0.5
            layer.masksToBounds = true
            
        }
    func setbtnshadow(){
          //only top left and top right of the view
          layer.masksToBounds = false
          //layer.borderColor = UIColor.gray.cgColor
          layer.shadowColor = UIColor.black.cgColor
          //layer.shadowOffset = .zero
         // layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        layer.shadowOpacity = 0.3
          layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
      }
    
}

extension String {
    func toimage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}

extension UIImage {
    func tostring() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}


extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}

extension UIImage {
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}



extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font as Any], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}
extension UITextView {
    
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}

extension UIViewController{
    
    func show() {
        let window = UIApplication.shared.delegate?.window
        let visibleVC = window??.visibleViewController
        visibleVC?.present(self, animated: true, completion: nil)
    }
}

extension UIView{
    func setViewRadius25(){
           // set view radius oly top left and top right
           layer.masksToBounds = false
           layer.cornerRadius = 12
   layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]       }
    
    func setViewRadius18(){
           // set view radius oly top left and top right
           layer.masksToBounds = false
           layer.cornerRadius = 18
   layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]       }
    func setViewRadius(){
        // set view radius oly top left and top right
        layer.masksToBounds = false
        layer.cornerRadius = 15
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    func setViewRadius10(){
        // set view radius oly top left and top right
        layer.masksToBounds = false
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    func setViewAllRadius(){
        // set view radius oly top left and top right
        layer.masksToBounds = false
        layer.cornerRadius = 15
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
    func setViewCornerRadius(){
        layer.masksToBounds = false
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
}

extension UIButton{
    func setradiusbtn(){
        layer.cornerRadius = 20
        clipsToBounds = true
    }
    func setradiusbtn15(){
        layer.cornerRadius = 15
        clipsToBounds = true
    }
}
extension UIView {
    func setShadowAllView(){
        layer.shadowColor = UIColor.black.cgColor
        // layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 5
        layer.shadowOffset = .zero
        layer.cornerRadius = 20
        
    }
    func setShadowAllView2(){
        layer.shadowColor = UIColor.gray.cgColor
        // layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 3
        layer.shadowOffset = .zero
        layer.cornerRadius = 20
        
    }
    func setShadowAllView10(){
        layer.shadowColor = UIColor.black.cgColor
        // layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 3
        layer.shadowOffset = .zero
        layer.cornerRadius = 10
        
    }
    
    func setshadowView(){
        //only top left and top right of the view
        layer.masksToBounds = false
        //layer.borderColor = UIColor.gray.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -3)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 2
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
    }
    func setshadowViewCircle(){
        //only top left and top right of the view
        layer.masksToBounds = false
        //layer.borderColor = UIColor.gray.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.4
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
    
    func setviewCircle(){
        // for set view circle
        layer.cornerRadius = layer.frame.size.height/2
        layer.masksToBounds = true
        layer.borderWidth = 0.6
        layer.borderColor = #colorLiteral(red: 0.1140634629, green: 0.2149929786, blue: 0.3579177461, alpha: 1)
    }
    func setviewCirclewhite(){
        // for set view circle
        layer.cornerRadius = layer.frame.size.height/2
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    func setviewOnlyCircle(){
           // for set view circle
           layer.cornerRadius = layer.frame.size.height/2
           layer.masksToBounds = true
       }
    
    
    
    func textviewRadius(){
        // for text fieild in the view
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.gray.cgColor
        layer.cornerRadius = 5;
        layer.masksToBounds = true;
        
        
        
    }
    
    
}



public extension UIWindow {
    var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(vc: self.rootViewController)
    }
    
    static func getVisibleViewControllerFrom(vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(vc: nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(vc: tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(vc: pvc)
            } else {
                return vc
            }
        }
    }
}

extension Int {
    var roundedWithAbbreviations: String {
        let number = Double(self)
        let thousand = number / 1000
        if thousand >= 1.0 {
            if number >= 1000 && number <= 1100{
                return "1K"
            }else{
                return "\(round(thousand*10)/10)K"
            }
        }
        else {
            return "\(self)"
        }
    }
}

func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
    
    let calendar = NSCalendar.current
    let now = NSDate()
    let earliest = now.earlierDate(date as Date)
    let latest = (earliest == now as Date) ? date : now
    
    let unitsSet : Set<Calendar.Component> = [.year,.month,.weekOfYear,.day, .hour, .minute, .second, .nanosecond]
    
    let components:NSDateComponents = calendar.dateComponents(unitsSet, from: earliest, to: latest as Date) as NSDateComponents
    
    if (components.year >= 2) {
        return "\(components.year) years"
    }
    else if (components.year == 1){
        if (numericDates){
            return "1 year"
        } else {
            return "Last year"
        }
    }
    else if (components.month >= 2) {
        return "\(components.month) months"
    }
    else if (components.month == 1){
        if (numericDates){
            return "1 month"
        } else {
            return "Last month"
        }
    }
    else if (components.weekOfYear >= 2) {
        return "\(components.weekOfYear) weeks"
    }
    else if (components.weekOfYear == 1){
        if (numericDates){
            return "1 week"
        } else {
            return "Last week"
        }
    } else if (components.day >= 2) {
        return "\(components.day) days"
    } else if (components.day == 1){
        if (numericDates){
            return "1 day"
        } else {
            return "Yesterday"
        }
    } else if (components.hour >= 2) {
        return "\(components.hour) hours"
    } else if (components.hour == 1){
        if (numericDates){
            return "1 hour"
        } else {
            return "hour"
        }
    } else if (components.minute >= 2) {
        return "\(components.minute) mins"
    } else if (components.minute == 1){
        if (numericDates){
            return "1 min"
        } else {
            return "1 min"
        }
    } else if (components.second >= 3) {
        return "\(components.second) secs"
    } else {
        return "1 sec"
    }
    
}

extension UIView
{
    func fadeIn(duration: TimeInterval = 0.5,
                delay: TimeInterval = 0.0,
                completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       //  options: UIView.AnimationOptions.curveEaseIn,
            animations: {
                self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 0.5,
                 delay: TimeInterval = 0.0,
                 completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       // options: UIView.AnimationOptions.curveEaseIn,
            animations: {
                self.alpha = 0.0
                //self.isHidden = true
        }, completion: completion)
    }
    
    func setViewShadowWithoutCornerRadius(color:UIColor) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
        layer.shadowOpacity = 0.6
    }
    
    func setViewShadow(_ opacity: Float) {
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height + 1))
        //self.backgroundColor = [UIColor whiteColor];
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowOpacity = opacity
        layer.shadowPath = shadowPath.cgPath
    }
    
    func setShadow3D(_ opacity: Float) {
        let shadowPath = UIBezierPath(rect: CGRect(x: 2, y: 2, width: frame.size.width - 2, height: frame.size.height - 2))
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowOpacity = opacity
        layer.shadowPath = shadowPath.cgPath
    }
    
    func setViewShadowMoreCornerRadius() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: -0.3, height: 0.3)
        layer.shadowOpacity = 0.6
        layer.cornerRadius = 10
    }
    
}

extension UIColor{
    func HexToColor(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
}

func relativePast(for date : Date) -> String {
    let units = Set<Calendar.Component>([.year, .month, .day, .weekOfYear])
    let components = Calendar.current.dateComponents(units, from: date, to: Date())
    
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
    let strDateTime = formatter.string(from: date)
    let arrDate = strDateTime.components(separatedBy: " ")
    
    var msgDateDay = 0
    var strDate = ""
    if arrDate.count == 2{
        let date1 = arrDate[0]
        var arrNew = date1.components(separatedBy: "-")
        arrNew = arrNew.reversed()
        msgDateDay = Int(arrNew[0])!
        strDate = arrNew.joined(separator: "/")
    }
    
    let currentDate = Date()
    let strCurrentDateTime = formatter.string(from: currentDate)
    let arrCurrentDate = strCurrentDateTime.components(separatedBy: " ")
    var currentDateDay = 0
    if arrCurrentDate.count == 2{
        let date2 = arrCurrentDate[0]
        var arrCurrentNew = date2.components(separatedBy: "-")
        arrCurrentNew = arrCurrentNew.reversed()
        currentDateDay = Int(arrCurrentNew[0])!
    }
    
    if components.year! > 0 {
        let str = converteDateMsgDay(strDateFromServer: strDate)
        return str
    } else if components.month! > 0 {
        let str = converteDateMsgDay(strDateFromServer: strDate)
        return str
    } else if components.weekOfYear! > 0 {
        let str = converteDateMsgDay(strDateFromServer: strDate)
        return str
    } else if (components.day! > 0) {
        if (components.day! > 1){
            let str = converteDateMsgDay(strDateFromServer: strDate)
            return str
        }else{
          //  let str = converteDateMsgDay(strDateFromServer: strDate)
            //return str
            return NSLocalizedString("Yesterday", tableName: nil, comment: "")
        }
    } else {
        if currentDateDay>msgDateDay{
            return NSLocalizedString("Yesterday", tableName: nil, comment: "")
        }else{
            return NSLocalizedString("Today", tableName: nil, comment: "")
        }
    }
}

// Convert date formate
func converteDateMsgDay(strDateFromServer: String) -> (String) {
    
    var strConvertedDate : String = ""
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy"
    
    let dateFromServer: Date? = dateFormatter.date(from: strDateFromServer)
    
    if let dateFromServer = dateFromServer {
        
        dateFormatter.dateFormat = "EEE, dd MMM"
        
        let strDate:String? = dateFormatter.string(from: dateFromServer)
        
        if let strDate = strDate {
            strConvertedDate = strDate
        }
    }
    return strConvertedDate
}

