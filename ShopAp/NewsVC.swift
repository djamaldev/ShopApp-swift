//
//  NewsVC.swift
//  ShopAp
//
//  Created by mr Yacine on 1/16/19.
//  Copyright © 2019 mr Yacine. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class NewsVC: UIViewController {
    var ArticlObj: [Articl] = []
    var product: [productObject] = []
    var RefreshContoller: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView! { didSet { tableView.delegate = self; tableView.dataSource = self } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "productTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        getAllData()
        //getScore()
        RefreshContoller = UIRefreshControl()
        RefreshContoller.addTarget(self, action: #selector(NewsVC.refreshAction), for: .valueChanged)
        RefreshContoller.tintColor = UIColor.red
        tableView.addSubview(RefreshContoller)
    }
    func getAllData(){
        ProductAPI.getAllProducts(lastStamp: product.count > 0 ? product[product.count - 1].Stamp : nil) { (products: [productObject]) in
            self.product = products
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.RefreshContoller.endRefreshing()
            }
        }
    }
    
    @objc func refreshAction(){
        product = []
        tableView.reloadData()
        getAllData()
        //getScore()
    }
    
    func getScore(){
        guard let url = URL(string: baseUrl) else {
            print("Error: cannot create URL")
            return
        }
        Alamofire.request(url)
            .responseJSON { response in
                if response.result.isSuccess{
                    print("ok")
                    let dict: JSON = JSON(response.result.value!)
                    self.update(json: dict)
                    //self.getData(json: dict)
                    print("JSON: \(dict)")
                } else {
                    print("error")
                }
                self.tableView.reloadData()
        }
    }
    var object: Articl?
    func update(json: JSON){
        let JsonObj = json["articles"].arrayValue
        for one in JsonObj{
            let author = one["author"].stringValue
            let title = one["title"].stringValue
            let description = one["description"].stringValue
            let publishedAt = one["publishedAt"].stringValue
            let content = one["content"].stringValue
            let url = one["url"].stringValue
            let urlImg = one["urlToImage"].stringValue
            let obj = Articl(author: author, title: title, description: description, urlSource: url, urlImg: urlImg, publishedAt: publishedAt, content: content)
            ArticlObj.append(obj)
            print(obj)
        }
        self.tableView.reloadData()
    }
    
}

extension NewsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product.count
        //return ArticlObj.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! productTableViewCell
        cell.update(Product: product[indexPath.row])
        //cell.country_name.text = scoreF[indexPath.row].country_name
        /*cell.title_art.text = ArticlObj[indexPath.row].title
        //cell.Descrption_art.text = ArticlObj[indexPath.row].description
        cell.author_art.text = ArticlObj[indexPath.row].author
        //cell.source_art.text = ArticlObj[indexPath.row].urlSource
        cell.content_art.text = ArticlObj[indexPath.row].content
        cell.date_art.text = ArticlObj[indexPath.row].publishedAt
        cell.ImageAnimationBlock = {
            cell.Image_art.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
            UIView.animateKeyframes(withDuration: 0.3, delay: TimeInterval(indexPath.row) * 0.7, options: [], animations: {
                cell.Image_art.transform = CGAffineTransform.identity
            }, completion: nil)
        }
        cell.update(url: ArticlObj[indexPath.row].urlImg)
        cell.Action = {
            //cell.OpenUrl(url: self.ArticlObj[indexPath.row].urlSource)
            //self.performSegue(withIdentifier: "source", sender: indexPath.row)
            self.OpenUrl(url: self.ArticlObj[indexPath.row].urlSource)
        }*/
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "versProduct", sender: indexPath.row)
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let next = segue.destination as? SourceVC {
            if let indexRow = sender as? Int {
                next.article?.urlSource = ArticlObj[indexRow].urlSource
            }
        }
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let next = segue.destination as? ProductVC {
            if let indexRow = sender as? Int {
                next.theProduct = product[indexRow]
            }
        }
    }
    
    func OpenUrl(url: String){
        //let TwitterUserName = "@NalticeD"
        let appURL = URL(string: url)
        //let webURL = URL(string: "https://twitter.com/\(TwitterUserName)")!
        let application = UIApplication.shared
        if application.canOpenURL(appURL!) {
            UIApplication.shared.open(appURL!, options: [:] , completionHandler: nil)
        }
        else {
            //UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
        }
    }
}
