//
//  ProfileTableViewCell.swift
//  ShopAp
//
//  Created by mr Yacine on 4/9/19.
//  Copyright © 2019 mr Yacine. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var ImageView: UIImageView!
    
    @IBOutlet weak var NameLable: UILabel!
    
    @IBOutlet weak var TheView: UIView!
    
    func Update(Profile: ProfileObject){
     self.ImageView.image = Profile.Icon
     self.NameLable.text = Profile.Name
     }
    func update(Profile : ProfileObject, selected: Bool){
        self.NameLable.text = Profile.Name
        self.ImageView.image = Profile.Icon
        if selected {
            TheView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        } else {
            TheView.backgroundColor = UIColor.clear
        }
    }
    
}

class Profile : UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 6
    }
    
}

class CirclTheView: UIView {
    
    func CircleIt() {
        self.layer.cornerRadius = self.frame.size.height / 2
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CircleIt()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        CircleIt()
    }
    
}
