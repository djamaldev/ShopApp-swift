//
//  RateProductVC.swift
//  ShopAp
//
//  Created by mr Yacine on 12/27/18.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import UIKit
import Cosmos

class RateProductVC: UIViewController {
    
    @IBOutlet weak var RateProductBtn: XButton!
    var theProduct: productObject!
    @IBOutlet weak var starts: CosmosView!
    
    @IBAction func SendRate(sender: UIButton){
        theProduct.Rate(value: Int(starts.rating))
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.RateProductBtn.config(title: "Rate_Product")
    }
}
