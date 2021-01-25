//
//  FavoriteTableViewCell.swift
//  ShopAp
//
//  Created by mr Yacine on 2/6/19.
//  Copyright © 2019 mr Yacine. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var NameLable: UILabel!
    
    @IBOutlet weak var PriceLable: UILabel!
    
    @IBOutlet weak var ImageView: UIImageView!
    
    @IBOutlet weak var Activity: UIActivityIndicatorView!
    
    func update(Product : productObject){
        self.NameLable.text = Product.Name
        self.PriceLable.text = Product.price
        Activity.startAnimating()
        if let urlImage = Product.SmallImage{
            if let url = URL(string: urlImage){
                self.ImageView.sd_setImage(with: url) { (Image, error, cache, url) in
                    self.Activity.stopAnimating()
                }
            }
            
        }
    }
    
}
