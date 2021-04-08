//
//  StringExtension.swift
//  Bang
//
//  Created by Rohit on 23/10/19.
//  Copyright © 2019 Rohit Singh All rights reserved.
//

import UIKit

extension String {
    
    var LastPathComponent: String {
        get {
            return (self as NSString).lastPathComponent
        }
    }
    
    var PathExtension: String {
        get {
            return (self as NSString).pathExtension
        }
    }
    
    var StringByDeletingLastPathComponent: String {
        get {
            return (self as NSString).deletingLastPathComponent
        }
    }
    
    var StringByDeletingPathExtension: String {
        get {
            return (self as NSString).deletingPathExtension
        }
    }
    
    var PathComponents: [String] {
        get {
            return (self as NSString).pathComponents
        }
    }
    
    var Length: Int {
        get {
            return (self as NSString).length
        }
    }
    
    func StringByAppendingPathComponent(_ path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    
    func StringByAppendingPathExtension(_ ext: String) -> String? {
        let nsSt = self as NSString
        return nsSt.appendingPathExtension(ext)
    }
    
    func StringToDictionary() -> NSDictionary {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                let dict = try JSONSerialization.jsonObject(with: data, options: [])
                if let ddd: NSDictionary = dict as? NSDictionary {
                    return ddd
                }
            } catch let err {
                print("err >>>>> \(err)")
            }
        }
        return NSDictionary()
    }
    
    var numbersOnly: String {
        return components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
    }
    var integerValue: Int {
        return Int(self) ?? 0
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var hasOnlyNewlineSymbols: Bool {
        return trimmingCharacters(in: CharacterSet.newlines).isEmpty
    }
    
    
    var First: String {
        return String(prefix(1))
    }
    
    var Last: String {
        return String(suffix(1))
    }
    
    var UppercaseFirst: String {
        return First.uppercased() + String(dropFirst())
    }
    
    var UppercaseEveryWord: String {
        return self.capitalized(with: Locale.current)
    }
    
    func FromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    func ToBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    func StringToArray(separatedBy: String) -> NSArray {
        if self.Length > 0 {
            let arr = self.components(separatedBy: separatedBy) as NSArray
            return arr
        }
        return NSArray()
    }
    
    
}

extension Double {
    struct Number {
        static let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            return formatter
        }()
    }
    
    var twoDigits: String {
        return Number.formatter.string(from: NSNumber(value: self)) ?? ""
    }
    
    var MetersToMiles: Double {
        return self * 0.0006213
    }
    
    var MetersToKM: Double {
        return self * 0.001
    }
    
    var MetersToFeet: Double {
        return self * 0.3048
    }
    
    var MilesToFeet: Double {
        return self * 5280
    }
    
}

extension String
{
    public func getAcronyms(separator: String = "") -> String
    {
        let acronyms = self.components(separatedBy: " ").map({ String($0.first ?? " ")}).joined(separator: separator);
        return acronyms;
    }
}
