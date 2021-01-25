//
//  UserInfoVC.swift
//  ShopAp
//
//  Created by mr Yacine on 1/14/19.
//  Copyright © 2019 mr Yacine. All rights reserved.
//

import UIKit
import FirebaseAuth

class UserTableViewCell: UITableViewCell{
    
}

class tableView1: UITableViewCell{
    @IBOutlet weak var lable1: UILabel!
    @IBOutlet weak var lable2: UILabel!
}

class UserInfoVC: XViewController {
    
    var Contact: [contactObject] = []
    var RefreshContoller: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!{ didSet { tableView.delegate = self; tableView.dataSource = self } }
    @IBOutlet weak var tableView1: UITableView!{ didSet { tableView1.delegate = self; tableView1.dataSource = self } }
    
    //tableView1.rowHeight = UITableView.automaticDimension
    //tableView1.estimatedRowHeight = 60
    
    
    @IBAction func CancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView1.register(UINib(nibName: "AccountTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        GetData()
        RefreshContoller = UIRefreshControl()
        RefreshContoller.addTarget(self, action: #selector(UserInfoVC.refreshAction), for: .valueChanged)
        RefreshContoller.tintColor = UIColor.red
        tableView.addSubview(RefreshContoller)
        contact()
    }
    
    func GetData(){
        Auth.auth().addStateDidChangeListener { (Auth, User) in
            guard let id = User?.uid else {return}
            userApi.getUser(with: id, completion: { (User: userObject) in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.RefreshContoller.endRefreshing()
                }
            })
        }
    }
    
    @objc func refreshAction(){
        tableView.reloadData()
        GetData()
    }
    
    func contact(){
        let t1 = LocalizationSystem.sharedInstance.localizedStringForKey(key: "My_Adver", comment: "")
        let t2 = LocalizationSystem.sharedInstance.localizedStringForKey(key: "My_Favorit", comment: "")
        Contact.append(contactObject(Name: t1, Icon: #imageLiteral(resourceName: "Advertising"), Action: {
            self.performSegue(withIdentifier: "MyAdversting", sender: nil)
        }))
        Contact.append(contactObject(Name: t2, Icon: #imageLiteral(resourceName: "favorite"), Action: {
            self.performSegue(withIdentifier: "Favorite", sender: nil)
      //
    }))
    }

}

extension UserInfoVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var a : Int?
        if tableView == self.tableView{
        a = 1
        }
        if tableView == self.tableView1 {
            a = Contact.count
        }
        return a!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellToReturn = UITableViewCell()
        if tableView == self.tableView{
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserInfo", for: indexPath) as! UserTableViewCell
        Auth.auth().addStateDidChangeListener { (Auth, User) in
            if User?.uid == nil{
                cell.textLabel?.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Loading", comment: "")//"Chargement..."
                cell.detailTextLabel?.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Loading", comment: "")//"Chargement..."
            } else {
            guard let id = User?.uid else {return}
            userApi.getUser(with: id, completion: { (User: userObject) in
                cell.textLabel?.text = User.Name
                cell.detailTextLabel?.text = User.Email
            })
            }
        }
        cellToReturn = cell
        }
        if tableView == self.tableView1{
           let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AccountTableViewCell
           cell.update(Contact: Contact[indexPath.row])
            cellToReturn = cell
        }
      return cellToReturn
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView1{
            Contact[indexPath.row].Action!()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
