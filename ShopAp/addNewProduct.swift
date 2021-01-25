//
//  addNewProduct.swift
//  ShopAp
//
//  Created by mr Yacine on 11/27/18.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import UIKit
import BSImagePicker
import FirebaseAuth
import Firebase

class addNewProduct: UIViewController, UITextViewDelegate, UIScrollViewDelegate, sectionDelegate {
    
    var theSection: sectionObject?
    func selected(section: sectionObject) {
        ButtonTextField.setTitle(section.Name, for: .normal)
        theSection = section
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let next = segue.destination as? SelectSectionVC {
            next.delegate = self
        }
    }
    
    @IBOutlet weak var sendingButton: XButton!
    //var prod : [productObject] = []
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0){
            view.endEditing(true)
        }
    }
    
    let vc = BSImagePickerViewController()
    
    func textViewDidChange(_ textView: UITextView) {
        textViewChangeSise()
    }

    @IBOutlet weak var BigViewHight : NSLayoutConstraint!
    @IBOutlet weak var BottomLayout : NSLayoutConstraint!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var sectionTextField : UITextField!
    @IBOutlet weak var ButtonTextField: UIButton!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var BigView : UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var DescriptionLbl: UILabel!
    @IBOutlet weak var AddImageBtn: XButton!
    @IBOutlet weak var UploadProductBtn: XButton!
    
    var Images: [UIImage] = []
    var im: UIImage!
    var image1 = UIImage(named: "done")
    var image2 = UIImage(named: "home")
    let store = Uploader()
    var err: String = "errrrrrrr"
    var pe: Double!
    override func viewDidLoad() {
        super.viewDidLoad()
        //PutGradientBG()
        collectionView.register(UINib(nibName: "imageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        txtView.delegate = self
        scrollView.delegate = self
        txtView.isScrollEnabled = false
        self.DescriptionLbl.config(text: "Product_description")
        self.nameTextField.config(placeHolder: "Name_Product")
        self.priceTextField.config(placeHolder: "Price")
        self.ButtonTextField.config(title: "Shoose_section")
        self.AddImageBtn.config(title: "Add_Image_product")
        self.UploadProductBtn.config(title: "Upload_Product")
        SettingUpKeyboardNotification()
        textViewChangeSise()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user?.uid == nil {
                MessageBoxShow.Show(LocalizationSystem.sharedInstance.localizedStringForKey(key: "SinIn_First", comment: ""))
                self.performSegue(withIdentifier: "showsign", sender: nil)
            }
        }
    }
    
    @IBAction func AddImage(sender: XButton){
        AddImageAction()
    }
    
    @IBAction func Done(sender: XButton) {
        if nameTextField.text == "" || priceTextField.text == "" || txtView.text == "" {
            MessageBoxShow.Show(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Enter_all_field", comment: ""))
        } else {
        sender.Loading()
        Uploader.shared.Upload(Images: Images.map({$0.resize(size: 800)}))
        Uploader.shared.DidUploadAll = {
            Auth.auth().addStateDidChangeListener{ (auth, user) in
                if let uid = user?.uid {
                    var imageUrl = Uploader.shared.UploadedImagesURLS
                    guard let name = self.nameTextField.text, let sectionid = self.theSection?.ID, let description = self.txtView.text, let price = self.priceTextField.text else {return}
                    
                    productObject(ID: UUID().uuidString, Name: name, price: price, Stamp: Date().timeIntervalSince1970, SectionID: sectionid, OwnerUserID: uid, Description: description, Image: imageUrl, SmallImage:  imageUrl[0]).Upload()
                        DispatchQueue.main.async {
                         sender.Done()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.navigationController?.dismiss(animated: true, completion: nil)
                        self.nameTextField.text?.removeAll()
                        self.priceTextField.text?.removeAll()
                        self.txtView.text?.removeAll()
                        self.Images = []
                        self.collectionView.reloadData()
                    })
                }
            
            }
        }
        Uploader.shared.DidFailedUpload = {
            MessageBoxShow.Show(LocalizationSystem.sharedInstance.localizedStringForKey(key: "No_Submit_Product", comment: ""))
        }
    }
    }

    func textViewChangeSise(){
        let fixedWith = txtView.frame.size.width
        txtView.sizeThatFits(CGSize(width: fixedWith, height: CGFloat.greatestFiniteMagnitude))
        let newSise = txtView.sizeThatFits(CGSize(width: fixedWith, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = txtView.frame
        newFrame.size = CGSize(width: max(newSise.width, fixedWith), height: newSise.height)
        var tempHighnt : CGFloat = 300
        for one in BigView.subviews{
            if (one is UITextView) == false {
                tempHighnt += CGFloat(one.frame.size.height)
            }
        }
        BigViewHight.constant = tempHighnt + newFrame.size.height
        scrollView.layoutIfNeeded()
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

extension addNewProduct: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! imageCollectionViewCell
        cell.update(img: Images[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
    }
    
}

import Photos

extension addNewProduct{
    func AddImageAction() {
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
                                            // User selected an asset.
                                            // Do something with it, start upload perhaps?
        }, deselect: { (asset: PHAsset) -> Void in
            // User deselected an assets.
            // Do something, cancel upload?
        }, cancel: { (assets: [PHAsset]) -> Void in
            // User cancelled. And this where the assets currently selected.
        }, finish: { (assets: [PHAsset]) -> Void in
            // User finished with these assets
            let imageArray = assets.map({$0.ToUIImage()})
            for one in imageArray {
                if one != nil{
                    self.Images.append(one!)
                }
                DispatchQueue.main.async {
                   self.collectionView.reloadData()
                }
                
            }
        }, completion: nil)
    }
}

extension addNewProduct {
    
    func SettingUpKeyboardNotification(){
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(addNewProduct.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(addNewProduct.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow (notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var newHight: CGFloat = 0
            if let tabbar = self.tabBarController {
                newHight = tabbar.tabBar.frame.size.height
            }
            self.BottomLayout.constant = keyboardSize.height - newHight
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        self.BottomLayout.constant = 0
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
    }
    
}
