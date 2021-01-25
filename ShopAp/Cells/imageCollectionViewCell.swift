//
//  imageCollectionViewCell.swift
//  ShopAp
//
//  Created by mr Yacine on 11/28/18.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import UIKit

class imageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    func update(img : UIImage){
        loading.stopAnimating()
        self.imgView.image = img
    }
    
    func update(url: String){
        loading.startAnimating()
        if let theURL = URL(string: url){
            self.imgView.sd_setImage(with: theURL) { (theIMG, error, cache, Url) in
                self.loading.stopAnimating()
            }
        }
    }

}
