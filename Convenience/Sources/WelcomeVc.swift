//
//  WelcomeVc.swift
//  Hoggz
//
//  Created by MACBOOK-SHUBHAM V on 30/12/19.
//  Copyright © 2019 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class WelcomeVc: UIViewController {
    
    
    @IBOutlet weak var headerImage: UIImageView!
    
    @IBOutlet weak var uilogo: UIImageView!
    @IBOutlet weak var txtview: UILabel!
    @IBOutlet weak var welcometxt: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnGetQuote(_ sender: Any) {
    }
    
    
    @IBAction func btnLogin(_ sender: Any) {
        
        
//      objAlert.showAlertCallBack(alertLeftBtn: "Cancel", alertRightBtn: "Ok", title: "My titile", message: "descriptions", controller: self) {
//        (isbuttonRight) in
//
//                if isbuttonRight
//                {
//                    print("IsRight button click")
//                }
//                else
//                {
//                    print("left button click")
//
//                }
//
//            }
//
// objAlert.showAlertCallBackother(alertLeftBtn: "Cancel", alertRightBtn: "Ok", title: "Title", message: "this is message text here", controller: self, callback: { (Mybool) in
//
//                             print("Isleft button click")
//
//     }) {
//
//                             print("IsRight button click")
//     }
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let LoginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//     //  self.present(LoginViewController, animated:true, completion: nil)
       self.navigationController?.pushViewController(LoginViewController, animated: true)

    }
    
    @IBAction func btnregister(_ sender: Any) {
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
