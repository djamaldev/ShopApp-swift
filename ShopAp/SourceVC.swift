//
//  SourceVC.swift
//  ShopAp
//
//  Created by mr Yacine on 5/9/19.
//  Copyright © 2019 mr Yacine. All rights reserved.
//

import UIKit
import WebKit

class SourceVC: UIViewController {
    
    @IBOutlet weak var webKit: WKWebView!
    
    var article: Articl?
    static var shared = SourceVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //LoadWebSite()
        OpenUrl(url: article!.urlSource)
    }
    
    /*func LoadWebSite(url: String){
        if let theuUrl = URL(string: url){
            let request = URLRequest(url: theuUrl)
            webKit.load(request)
        }
    }*/
    
    func LoadWebSite(){
        let url = URL(string: article!.urlSource)
        let request = URLRequest(url: url!)
        webKit.load(request)
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
