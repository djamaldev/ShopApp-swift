//
//  AdminSectionsVC.swift
//  ShopAp
//
//  Created by mr Yacine on 12/23/18.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import UIKit

class AdminSectionsVC: UIViewController {
    var RefreshContoller: UIRefreshControl!
    
    @IBOutlet weak var SectionItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    var Section: [sectionObject] = []{
        didSet {
            Section = Section.sorted(by: {
                guard let one = $0.Stamp, let two = $1.Stamp else {return true}
                return one > two
            })
    }
}
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SectionItem.config(title: "Section")
        tableView.register(UINib(nibName: "AdminSectionsTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        GetData()
        RefreshContoller = UIRefreshControl()
        RefreshContoller.addTarget(self, action: #selector(AdminSectionsVC.Restart), for: .valueChanged)
        RefreshContoller.tintColor = UIColor.red
        tableView.addSubview(RefreshContoller)
    }
    
    @objc func Restart(){
        Section = []
        tableView.reloadData()
        GetData()
    }
    
    func GetData(){
        SectionAPI.getSection { (section: [sectionObject]) in
            self.Section = section
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.RefreshContoller.endRefreshing()
            }
        }
    }

}

extension AdminSectionsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Section.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AdminSectionsTableViewCell
        cell.update(section: Section[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            self.Section[indexPath.row].remove()
            self.Section.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
