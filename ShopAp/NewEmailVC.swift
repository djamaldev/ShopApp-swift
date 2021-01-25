//
//  NewEmailVC.swift
//  ShopAp
//
//  Created by mr Yacine on 1/22/19.
//  Copyright © 2019 mr Yacine. All rights reserved.
//

import UIKit
import FirebaseAuth
import MessageUI

class NewEmailVC: UIViewController,MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate{
    
    @IBOutlet weak var subject: XTextField!
    
    @IBOutlet weak var body: UITextView!
    @IBOutlet weak var SubmitBtn: XButton!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subject.config(placeHolder: "Subject")
        self.SubmitBtn.config(title: "Submit")
        subject.delegate = self
        body.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Name_Product_Inlawfu", comment: "")
        body.textColor = UIColor.lightGray
        body.font = UIFont(name: "verdana", size: 13.0)
        body.returnKeyType = .done
        body.delegate = self
    }
    
    @IBAction func send(_ sender: UIButton) {
        
        let picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self
        
        if let subjectText = subject.text {
            picker.setSubject(subjectText)
        }
        picker.setMessageBody(body.text, isHTML: true)
        
        present(picker, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
    // UITextFieldDelegate
    
    // 2
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    // UITextViewDelegate
    
    // 3
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if body.text == LocalizationSystem.sharedInstance.localizedStringForKey(key: "Name_Product_Inlawfu", comment: "") {
            body.text = ""
            body.textColor = UIColor.black
            body.font = UIFont(name: "verdana", size: 18.0)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        body.text = textView.text
        
        if text == "\n" {
            textView.resignFirstResponder()
            
            //return false
        }
        
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if body.text.isEmpty == true {
            body.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Name_Product_Inlawfu", comment: "")
            body.textColor = UIColor.lightGray
            body.font = UIFont(name: "verdana", size: 13.0)
        }
    }
    
    
}
