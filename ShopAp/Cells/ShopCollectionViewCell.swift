//
//  ShopCollectionViewCell.swift
//  ShopAp
//
//  Created by mr Yacine on 5/7/19.
//  Copyright © 2019 mr Yacine. All rights reserved.
//

import UIKit

class ShopCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ShopButtonImg: UIButton!
    
    var img: UIImage!

    var Action: (()->())?
    
    func done(img1: ShopObject){
        self.ShopButtonImg.setImage(img1.img, for: .normal)
        self.ShopButtonImg.addTarget(self, action: #selector(GoToVC(_:)), for: .touchUpInside)
    }
    
    @IBAction func GoToVC(_ sender: UIButton) {
        Action!()
    }
}
