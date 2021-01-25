//
//  ContactVC.swift
//  ShopAp
//
//  Created by mr Yacine on 1/15/19.
//  Copyright © 2019 mr Yacine. All rights reserved.
//

import UIKit

class ContactVC: XViewController{
    
    var contact: [contactObject] = []
    
    
    @IBOutlet weak var tableView: UITableView! { didSet{ tableView.delegate = self; tableView.dataSource = self } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        UpdateContact()
        //PutGradientBG()
    }
    
    func UpdateContact(){
        let t1 = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Mail", comment: "")
        let t2 = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Call", comment: "")
        let t3 = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Twitter", comment: "")
        contact.append(contactObject(Name: t1, Icon: #imageLiteral(resourceName: "sendMail"), Action: {
            let appURL = URL(string: "mailto:\("seurdjimo@gmail.com")")!
            let application = UIApplication.shared
            if application.canOpenURL(appURL) {
                UIApplication.shared.open(appURL, options: [:] , completionHandler: nil)
            }
        }))
        
        contact.append(contactObject(Name: t2, Icon: #imageLiteral(resourceName: "call"), Action: {
            let numberPhone = "+213781055688"
            let appURL = URL(string: "tel://\(numberPhone)")!
            let application = UIApplication.shared
            if application.canOpenURL(appURL) {
                UIApplication.shared.open(appURL, options: [:] , completionHandler: nil)
            }
        }))
        
        contact.append(contactObject(Name: t3, Icon: #imageLiteral(resourceName: "twitter"), Action: {
            let TwitterUserName = "@NalticeD"
            let appURL = URL(string: "twitter://user?screen_name=\(TwitterUserName)")!
            let webURL = URL(string: "https://twitter.com/\(TwitterUserName)")!
            let application = UIApplication.shared
            if application.canOpenURL(appURL) {
                UIApplication.shared.open(appURL, options: [:] , completionHandler: nil)
            }
            else {
                UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
            }
        }))
    }
    
    /********************************Gradient Colors*****************/
    
    let layer = CAGradientLayer()
    func PutGradientBG() {
        //let FirstColor = UIColor(red: 255.0/255.0, green: 116.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        let FirstColor = UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 191.0/255.0, alpha: 1.0)
        let SecondColor = UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        //let thirdColor = UIColor(red: 246.0/255.0, green: 79.0/255.0, blue: 89.0/255.0, alpha: 1.0)
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
    
    /********************************************************************************************/
}

extension ContactVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contact.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ContactTableViewCell
        cell.Update(contact: contact[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contact[indexPath.row].Action?()
    }
    
}
