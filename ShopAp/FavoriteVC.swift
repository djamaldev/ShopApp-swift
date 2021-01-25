//
//  FavoriteVC.swift
//  ShopAp
//
//  Created by mr Yacine on 2/6/19.
//  Copyright © 2019 mr Yacine. All rights reserved.
//

import UIKit
import FirebaseAuth

class FavoriteVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView! { didSet { tableView.delegate = self; tableView.dataSource = self } }
    
    var RefreshContoller: UIRefreshControl!
    var products: [productObject] = []
    var Favorite: [FavoriteObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        GetData()
        RefreshContoller = UIRefreshControl()
        RefreshContoller.addTarget(self, action: #selector(FavoriteVC.refreshAction), for: .valueChanged)
        RefreshContoller.tintColor = UIColor.red
        tableView.addSubview(RefreshContoller)
    }
    
    var favorite: FavoriteObject!
    var theProduct: productObject!
    func GetData(){
        Auth.auth().addStateDidChangeListener { (Auth, User) in
            if let userid = User?.uid{
                ProductAPI.getFavoriteFor(userID: userid, completion: { (Prod) in
                    self.products = Prod
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.RefreshContoller.endRefreshing()
                    }
                })
            }
        }
    }
    
    @objc func refreshAction(){
        products = []
        tableView.reloadData()
        GetData()
    }
}

extension FavoriteVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cel = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FavoriteTableViewCell
        cel.update(Product: products[indexPath.row])
        return cel
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            products[indexPath.row].RemovFav()
            products.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showFav", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let next = segue.destination as? ProductVC {
            if let indexRow = sender as? Int {
                next.theProduct = products[indexRow]
            }
        }
    }
    
}
