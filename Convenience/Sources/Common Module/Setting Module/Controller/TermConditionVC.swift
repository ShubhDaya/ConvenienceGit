//
//  TermConditionVC.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 05/02/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import WebKit

class TermConditionVC: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var view1: UIView!
    
    var strTermsCondition = ""

    
    // var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view1.setViewRadius()
        self.view1.setshadowView()
//        if let pdf = Bundle.main.url(forResource: "Terms&conditions", withExtension: "pdf", subdirectory: nil, localization: nil){
//            let req = NSURLRequest(url: pdf)
//            self.webView.load(req as URLRequest)
//        }
        
        if let url = URL(string: self.strTermsCondition) {

                  let request = URLRequest(url: url)
                  
                 // self.webView.navigationDelegate = self

                  self.webView.load(request)
        }
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBAction func btnback(_ sender: Any) {
        self.view.endEditing(true)
        
        navigationController?.popViewController(animated: true)
    }
}


