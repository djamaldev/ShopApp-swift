//
//  MenuViewController.swift
//  AnimationProject
//
//  Created by mr Yacine on 15/09/2018.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import UIKit
import StoreKit
import FirebaseAuth

class MenuViewController : UIViewController {
    
   /* static var shard = MenuViewController()
    @IBOutlet weak var TableView : UITableView! { didSet { TableView.delegate = self ; TableView.dataSource = self }}
    var array : [ProfileObject] = []
    var IsMenu : Bool = false
    
    @IBOutlet weak var left: NSLayoutConstraint!
    
    @IBOutlet var TopView: UIView!
    
    @IBOutlet weak var TitleLabel: UILabel!
    
    @IBAction func LogOutButton(_ sender: UIButton) {
        
        switch sender.titleLabel?.text {
        case "SignIn":
            performSegue(withIdentifier: "sign", sender: nil)
        case "SignOut":
            sender.setTitle("SignIn", for: .normal)
            try? Auth.auth().signOut()
            //self.navigationController?.dismiss(animated: true, completion: nil)
        default:
            break
            //dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func screenGest(_ sender: UIPanGestureRecognizer) {
        let tr = sender.translation(in: self.view)
        var number1 = (tr.x / 100)
        if sender.state == .began || sender.state == .changed {
            
           // Lable.center = CGPoint(x: Lable.center.x + tr.x, y: Lable.center.y + tr.y)
            
            if number1 > 1 { number1 = 1 }
            if number1 <= 0 { number1 = 0 }
            if IsMenu {
              
            } else {
            left.constant = (self.view.frame.size.width * 0.7) * number1
            self.view.layoutIfNeeded()
            //sender.setTranslation(CGPoint.zero, in: self.view)
            }
        }
        
        if sender.state == .ended {
            if number1 > 0.5 {
                showMenu()
                IsMenu = true
            } else {
                hideMenu()
                IsMenu = false
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewNavBar = UIView(frame: CGRect(
            origin: CGPoint(x: 0, y:0),
            size: CGSize(width: self.view.frame.size.width, height: 10)))
        self.navigationController?.navigationBar.addSubview(viewNavBar)
        
        self.TableView.tableHeaderView = TopView
        self.TableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        SetUPoption()
        self.TitleLabel.text = array[0].Name
        NotificationCenter.default.addObserver(self, selector: #selector(MenuViewController.MenuPressed), name: NSNotification.Name(rawValue: "MenuPressed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MenuViewController.NewVCIsOpening), name: NSNotification.Name(rawValue: "OpenNewVC"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func SetUPoption() {
        
        //var t1 = "Home"
        let t1 = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Home", comment: "")
        let t2 = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Profile", comment: "")
        let t3 = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Contact", comment: "")
        let t4 = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Add_Product", comment: "")
        let t5 = LocalizationSystem.sharedInstance.localizedStringForKey(key: "stop", comment: "")
        let t6 = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Rate", comment: "")
        
        self.array.append(ProfileObject(Name: t1, Icon: #imageLiteral(resourceName: "home"), Gener: .Main, Rate: {
            
        }))
        self.array.append(ProfileObject(Name: t2, Icon: #imageLiteral(resourceName: "Admin"), Gener: .User, Rate: {
            
        }))
        self.array.append(ProfileObject(Name: t3, Icon: #imageLiteral(resourceName: "AddImage"), Gener: .Contact, Rate: {
            
        }))
        self.array.append(ProfileObject(Name: t4, Icon: #imageLiteral(resourceName: "New"), Gener: .AddProduct, Rate: {
            
        }))
        self.array.append(ProfileObject(Name: t5, Icon: #imageLiteral(resourceName: "stop"), Gener: .stop, Rate: {
            
        }))
        self.array.append(ProfileObject(Name: t6, Icon: #imageLiteral(resourceName: "rate"), Gener: .Main, Rate: {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            } else {
                // Fallback on earlier versions
            }
        }))
    }
    @IBOutlet weak var Container: UIView!
    
    @IBAction func MenuAction(_ sender: UIBarButtonItem) {
        RadioClass.ToggleMenu()
        
    }
    
    @objc func MenuPressed() {
        if IsMenu {
            hideMenu()
        }
         else {
            showMenu()
        }
        IsMenu = !IsMenu
    }
    
    func showMenu(){
        left.constant = self.view.frame.size.width * 0.7
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()})
        UIView.animate(withDuration: 0.3) {
            self.Container.transform = CGAffineTransform(scaleX: 0.7, y: 0.7).translatedBy(x: -70, y: 0)
        }
    }
    
    func hideMenu() {
            left.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()})
        UIView.animate(withDuration: 0.3) {
            self.Container.transform = CGAffineTransform.identity
        }
    }
    
    let layer = CAGradientLayer()
    func PutGradientBG() {
        let FirsColor = UIColor.init(red: 255.0/255.0, green: 116.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        let SecondColor = UIColor.init(red: 254.0/255.0, green: 88.0/255.0, blue: 71.0/255.0, alpha: 1.0)
        layer.colors = [FirsColor.cgColor, SecondColor.cgColor]
        layer.zPosition = -1
        self.view.layer.addSublayer(layer)
    }
    
    @objc func NewVCIsOpening() {
        UIView.animate(withDuration: 0.3) {
            self.left.constant = self.left.constant + 200
            self.view.layoutIfNeeded()
        }
        UIView.animate(withDuration: 0.3, delay: 0.4, options: [], animations: {
            //self.hideMenu()
            self.left.constant = self.left.constant - 400
            self.view.layoutIfNeeded()
            if self.IsMenu {
                self.hideMenu()
            }
            self.IsMenu = !self.IsMenu
        }, completion: nil)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resise()
    }
    
    func resise() {
        layer.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
    }
    
}

extension MenuViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ProfileTableViewCell
        if RadioClass.whereAm == array[indexPath.row].Gener {
            cell.update(Profile: array[indexPath.row], selected: true)
        } else {
            cell.update(Profile: array[indexPath.row], selected: false)
        }
        
        cell.TheView.layer.cornerRadius = 70 / 4
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        array[indexPath.row].Action()
        array[indexPath.row].Rate?()
        self.TitleLabel.text = array[indexPath.row].Name
        self.TableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }*/
    
}

class XContainer: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 15
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -5, height: 30)
    }
}










