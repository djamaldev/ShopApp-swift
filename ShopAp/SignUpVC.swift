//
//  SignUpVC.swift
//  ShopAp
//
//  Created by mr Yacine on 11/24/18.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import UIKit
import FirebaseAuth
//import PhoneNumberKit

class SignUpVC: UIViewController {
    
    @IBOutlet weak var BottomLayout: NSLayoutConstraint!
    var isSuccess: Bool = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SignInBtn.config(title: "have_account")
        self.RegisterBtn.config(title: "Sign")
        self.emailTextField.config(placeHolder: "Email")
        self.nameTextField.config(placeHolder: "Name")
        phoneTextField.becomeFirstResponder()
        SettingUpKeyboardNotification()
        phoneTextField.setFormatting("+###########", replacementChar: "#")
    }
    
    @IBAction func ToSigIn(sender: XButton) {
        navigationController?.popViewController(animated: true)
    }
    
    //// Autontification
    
    @IBOutlet weak var SignInBtn: UIButton!
    @IBOutlet weak var RegisterBtn: XButton!
    @IBOutlet weak var nameTextField : UITextField!
    @IBOutlet weak var emailTextField : UITextField!
    @IBOutlet weak var passwordTextField : UITextField!
    @IBOutlet weak var phoneTextField: VSTextField!
    
    @IBAction func SignUpButton(sender: XButton){
        if nameTextField.text == "" || phoneTextField.text == "" || emailTextField.text == "" || passwordTextField.text == "" {
            MessageBoxShow.Show(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Enter_all_field", comment: ""))
        } else{
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text, let phone = phoneTextField.text else {return}
        Auth.auth().createUser(withEmail: email, password: password) { (User, Error) in
            if let user = User?.user.uid {
                userObject(ID: user, Name: name, Age: nil, Job: nil, Email: email, Stamp: Date().timeIntervalSince1970, ProfileImage: nil, phoneNumber: phone).Upload()
            }
            if let error = Error {
                MessageBoxShow.Show(FirError.Error(Code: error._code))
                return
            }
            MessageBoxShow.Show(LocalizationSystem.sharedInstance.localizedStringForKey(key: "success_signed", comment: ""))
            self.performSegue(withIdentifier: "sign", sender: nil)
        }
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

extension SignUpVC {
    
    func SettingUpKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpVC.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpVC.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow (notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3) {
                self.BottomLayout.constant = keyboardSize.height + 6
                self.view.layoutIfNeeded()
            }
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        UIView.animate(withDuration: 0.3){
            self.BottomLayout.constant = 170
            self.view.layoutIfNeeded()
        }
    }
    
}
