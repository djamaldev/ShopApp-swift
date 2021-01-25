//
//  SettingsVC.swift
//  ShopAp
//
//  Created by mr Yacine on 12/25/18.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import UIKit
import Firebase
import StoreKit
import GoogleMobileAds
import AudioToolbox

class SettingsVC: UIViewController {
    
    var admin = false
    @IBAction func imagePressed(_ sender: UITapGestureRecognizer) {
        Auth.auth().addStateDidChangeListener { (auth, User) in
            if let userid = User?.uid {
                MessageBoxShow.Show(userid)
                UIPasteboard.general.string = userid
            }
        }
    }
    
    @IBOutlet weak var ShareBtn: XButton!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var RateAppBtn: XButton!
    @IBOutlet weak var LanguageBtn: XButton!
    @IBOutlet weak var superAdminButton: UIButton!
    @IBOutlet weak var sectionButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.RateAppBtn.config(title: "Rate")
        self.LanguageBtn.config(title: "Language")
        self.superAdminButton.config(title: "Admin")
        self.sectionButton.config(title: "Section")
        self.ShareBtn.config(title: "Share_app")
        AdminSutUp()
        SuperAdminSutUp()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //currentVc = self
    }
    
    func AdminSutUp(){
        self.sectionButton.isHidden = true
        self.sectionButton.alpha = 0
        Admin.IsAdmin {
            //self.admin = true
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5, animations: {
                    self.sectionButton.isHidden = false
                    self.sectionButton.alpha = 1
                })
            }
        }
        
    }
    
    func SuperAdminSutUp(){
        self.superAdminButton.isHidden = true
        self.superAdminButton.alpha = 0
        Admin.IsSuperAdmin {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5, animations: {
                    self.superAdminButton.isHidden = false
                    self.superAdminButton.alpha = 1
                })
            }
        }
        
    }
    @IBAction func RateButton(_ sender: XButton) {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func ShareButton(_ sender: Any) {
        let message = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Message-To_Share", comment: "")
        let image = UIGraphicsGetImageFromCurrentImageContext()
        let objectsToShare = [message, image ?? #imageLiteral(resourceName: "Shopping")] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        activityVC.popoverPresentationController?.sourceView = sender as? UIView
        self.present(activityVC, animated: true, completion: nil)
    }
    
}
