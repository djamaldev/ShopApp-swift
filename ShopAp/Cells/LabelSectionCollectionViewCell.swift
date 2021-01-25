//
//  LabelSectionCollectionViewCell.swift
//  ShopAp
//
//  Created by mr Yacine on 1/16/19.
//  Copyright © 2019 mr Yacine. All rights reserved.
//

import UIKit

class LabelSectionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var NameSection: UILabel!
    
    @IBOutlet weak var ViewSection: UIView!
    
    var select : Bool = false
    
    func update(section: sectionObject){
        
       self.NameSection.text = section.Name
        if self.select {
            self.NameSection.textColor = UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 191.0/255.0, alpha: 1.0)
            self.ViewSection.backgroundColor = UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        } else {
            self.NameSection.textColor = UIColor.black
            self.ViewSection.backgroundColor = UIColor.white
        }
    }
}
