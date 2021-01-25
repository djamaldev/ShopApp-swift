//
//  ProductVC.swift
//  ShopAp
//
//  Created by mr Yacine on 12/20/18.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import UIKit
import Cosmos
import BSImagePicker
import FirebaseAuth
import Firebase

class ProductVC: UITableViewController {
    var theProduct: productObject!
    var Images: [String] = []
    var Img: [UIImage] = []
    var tableContentOffSet: CGFloat = 300
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var sectionNameLable: UILabel!
    @IBOutlet weak var userNameLable: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLable: UILabel!
    @IBOutlet weak var RatingLable: UILabel!
    @IBOutlet weak var CallOwnrUserBtn: XButton!
    @IBOutlet weak var RteBtnBarItem: UIBarButtonItem!
    
    @IBAction func RateBarButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "RateProduct", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let next = segue.destination as? RateProductVC {
            next.theProduct = self.theProduct
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!{ didSet {collectionView.delegate = self; collectionView.dataSource = self } }
    @IBOutlet weak var CosmosView: CosmosView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.CallOwnrUserBtn.config(title: "Call_user")
        self.RteBtnBarItem.config(title: "Rate_Product")
        theProduct.getRate { (Value: Int) in
            self.CosmosView.rating = Double(Value)
            if let ratingcount = self.theProduct.RatingCount{
                self.RatingLable.text = "(" + String(describing: ratingcount) + ")"
               // self.RatingLable.isHidden = false
            }
        }
        collectionView.register(UINib(nibName: "imageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        if let ownerUserId = theProduct.OwnerUserID {
            userApi.getUser(with: ownerUserId) { (User: userObject) in
                DispatchQueue.main.async {
                    self.userNameLable.text = User.Name
                }
            }
        }
        self.priceLable.text = theProduct.price
        self.nameLable.text = theProduct.Name
        self.dateLable.text = theProduct.Stamp?.getTimeAgo()
        if let sectionID = theProduct.SectionID {
            if let savedSection = SectionAPI.getSectionfrom(sectionID: sectionID){
                self.sectionNameLable.text = savedSection.Name
            }
        }

        self.userNameLable.text = theProduct.OwnerUserID
        self.textView.text = theProduct.Description
        if let images = theProduct.Image{
            self.Images = images
        }
        if theProduct.Image!.count > 0 {
            if let strURL = theProduct.Image?[0]{
                if let url = URL(string: strURL){
                    imageView.sd_setImage(with: url, completed: nil)
                }
            }
        }
        self.tableView.tableHeaderView = headerView
        self.tableView.tableFooterView = footerView
        self.title = theProduct.Name
        
        textViewChangeSise()
    }
    
    func callPhone(Number: String){
        guard let number = URL(string: "telprompt://" + Number) else {return}
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(number, options: [:], completionHandler: nil)
        } else {
            if let url = URL(string: "tel://\(Number)"){
                UIApplication.shared.openURL(url)
            }
        }
        
    }
    
    //*********************** ADD To Favorite ************************************
    
    @IBAction func AddToFavorite(_ sender: UIButton) {
        self.theProduct.FavoriteProduct()
        MessageBoxShow.Show(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Add_Fav_Product", comment: ""))
    }
    
    //****************************************************************************
    @IBAction func callUser(sender: XButton){
        if let ownerUserId = theProduct.OwnerUserID {
            userApi.getUser(with: ownerUserId) { (User: userObject) in
                DispatchQueue.main.async {
                    if  let phone = User.phoneNumber {
                        //self.callPhone(Number: phone)
                        phone.makeAColl()
                    }
                }
            }
        }
    }
    
    // *********************Strechy Header Image*********************//
    func updateHeaderImageSise(){
        var extraHeight: CGFloat = 0
        if let tabBar = tabBarController?.tabBar {
            extraHeight = tabBar.frame.size.height + 10
        }
        self.headerView.frame.origin.y = -tableContentOffSet + 300 + extraHeight
        headerView.frame.size.height = tableContentOffSet
        self.view.layoutIfNeeded()
        self.tableView.layoutIfNeeded()
    }
    
    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.tableContentOffSet = 300 - scrollView.contentOffset.y
        updateHeaderImageSise()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeaderImageSise()
    }
    // ********************************fin header Image*******************//
    
    func textViewChangeSise(){
        let fixedWith = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWith, height: CGFloat.greatestFiniteMagnitude))
        let newSise = textView.sizeThatFits(CGSize(width: fixedWith, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSise.width, fixedWith), height: newSise.height)
        var tempHighnt : CGFloat = 100
        for one in footerView.subviews{
            if (one is UITextView) == false {
                tempHighnt += CGFloat(one.frame.size.height)
            }
        }
        footerView.frame.size.height = tempHighnt + newFrame.size.height
        tableView.layoutIfNeeded()
    }
    
    
}

extension ProductVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! imageCollectionViewCell
        cell.update(url: Images[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = URL(string: Images[indexPath.row]){
            self.imageView.sd_setImage(with: url, completed: nil)
        }
    }
    
}

extension String {
    
    enum RegularExpressions: String {
        case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    }
    
    func isValid(regex: RegularExpressions) -> Bool {
        return isValid(regex: regex.rawValue)
    }
    
    func isValid(regex: String) -> Bool {
        let matches = range(of: regex, options: .regularExpression)
        return matches != nil
    }
    
    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter{CharacterSet.decimalDigits.contains($0)}
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
    
    func makeAColl() {
        if isValid(regex: .phone) {
            if let url = URL(string: "tel://\(self.onlyDigits())"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
}
