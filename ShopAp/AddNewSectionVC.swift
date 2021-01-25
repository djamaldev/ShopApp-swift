//
//  AddNewSectionVC.swift
//  ShopAp
//
//  Created by mr Yacine on 12/23/18.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import UIKit
import BSImagePicker

class AddNewSectionVC: UIViewController {
    var section: sectionObject!
    let vc = BSImagePickerViewController()
    @IBOutlet weak var BottomLayout: NSLayoutConstraint!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var SubmitBtn: XButton!
    @IBOutlet weak var NewSectionItem: UINavigationItem!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBAction func sendSection(sender: XButton){
        self.loading.startAnimating()
        /*guard let img = ImageView.image.map({$0.resize(size: 800)}) else {return}
        img.Upload(Completion: { (theURL: String?) in
            //guard let url = theURL else {return}
            /*sectionObject(ID: UUID().uuidString, Name: self.nameTextField.text!, Stamp: Date().timeIntervalSince1970, Icon: "").upload()*/
            sectionObject(ID: UUID().uuidString, Name: self.nameTextField.text!, Stamp: Date().timeIntervalSince1970).upload()
            //done
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.navigationController?.popViewController(animated: true)
            })
        })*/
        sectionObject(ID: UUID().uuidString, Name: self.nameTextField.text!, Stamp: Date().timeIntervalSince1970).upload()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.navigationController?.popViewController(animated: true)
    })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.config(placeHolder: "Section_Name")
        self.SubmitBtn.config(title: "Submit")
        self.NewSectionItem.config(title: "Add_New_Section")
        vc.maxNumberOfSelections = 1
        SettingUpKeyboardNotification()

        // Do any additional setup after loading the view.
    }
}

import Photos

extension AddNewSectionVC{
    func AddImageAction() {
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
                                            // User selected an asset.
                                            // Do something with it, start upload perhaps?
        }, deselect: { (asset: PHAsset) -> Void in
            // User deselected an assets.
            // Do something, cancel upload?
        }, cancel: { (assets: [PHAsset]) -> Void in
            // User cancelled. And this where the assets currently selected.
        }, finish: { (assets: [PHAsset]) -> Void in
            // User finished with these assets
            let imageArray = assets.map({$0.ToUIImage()})
                DispatchQueue.main.async {
                    self.ImageView.image = imageArray[0]
                }
        }, completion: nil)
    }
}

//KeyBoard

extension AddNewSectionVC {
    
    func SettingUpKeyboardNotification(){
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(AddNewSectionVC.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(AddNewSectionVC.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow (notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var newHight: CGFloat = 0
            if let tabbar = self.tabBarController {
                newHight = tabbar.tabBar.frame.size.height
            }
            self.BottomLayout.constant = keyboardSize.height - newHight
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        self.BottomLayout.constant = 0
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
    }
    
}
