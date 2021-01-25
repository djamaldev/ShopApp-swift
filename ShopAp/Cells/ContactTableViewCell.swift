//
//  ContactTableViewCell.swift
//  ShopAp
//
//  Created by mr Yacine on 1/15/19.
//  Copyright © 2019 mr Yacine. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var NameLable: UILabel!
    
    func Update(contact: contactObject){
        self.ImageView.image = contact.Icon
        self.NameLable.text = contact.Name
    }
    
}

class Account : UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 6
    }
}
