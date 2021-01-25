//
//  ResetPasswordVC.swift
//  ShopAp
//
//  Created by mr Yacine on 11/25/18.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import UIKit
import FirebaseAuth

class ResetPasswordVC: UIViewController {

    @IBOutlet weak var layout: NSLayoutConstraint!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SubmitBtn.config(title: "Submit")
        self.EnterEmailLbl.config(text: "Enter_Email")
        self.emailTextField.config(placeHolder: "Email")
        SettingUpKeyboardNotification()
    }
    
    // Resset Password
    
    @IBOutlet weak var EnterEmailLbl: UILabel!
    @IBOutlet weak var emailTextField : UITextField!
    @IBOutlet weak var SubmitBtn: XButton!
    
    @IBAction func resetPassword(sender : XButton){
        guard let email = emailTextField.text else {return}
        Auth.auth().sendPasswordReset(withEmail: email) { (Error) in
            if let error = Error {
                MessageBoxShow.Show(FirError.Error(Code: error._code))
            } else {
                MessageBoxShow.Show(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Send_Reset_Password", comment: ""))
                self.emailTextField.text = ""
            }
        }
    }

}

extension ResetPasswordVC {
    
    func SettingUpKeyboardNotification(){
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(ResetPasswordVC.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(ResetPasswordVC.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow (notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3) {
                self.layout.constant = keyboardSize.height
                self.view.layoutIfNeeded()
            }
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        UIView.animate(withDuration: 0.3){
            self.layout.constant = 500
            self.view.layoutIfNeeded()
        }
    }
    
}
