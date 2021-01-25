//
//  SectionCollectionViewCell.swift
//  ShopAp
//
//  Created by mr Yacine on 12/22/18.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import UIKit
import SDWebImage

class SectionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var theView: UIView!
    var select : Bool = false
    func update(section: sectionObject){
        theView.layer.cornerRadius = self.frame.size.width / 4
        if let urlstr = section.Icon{
            if let url = URL(string: urlstr){
                ImageView.sd_setImage(with: url) { (theImage, error, cache, url) in
                    if let theimage = theImage {
                        let teplateImage = theimage.withRenderingMode(.alwaysTemplate)
                        self.ImageView.image = teplateImage
                        if self.select {
                            self.ImageView.tintColor = UIColor.white
                            self.theView.backgroundColor = UIColor(red: 143.0/255.0, green: 95.0/255.0, blue: 206.0/255.0, alpha: 1.0)
                        }else {
                            self.ImageView.tintColor = UIColor(red: 143.0/255.0, green: 95.0/255.0, blue: 206.0/255.0, alpha: 1.0)
                            self.theView.backgroundColor = UIColor.white
                        }
                    }
                }
            }
        }
    }
}
