//
//  productTableViewCell.swift
//  ShopAp
//
//  Created by mr Yacine on 11/27/18.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import UIKit
import SDWebImage

class productTableViewCell: UITableViewCell {

    @IBOutlet weak var PriceLable: UILabel!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var descriptionLable: UILabel!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    
    func update(Product : productObject){
        self.nameLable.text = Product.Name
        self.descriptionLable.text = Product.Description
        self.PriceLable.text = Product.price
        loading.startAnimating()
        if let urlImage = Product.SmallImage{
            if let url = URL(string: urlImage){
                self.ImageView.sd_setImage(with: url) { (Image, error, cache, url) in
                    self.ImageAnimationBlock?()
                    self.loading.stopAnimating()
                }
            }
            
        }
        self.dateLable.text = Product.Stamp?.getTimeAgo()
    }
    
    var ImageAnimationBlock: (()->())?
    
}
