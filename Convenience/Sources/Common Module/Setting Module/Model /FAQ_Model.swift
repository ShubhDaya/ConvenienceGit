//
//  FAQ_Model.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 05/02/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import Foundation

class FAQ_Model: NSObject {
    
     var Questions: String?
     var Answers: String?
    var isSelected: Bool?
   
    
    init(Questions:String,Answers:String,isSelected:Bool) {
         self.Questions = Questions
         self.Answers = Answers
         self.isSelected = isSelected
     }
}
