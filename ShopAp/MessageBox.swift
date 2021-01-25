//
//  MessageBox.swift
//  ShopAp
//
//  Created by mr Yacine on 11/25/18.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import UIKit

class MessageBox : UIViewController {
    
    var texte: String!
    @IBOutlet weak var label : UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.label.text = texte
    }
    @IBAction func doneButton(sender: XButton) {
        dismiss(animated: true, completion: nil)
        
    }
}

class MessageBoxShow {
    
    static func Show(_ Text: String){
        let storyBoard = UIStoryboard(name: "MessageBox", bundle: nil)
        let Message = storyBoard.instantiateViewController(withIdentifier: "MessageBox") as! MessageBox
        Message.texte = Text
        Message.modalTransitionStyle = .crossDissolve
        Message.modalPresentationStyle = .overFullScreen
        UIApplication.getPresentedViewController()?.present(Message, animated: true, completion: nil)
    }
}

extension UIApplication {
    class func getPresentedViewController() -> UIViewController? {
        var presentViewController = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentViewController?.presentedViewController
        {
            presentViewController = pVC
        }
        
        return presentViewController
    }
}
