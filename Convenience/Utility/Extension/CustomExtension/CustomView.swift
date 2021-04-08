//
//  CustomView.swift
//  MualabCustomer
//
//  Created by Mac on 09/02/18.
//  Copyright © 2018 Mindiii. All rights reserved.
//

import Foundation

import UIKit

class customView: UIView {
    
    
//border Color
    @IBInspectable var borderColor: UIColor = UIColor.black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
//border width
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
//border Bound
    @IBInspectable var borderBound: CGFloat = 10 {
        didSet {
            layer.cornerRadius = borderBound
         }
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        //layer.cornerRadius = 0.5 * bounds.size.width
        //clipsToBounds = true
    }
}

extension UIView {
    
//    func fadeInView(_ duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
//        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
//            self.alpha = 1.0
//        }, completion: completion)  }
    
//    func fadeOutView(_ duration: TimeInterval = 0.5, delay: TimeInterval = 1.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
//        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
//            self.alpha = 0.3
//        }, completion: completion)
//    }
}

class customLabel: UILabel {
    
    @IBInspectable var borderColor: UIColor = UIColor.black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderBound: CGFloat = 10 {
        didSet {
            layer.cornerRadius = borderBound
        }
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
}

class customImage: UIImageView {
    
    @IBInspectable var borderColor: UIColor = UIColor.black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderBound: CGFloat = 10 {
        didSet {
            layer.cornerRadius = borderBound
        }
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
}
class customButton: UIButton {
    
    @IBInspectable var borderColor: UIColor = UIColor.black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderBound: CGFloat = 10 {
        didSet {
            layer.cornerRadius = borderBound
        }
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
}


class customTextField: UITextField {
    
    @IBInspectable var borderColor: UIColor = UIColor.black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
        
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderBound: CGFloat = 10 {
        didSet {
            layer.cornerRadius = borderBound
        }
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
}
