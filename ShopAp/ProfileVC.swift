//
//  ProfileVC.swift
//  ShopAp
//
//  Created by mr Yacine on 1/12/19.
//  Copyright © 2019 mr Yacine. All rights reserved.
//

import UIKit
import FirebaseAuth
import StoreKit

class ProfileVC: UIViewController {
    
    var Profile: [ProfileObject] = []
    var selectedIndex: Int = 0
    let t1 = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Sign_In", comment: "")
    let t2 = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Sign_Out", comment: "")
    
    @IBOutlet weak var CancelBtn: UIBarButtonItem!
    @IBAction func CancelBarButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var topView: UIView!
    //@IBOutlet weak var SignoutButton: UIButton!
    
    @IBOutlet weak var SignBtn: XButton!
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var tableView: UITableView! { didSet { tableView.delegate = self; tableView.dataSource = self } }
    
    @IBAction func SignOut(_ sender: UIButton) {
        
        switch sender.titleLabel?.text {
        case t1:
            performSegue(withIdentifier: "sign", sender: nil)
        case t2:
            sender.setTitle("SignIn", for: .normal)
            try? Auth.auth().signOut()
        //self.navigationController?.dismiss(animated: true, completion: nil)
        default:
            break
            //dismiss(animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.tableView.tableHeaderView = topView
        SetUpProfile()
        self.TitleLbl.text = Profile[0].Name
        CancelBtn.config(title: "Cancel")
        Auth.auth().addStateDidChangeListener { (Auth, User) in
            if User != nil{
                self.SignBtn.setTitle(self.t2, for: .normal)
            } else {
                self.SignBtn.setTitle(self.t1, for: .normal)
            }
        }
    }
    
    func SetUpProfile() {
        let t2 = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Profile", comment: "")
        let t3 = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Contact", comment: "")
        let t4 = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Add_Product", comment: "")
        let t5 = LocalizationSystem.sharedInstance.localizedStringForKey(key: "stop", comment: "")
        let t6 = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Rate", comment: "")
        
        Profile.append(ProfileObject(Name: t2, Icon: #imageLiteral(resourceName: "email"), Action: {
            self.performSegue(withIdentifier: "User", sender: nil)
        }))
        Profile.append(ProfileObject(Name: t3, Icon: #imageLiteral(resourceName: "contact"), Action: {
            self.performSegue(withIdentifier: "Contact", sender: nil)
        }))
        Profile.append(ProfileObject(Name: t4, Icon: #imageLiteral(resourceName: "New"), Action: {
            self.performSegue(withIdentifier: "AddProduct", sender: nil)
        }))
        Profile.append(ProfileObject(Name: t5, Icon: #imageLiteral(resourceName: "stop"), Action: {
            self.performSegue(withIdentifier: "stop", sender: nil)
            
        }))
        Profile.append(ProfileObject(Name: t6, Icon: #imageLiteral(resourceName: "rate"), Action: {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            } else {
                // Fallback on earlier versions
            }
        }))
    }
    
    /********************************Gradient Colors*****************/
    
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Profile.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProfileTableViewCell
        cell.Update(Profile: Profile[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Profile[indexPath.row].Action()
        self.TitleLbl.text = Profile[indexPath.row].Name
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
