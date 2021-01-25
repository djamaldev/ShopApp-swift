//
//  SuperAdminVC.swift
//  ShopAp
//
//  Created by mr Yacine on 12/25/18.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import UIKit

class SuperAdminVC: UITableViewController {
    
    @IBOutlet weak var AdminTitle: UINavigationItem!
    var Admins: [AdminObject] = []
    var RefreshContoller: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.AdminTitle.config(title: "Admin")
        tableView.register(UINib(nibName: "AdminTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        GetData()
        RefreshContoller = UIRefreshControl()
        RefreshContoller.addTarget(self, action: #selector(SuperAdminVC.refreshAction), for: .valueChanged)
        RefreshContoller.tintColor = UIColor.red
        self.tableView.addSubview(RefreshContoller)
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(SuperAdminVC.refreshAction), name: NSNotification.Name(rawValue: "AdminAdded"), object: nil)
    }

    func GetData(){
        AdminAPI.GetAdmin { (theAdmin: [AdminObject]) in
            self.Admins = theAdmin
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.RefreshContoller.endRefreshing()
            }
        }
    }
    
    @objc func refreshAction(){
        Admins = []
        self.tableView.reloadData()
        GetData()
    }

}

extension SuperAdminVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Admins.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AdminTableViewCell
        cell.Update(Admin: Admins[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            Admins[indexPath.row].Remove()
            Admins.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
