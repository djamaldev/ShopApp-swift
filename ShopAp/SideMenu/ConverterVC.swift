//
//  ConverterVC.swift
//  AnimationProject
//
//  Created by mr Yacine on 16/09/2018.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import UIKit

class ConverterVC : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewNavBar = UIView(frame: CGRect(
            origin: CGPoint(x: 0, y:0),
            size: CGSize(width: self.view.frame.size.width, height: 10)))
        self.navigationController?.navigationBar.addSubview(viewNavBar)
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(ConverterVC.OpenNewVC), name: NSNotification.Name(rawValue: "OpenNewVC"), object: nil)
    
}
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.performSegue(withIdentifier: "Main", sender: nil)
    }
    @objc func OpenNewVC() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.performSegue(withIdentifier: RadioClass.Destination, sender: nil)
        }
        
    }
}
