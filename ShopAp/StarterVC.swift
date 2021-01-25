//
//  StarterVC.swift
//  ShopAp
//
//  Created by mr Yacine on 11/27/18.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import UIKit
import FirebaseAuth

class StarterVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        PutGradientBG()
    }
    
   /* override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.performSegue(withIdentifier: "AA", sender: nil)
       Auth.auth().addStateDidChangeListener { (Auth, User) in
            if User != nil{
                self.performSegue(withIdentifier: "App", sender: nil)
            } else {
                self.performSegue(withIdentifier: "Auth", sender: nil)
            }
        }
    }*/
    
    //*************** Gradiend Colors **********//
    
    let layer = CAGradientLayer()
    func PutGradientBG() {
        //let FirstColor = UIColor(red: 255.0/255.0, green: 116.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        let FirstColor = UIColor(red: 18.0/255.0, green: 194.0/255.0, blue: 233.0/255.0, alpha: 1.0)
        let SecondColor = UIColor(red: 196.0/255.0, green: 113.0/255.0, blue: 237.0/255.0, alpha: 1.0)
        let thirdColor = UIColor(red: 246.0/255.0, green: 79.0/255.0, blue: 89.0/255.0, alpha: 1.0)
        layer.colors = [FirstColor.cgColor , SecondColor.cgColor , thirdColor.cgColor]
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
    
    //******************************************//

}
