//
//  PropertyModerl.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 06/02/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//


class OwnerPropertyModel : Equatable {
   
    var name: String?
    var address: String?
    var distance_km : Int?
    var image : String?
    var propertyID : Int?
    var status : String?
    var isSelected : Bool
    
    init(dict : [String : Any]) {
        let address = dict["address"] as? String ?? ""
        let distance = dict["distance_km"] as? Int ?? 0
        let image = dict["image"] as? String ?? ""
        let name = dict["name"] as? String ?? ""
        let propertyID = dict["propertyID"] as? Int ?? 0
        let status = dict["status"] as? String ?? ""
        let isselected = false

        self.address = address
        self.name = name
        self.distance_km = distance
        self.image = image
        self.propertyID = propertyID
        self.status = status
        self.isSelected = isselected
    
    }

    static func == (lhs: OwnerPropertyModel, rhs: OwnerPropertyModel) -> Bool {
           return lhs.propertyID == rhs.propertyID
       }
}
