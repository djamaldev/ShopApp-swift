//
//  AdminSectionsTableViewCell.swift
//  ShopAp
//
//  Created by mr Yacine on 12/23/18.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import UIKit

class AdminSectionsTableViewCell: UITableViewCell {

    //@IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var Lable: UILabel!
    //@IBOutlet weak var loading: UIActivityIndicatorView!
    
    /*func update(section: sectionObject){
        self.loading.startAnimating()
        self.Lable.text = section.Name
        if let strURL = section.Icon {
            if let url = URL(string: strURL){
                self.imgView.sd_setImage(with: url) { (theIMG, error, Cache, Url) in
                    self.loading.stopAnimating()
                }
            }
        }
    }*/
    
    func update(section: sectionObject){
       self.Lable.text = section.Name
    }
}
