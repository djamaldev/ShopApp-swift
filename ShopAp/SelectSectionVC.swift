//
//  SelectSectionVC.swift
//  ShopAp
//
//  Created by mr Yacine on 12/23/18.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import UIKit

protocol sectionDelegate {
    func selected(section: sectionObject)
}

class SelectSectionVC: UIViewController {
    
    @IBOutlet weak var SelectSecLbl: UILabel!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
    
    var delegate: sectionDelegate!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    var Section: [sectionObject] = [] {
        didSet {
            Section = Section.sorted(by: {
                guard let one = $0.Stamp, let two = $1.Stamp else {return true}
                return one > two
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SelectSecLbl.config(text: "Shoose_section")
        tableView.register(UINib(nibName: "AdminSectionsTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        GetData()
    }
    
    func GetData(){
        SectionAPI.getSection { (section: [sectionObject]) in
            self.Section = section
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension SelectSectionVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Section.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AdminSectionsTableViewCell
        cell.update(section: Section[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.selected(section: Section[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}
