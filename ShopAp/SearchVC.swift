//
//  SearchVC.swift
//  ShopAp
//
//  Created by mr Yacine on 12/26/18.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    var Product: [productObject] = []
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var CancelBtnBar: UIBarButtonItem!
    @IBOutlet weak var NameNavigationItem: UINavigationItem!
    @IBOutlet weak var SearchBtn: UIButton!
    
    @IBOutlet weak var TableView: UITableView! { didSet { TableView.delegate = self; TableView.dataSource = self } }
    
    
    @IBAction func CancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTextField.config(placeHolder: "Search")
        self.CancelBtnBar.config(title: "Search")
        self.NameNavigationItem.config(title: "Search")
        TableView.register(UINib(nibName: "productTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
       // PutGradientBG()

    }

    @IBAction func SearchButtonAction(_ sender: UIButton) {
        search()
    }
    
    func search(){
        self.view.endEditing(true)
        Restart()
        ProductAPI.SearchFor(Text: searchTextField.text!.lowercased()) { (product: productObject) in
            var goORnot = true
            for one in self.Product {
                if one.ID == product.ID{
                    goORnot = false
                }
            }
            if goORnot {
                self.Product.append(product)
                DispatchQueue.main.async {
                    self.TableView.reloadData()
                }
            }
        }
    }
    
    func Restart(){
        self.Product = []
        self.TableView.reloadData()
    }
    
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Product.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! productTableViewCell
        cell.update(Product: Product[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ResultSearch", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let next = segue.destination as? ProductVC {
            if let indexRow = sender as? Int {
                next.theProduct = Product[indexRow]
            }
        }
    }
}
