//
//  AppVC.swift
//  ShopAp
//
//  Created by mr Yacine on 11/27/18.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import UIKit
import FirebaseAuth
import Network
import GoogleMobileAds

class homeVC: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate {
    
    @IBOutlet weak var collectionShop: UICollectionView! {
        didSet {
            collectionShop.delegate = self
            collectionShop.dataSource = self
        }
    }
    
    //var strButton: [String] = ["Amazon","flipkart","eBay"]
    //var btnArray: [UIButton] = []
    var shopObj: [ShopObject] = []
    
    @IBOutlet var adBannerView: GADBannerView!
    var selectedIndex: Int = 0
    var Section: [sectionObject] = []
    //var adBannerView: GADBannerView = GADBannerView()
    var interstitial: GADInterstitial!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBAction func AuthBarButton(_ sender: UIBarButtonItem) {
        Auth.auth().addStateDidChangeListener { (Auth, User) in
            if User == nil{
                self.performSegue(withIdentifier: "Auth", sender: nil)
            } else {
                self.performSegue(withIdentifier: "connected", sender: nil)
            }
        }
    }
    
    @IBOutlet var sectionCollectionView: UIView!
    @IBOutlet weak var collectionView: UICollectionView! { didSet{collectionView.delegate = self; collectionView.dataSource = self}}
    
    var isAdmin: Bool = false
    var RefreshContoller: UIRefreshControl!
    var products: [productObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
 /////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// Implement AD MOB /////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        adBannerView.adUnitID = "ca-app-pub-7106415214207784/5254000689"
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-7106415214207784/3775545282")
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        interstitial.delegate = self
        let request = GADRequest()
        //request.testDevices = ["2077ef9a63d2b398840261c8221a0c9b"]//[kGADSimulatorID]
        //req.testDevices = [ kGADSimulatorID, "2077ef9a63d2b398840261c8221a0c9b" ]
        adBannerView.load(request)
        interstitial.load(request)
        
 /////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////  FIN AD MOB /////////////////////////////////////////////////////////////
        
        let AlertOnce = UserDefaults.standard
        if(!AlertOnce.bool(forKey: "oneTimeAlert")){
            let alert = UIAlertController(title: "Thanks:", message: "Thanks you for shoosing BassmaShop. Please share this App with your friends and Enjoy.", preferredStyle: UIAlertController.Style.alert)
            let Show = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { (action:UIAlertAction) in
                AlertOnce.set(true , forKey: "oneTimeAlert")
                AlertOnce.synchronize()
            }
            alert.addAction(Show)
            self.present(alert, animated: true, completion: nil)
        }
        Admin.IsAdmin {
            self.isAdmin = true
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        tableView.register(UINib(nibName: "productTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        collectionView.register(UINib(nibName: "LabelSectionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        getSection()
        GetData()
        RefreshContoller = UIRefreshControl()
        RefreshContoller.addTarget(self, action: #selector(homeVC.refreshAction), for: .valueChanged)
        RefreshContoller.tintColor = UIColor.red
        tableView.addSubview(RefreshContoller)
        self.tableView.tableHeaderView = adBannerView
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(homeVC.refreshAction), name: NSNotification.Name(rawValue: "ProductAdded"), object: nil)
        setImg()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //currentVc = self
    }

    @objc func refreshAction(){
        products = []
        tableView.reloadData()
        GetData()
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////Implement Even AD Goolgle Mob//////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        if ad.isReady {
            interstitial!.present(fromRootViewController: self)
        }
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////// Fin Implement Even AD Goolgle Mob  ////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
    var selectedSection: sectionObject?
    func GetData(){
        //self.Section[0].Name = "All"
        guard let section = selectedSection else {GetAllData(); return}
        if section.Name == "الكل" || section.Name == "All"{
           GetAllData()
        }
        ProductAPI.getProductFor(Section: section, lastStamp: products.count > 0 ? products[products.count - 1].Stamp : nil) { (products: [productObject]) in
            self.products = products
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.RefreshContoller.endRefreshing()
            }
        }
    }
    func GetAllData(){
        ProductAPI.getAllProducts(lastStamp: products.count > 0 ? products[products.count - 1].Stamp : nil) { (products: [productObject]) in
            self.products = products
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.RefreshContoller.endRefreshing()
            }
        }
    }
    func getSection(){
        //let t1: String?
        self.Section = SectionCaches.getSection()
        self.collectionView.reloadData()
        /*if self.Section.count > 0 && self.selectedSection == nil{
            self.selectedSection = self.Section[0]
        }*/
            SectionAPI.getSection { (section: [sectionObject]) in
                self.Section = section
                self.TranslateSection()
                if self.Section.count > 0 && self.selectedSection == nil{
                    self.selectedSection = self.Section[0]
                }
                SectionCaches.AddSection(section: self.Section)
                //self.TranslateSection()
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        
    }
    
    func setImg(){
        shopObj.append(ShopObject(img: #imageLiteral(resourceName: "eBay")))
        shopObj.append(ShopObject(img: #imageLiteral(resourceName: "Amazon")))
        shopObj.append(ShopObject(img: #imageLiteral(resourceName: "Unknown")))
        shopObj.append(ShopObject(img: #imageLiteral(resourceName: "jumia")))
        shopObj.append(ShopObject(img: #imageLiteral(resourceName: "images")))
    }
    
    func TranslateSection(){
        if LocalizationSystem.sharedInstance.getLanguage() == "en"{
            for one in self.Section {
                if one.Name == "الكل"{
                    one.Name = LocalizationSystem.sharedInstance.localizedStringForKey(key: "All", comment: "")
                }
                if one.Name == "سيارات"{
                    one.Name = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Car", comment: "")
                }
                if one.Name == "تقنيات"{
                    one.Name = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Technic", comment: "")
                }
                if one.Name == "خدمات متعددة"{
                    one.Name = LocalizationSystem.sharedInstance.localizedStringForKey(key: "All_service", comment: "")
                }
                if one.Name == "طلبات عمل"{
                    one.Name = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Job", comment: "")
                }
                if one.Name == "عقارات"{
                    one.Name = LocalizationSystem.sharedInstance.localizedStringForKey(key: "real_estates", comment: "")
                }
            }
            //LocalizationSystem.sharedInstance.localizedStringForKey(key: "All", comment: "")
        }
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

extension homeVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! productTableViewCell
        cell.update(Product: products[indexPath.row])
        cell.transform = CGAffineTransform(translationX: self.view.frame.size.width, y: 0)
        UIView.animateKeyframes(withDuration: 0.3, delay: TimeInterval(indexPath.row) * 0.3, options: [], animations: {
            cell.transform = CGAffineTransform.identity
        }, completion: nil)
        cell.ImageAnimationBlock = {
            cell.ImageView.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
            UIView.animateKeyframes(withDuration: 0.3, delay: TimeInterval(indexPath.row) * 0.7, options: [], animations: {
                cell.ImageView.transform = CGAffineTransform.identity
            }, completion: nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return isAdmin
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            products[indexPath.row].remove()
            products.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showProduct", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let next = segue.destination as? ProductVC {
            if let indexRow = sender as? Int {
                next.theProduct = products[indexRow]
            }
        }
    }
}

extension homeVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
           return self.Section.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LabelSectionCollectionViewCell
            cell.select = (selectedIndex == indexPath.row)
            cell.update(section: Section[indexPath.row])
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            self.selectedIndex = indexPath.row
            self.selectedSection = Section[indexPath.row]
            refreshAction()
            self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.size.height * 1.5, height: collectionView.frame.size.height)
    }
}
