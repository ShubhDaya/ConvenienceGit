//
//  ResetPasswordVC.swift
//  Hoggz
//
//  Created by MACBOOK-SHUBHAM V on 31/12/19.
//  Copyright © 2019 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class ResetPasswordVC: UIViewController {

    
    @IBOutlet weak var lblResetPass: UILabel!
    @IBOutlet weak var resetPassTxt: UILabel!
   
    @IBOutlet weak var txtEnterOtp: UITextField!
    
    @IBOutlet weak var txtEnterPassword: UITextField!
    
    @IBOutlet weak var txtEnterConfirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
 
    
    @IBAction func btbBack(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnResetPassword(_ sender: Any) {
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
