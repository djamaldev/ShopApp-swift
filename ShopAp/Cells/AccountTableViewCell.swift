//
//  AccountTableViewCell.swift
//  ShopAp
//
//  Created by mr Yacine on 1/27/19.
//  Copyright © 2019 mr Yacine. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    @IBOutlet weak var ImageView: UIImageView!
    
    @IBOutlet weak var LableName: UILabel!
    
    func update(Contact: contactObject){
        self.LableName.text = Contact.Name
        self.ImageView.image = Contact.Icon
    }
    
}
