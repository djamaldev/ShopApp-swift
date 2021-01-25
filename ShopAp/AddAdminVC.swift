//
//  AddAdminVC.swift
//  ShopAp
//
//  Created by mr Yacine on 12/26/18.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import UIKit

class AddAdminVC: UIViewController {

    @IBOutlet weak var SubmitBtn: XButton!
    @IBOutlet weak var AddAdminIDTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.AddAdminIDTextField.config(placeHolder: "Admin_id")
        self.SubmitBtn.config(title: "Submit")
        // Do any additional setup after loading the view.
    }
    @IBAction func done(_ sender: XButton) {
        userApi.getUser(with: AddAdminIDTextField.text!) { (user: userObject?) in
            if let theUser = user, let userName = theUser.Name {
                AdminObject(ID: self.AddAdminIDTextField.text!, Name: userName, Stamp: Date().timeIntervalSince1970).Upload()
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
}
