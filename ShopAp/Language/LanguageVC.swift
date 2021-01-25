//
//  LanguageVC.swift
//  ShopAp
//
//  Created by mr Yacine on 4/10/19.
//  Copyright © 2019 mr Yacine. All rights reserved.
//

import UIKit

class LanguageVC: UIViewController {
    var window: UIWindow?
    
    @IBOutlet weak var EnglishButton: UIButton!
    
    @IBOutlet weak var ArabicButton: UIButton!
    @IBOutlet weak var LanguageItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EnglishButton.config(title: "En_Lang")
        ArabicButton.config(title: "Ar_Lang")
        LanguageItem.config(title: "Language")
    }
    
    @IBAction func English(_ sender: Any) {
        if LocalizationSystem.sharedInstance.getLanguage() == "ar"{
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
        }else{
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "ar")
        }
        //LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
        let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Change_Lang", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Restart_app", comment: ""), preferredStyle: .alert)
        
        //alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Yes", comment: ""), style: .default, handler: { (action) in
            exit(0)
            //self.storyboard?.instantiateViewController(withIdentifier: "Lang")
        }))
        alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "No", comment: ""), style: .cancel, handler: { (action) in
            //LocalizationSystem.sharedInstance.setLanguage(languageCode: "ar")
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true)
        //exit(0)
    }
    
    @IBAction func Arabic(_ sender: Any) {
        if LocalizationSystem.sharedInstance.getLanguage() == "en"{
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "ar")
            //UIView.appearance().semanticContentAttribute = .forceLeftToRight
            //self.menuSide = .right
        }else{
           LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
        }
        //LocalizationSystem.sharedInstance.setLanguage(languageCode: "ar")
        let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Change_Lang", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Restart_app", comment: ""), preferredStyle: .alert)
        
        //alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Yes", comment: ""), style: .default, handler: { (action) in
            exit(0)
            //self.storyboard?.instantiateViewController(withIdentifier: "Lang")
        }))
        alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "No", comment: ""), style: .cancel, handler: { (action) in
            //LocalizationSystem.sharedInstance.setLanguage(languageCode: "ar")
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true)
        //exit(0)
    }
}
