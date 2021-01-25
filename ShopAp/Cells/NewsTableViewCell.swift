//
//  NewsTableViewCell.swift
//  ShopAp
//
//  Created by mr Yacine on 5/8/19.
//  Copyright © 2019 mr Yacine. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var btnAction: XButton!
    
    @IBAction func BtnAction(_ sender: UIButton) {
        Action?()
    }
    @IBOutlet weak var title_art: UILabel!
    @IBOutlet weak var author_art: UILabel!
    //@IBOutlet weak var source_art: UILabel!
    @IBOutlet weak var content_art: UITextView!
    @IBOutlet weak var date_art: UILabel!
    @IBOutlet weak var Image_art: UIImageView!
    //@IBOutlet weak var Descrption_art: UITextView!
    @IBOutlet weak var Loading: UIActivityIndicatorView!
    var webKit: UIWebView!
    var Action: (()->())?
    var obj: Articl?
    var ImageAnimationBlock: (()->())?
    func update(url: String){
        self.Loading.startAnimating()
        if let theURL = URL(string: url){
            self.Image_art.sd_setImage(with: theURL) { (theIMG, error, cache, Url) in
                self.ImageAnimationBlock?()
                self.Loading.stopAnimating()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnAction.config(title: "More")
    }
    
    func OpenUrl(url: String){
        if let theURL = URL(string: url){
            let request = URLRequest(url: theURL)
            webKit.loadRequest(request)
        }
    }
}
