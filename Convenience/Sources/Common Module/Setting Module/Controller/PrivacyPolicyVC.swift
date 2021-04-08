//
//  PrivacyPolicyVC.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 05/02/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import WebKit

class PrivacyPolicyVC: UIViewController {
    
    var strPolicy = ""
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view1.setViewRadius()
        self.view1.setshadowView()
//        if let pdf = Bundle.main.url(forResource: "Privacypolicy", withExtension: "pdf", subdirectory: nil, localization: nil){
//            let req = NSURLRequest(url: pdf)
//            self.webView.load(req as URLRequest)
//
//        }
        
        if let url = URL(string: self.strPolicy) {

                  let request = URLRequest(url: url)
                  
                 // self.webView.navigationDelegate = self

                  self.webView.load(request)
        }
 
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
