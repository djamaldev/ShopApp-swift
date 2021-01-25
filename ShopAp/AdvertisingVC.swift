//
//  AdvertisingVC.swift
//  ShopAp
//
//  Created by mr Yacine on 1/15/19.
//  Copyright © 2019 mr Yacine. All rights reserved.
//

import UIKit
import FirebaseAuth

class AdvertisingVC: XViewController {
    
    var product: [productObject] = []
    var theProduct: productObject!
    var isAdmin: Bool = false
    var RefreshContoller: UIRefreshControl!
    
    @IBAction func CancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var tableView: UITableView!{ didSet { tableView.delegate = self; tableView.dataSource = self } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "productTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        getData()
        RefreshContoller = UIRefreshControl()
        RefreshContoller.addTarget(self, action: #selector(AdvertisingVC.refreshAction), for: .valueChanged)
        RefreshContoller.tintColor = UIColor.red
        tableView.addSubview(RefreshContoller)
    }
    
    func getData(){
        Auth.auth().addStateDidChangeListener { (Auth, User) in
            if let userid = User?.uid{
                ProductAPI.getProductForUser(ownerUser: userid, completion: { (Produit: [productObject]) in
                    self.product = Produit
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.RefreshContoller.endRefreshing()
                    }
                })
            }
        }
    }
    
    @objc func refreshAction(){
        product = []
        tableView.reloadData()
        getData()
    }
}

extension AdvertisingVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! productTableViewCell
        cell.update(Product: product[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            product[indexPath.row].remove()
            product.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showAdv", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let next = segue.destination as? ProductVC {
            if let indexRow = sender as? Int {
                next.theProduct = product[indexRow]
            }
        }
    }
}
