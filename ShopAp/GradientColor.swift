//
//  GradientColor.swift
//  ShopAp
//
//  Created by mr Yacine on 2/3/19.
//  Copyright © 2019 mr Yacine. All rights reserved.
//

import UIKit

class GradientColor: UIViewController{
    
    static var shared = GradientColor()
    let layer = CAGradientLayer()
    func PutGradientBG() {
        //let FirstColor = UIColor(red: 255.0/255.0, green: 116.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        let FirstColor = UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 191.0/255.0, alpha: 1.0)
        let SecondColor = UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        //let thirdColor = UIColor(red: 246.0/255.0, green: 79.0/255.0, blue: 89.0/255.0, alpha: 1.0)
        layer.colors = [FirstColor.cgColor , SecondColor.cgColor]
        layer.zPosition = -1
        self.view.layer.addSublayer(layer)
        resize()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resize()
    }
    
    func resize() {
        layer.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        layer.startPoint = CGPoint(x: 0.5 , y: 0)
        layer.endPoint = CGPoint(x: 0.5 , y: 1)
    }
    
}
