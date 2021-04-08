//
//  SplashScreenVC.swift
//  Hoggz
//
//  Created by MACBOOK-SHUBHAM V on 02/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class SplashScreenVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        DispatchQueue.background(delay: 0.5, background: {
//        self.getInitialDiseaseList()
//        }, completion: {
//        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVc") as! WelcomeVc
//        self.present(nextVC, animated: true, completion: nil)
//        // when background job finishes, wait 3 seconds and do something in main thread
//
//        })
        
        

           DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVc") as! WelcomeVc
                   self.present(nextVC, animated: true, completion: nil)
               } 

        // Do any additional setup after loading the view.
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
