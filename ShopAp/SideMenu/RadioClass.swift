//
//  RadioClass.swift
//  AnimationProject
//
//  Created by mr Yacine on 16/09/2018.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import Foundation
import UIKit

enum VCsEnum : String {
    case Main
    case Contact
    case AddProduct
    case User
    case stop
    case ebay
    case amazon
}

class RadioClass {
    
    static var Destination : String!
    static var whereAm: VCsEnum! = .Main
    
    
    static func GoTo(Where : VCsEnum) {
        Destination = Where.rawValue
        whereAm = Where
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("OpenNewVC"), object: nil)
    }
    
    static func ToggleMenu() {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("MenuPressed"), object: nil)
    }
    
}
