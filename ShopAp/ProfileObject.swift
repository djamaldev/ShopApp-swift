//
//  ProfileObject.swift
//  ShopAp
//
//  Created by mr Yacine on 1/14/19.
//  Copyright © 2019 mr Yacine. All rights reserved.
//

import UIKit

class ProfileObject {
    
    var Name: String!
    var Icon: UIImage!
    var Action: (()->())!
    var Rate: (()->())?
    var Gener : VCsEnum!
    init(Name: String, Icon: UIImage, Action: @escaping ()->()) {
        self.Name = Name
        self.Icon = Icon
        self.Action = Action
    }
}
