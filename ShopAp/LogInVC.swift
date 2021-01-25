//
//  LogInVC.swift
//  ShopAp
//
//  Created by mr Yacine on 11/24/18.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInVC: UIViewController {

    @IBOutlet weak var BottomLayout: NSLayoutConstraint!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        self.CancelBtn.config(title: "Cancel")
        self.SignInBtn.config(title: "Sign_In")
        self.ResetPaswBtn.config(title: "Reset_Passw")
        self.RegisterBtn.config(title: "create_one")
        self.emailTextField.config(placeHolder: "Email")
        super.viewDidLoad()
        SettingUpKeyboardNotification()
        //PutGradientBG()
    }
    
    @IBAction func CancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //// Sing In
    
    @IBOutlet weak var emailTextField : UITextField!
    @IBOutlet weak var passwordTextField : UITextField!
    @IBOutlet weak var CancelBtn: UIButton!
    @IBOutlet weak var SignInBtn: XButton!
    @IBOutlet weak var ResetPaswBtn: UIButton!
    @IBOutlet weak var RegisterBtn: UIButton!
    
    @IBAction func signIn(sender : XButton){
        guard let email = emailTextField.text, let password = passwordTextField.text else {return}
        Auth.auth().signIn(withEmail: email, password: password) { (user, Error) in
            if let error = Error {
               MessageBoxShow.Show(FirError.Error(Code: error._code))
                return
            }
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    //*************** Gradiend Colors **********//
    
    let layer = CAGradientLayer()
    func PutGradientBG() {
        let FirstColor = UIColor(red: 255.0/255.0, green: 116.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        let SecondColor = UIColor(red: 254.0/255.0, green: 88.0/255.0, blue: 71.0/255.0, alpha: 1.0)
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
    
    //******************************************//
}

extension LogInVC {
    
    func SettingUpKeyboardNotification(){
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(LogInVC.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(LogInVC.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow (notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3) {
                self.BottomLayout.constant = keyboardSize.height - 8
                self.view.layoutIfNeeded()
            }
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        UIView.animate(withDuration: 0.3){
            self.BottomLayout.constant = 150
            self.view.layoutIfNeeded()
        }
    }
    
}
