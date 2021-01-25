//
//  contactObject.swift
//  ShopAp
//
//  Created by mr Yacine on 1/15/19.
//  Copyright © 2019 mr Yacine. All rights reserved.
//

import UIKit

class contactObject {
    
    var Icon : UIImage
    var Name: String
    var Action : (()->())?
    init(Name : String, Icon : UIImage, Action :@escaping ()->()) {
        
        self.Name = Name
        self.Icon = Icon
        self.Action = Action
    }
}
