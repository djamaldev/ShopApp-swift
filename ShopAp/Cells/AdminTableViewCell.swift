//
//  AdminTableViewCell.swift
//  ShopAp
//
//  Created by mr Yacine on 12/25/18.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import UIKit

class AdminTableViewCell: UITableViewCell {

    
    @IBOutlet weak var NameLable: UILabel!
    
    func Update(Admin: AdminObject){
        self.NameLable.text = Admin.Name
    }
    
}
