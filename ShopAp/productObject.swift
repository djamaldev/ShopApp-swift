//
//  productObject.swift
//  ShopAp
//
//  Created by mr Yacine on 11/27/18.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import UIKit
import Firebase

class productObject: NSObject{
    var ID: String?
    var Name: String?
    var Stamp: TimeInterval?
    var SectionID: String?
    var OwnerUserID: String?
    var Description: String?
    var Image: [String]?
    var SmallImage: String?
    var price: String?
    
    init(ID: String, Name: String, price: String, Stamp: TimeInterval, SectionID: String, OwnerUserID: String,Description: String, Image: [String], SmallImage: String) {
        self.ID = ID
        self.Name = Name
        self.Stamp = Stamp
        self.price = price
        self.SectionID = SectionID
        self.OwnerUserID = OwnerUserID
        self.Description = Description
        self.Image = Image
        self.SmallImage = SmallImage
    }
    
    init(Dectionary: [String : AnyObject]) {
        self.ID = Dectionary["ID"] as? String
        self.Name = Dectionary["Name"] as? String
        self.Stamp = Dectionary["Stamp"] as? TimeInterval
        self.SectionID = Dectionary["SectionID"] as? String
        self.OwnerUserID = Dectionary["OwnerUserID"] as? String
        self.Description = Dectionary["Description"] as? String
        self.Image = Dectionary["Image"] as? [String]
        self.SmallImage = Dectionary["SmallImage"] as? String
        self.price = Dectionary["Price"] as? String
    }
    
    func GetDectionary()->[String : AnyObject]{
        var new : [String : AnyObject] = [:]
        new["ID"] = self.ID as AnyObject
        new["Name"] = self.Name as AnyObject
        new["Stamp"] = self.Stamp as AnyObject
        new["SectionID"] = self.SectionID as AnyObject
        new["OwnerUserID"] = self.OwnerUserID as AnyObject
        new["Description"] = self.Description as AnyObject
        new["Image"] = self.Image as AnyObject
        new["SmallImage"] = self.SmallImage as AnyObject
        new["Price"] = self.price as AnyObject
        return new
    }
    
    func getFavorite()-> [String : AnyObject]{
        var new : [String : AnyObject] = [:]
        new["ID"] = self.ID as AnyObject
        new["Name"] = self.Name as AnyObject
        //new["OwnerUserID"] = self.OwnerUserID as AnyObject
        new["SmallImage"] = self.SmallImage as AnyObject
        new["Price"] = self.price as AnyObject
        return new
    }
    
    func Upload(){
        guard  let id = self.ID, let userid = self.OwnerUserID, let sectionid = self.SectionID  else {return}
        Database.database().reference().child("Products").child(id).setValue(GetDectionary())
    Database.database().reference().child("UserProducts").child(userid).child(id).setValue(Date().timeIntervalSince1970)
        Database.database().reference().child("SectionProducts").child(sectionid).child(id).setValue(Date().timeIntervalSince1970)
        let nc = NotificationCenter.default
        nc.post(name: NSNotification.Name(rawValue: "ProductAdded"), object: nil)
        let nc1 = NotificationCenter.default
        nc1.post(name: NSNotification.Name(rawValue: "Adversting"), object: nil)
        
        if let WordFromName = self.Name?.components(separatedBy: " "), let id = self.ID{
            for (index, one) in WordFromName.enumerated(){
                SearchObject(ID: id + "\(index)", SearchText: one.lowercased(), Stamp: Date().timeIntervalSince1970, ProductID: id).Upload()
            }
        }
    }
    
    func remove(){
        guard  let id = self.ID, let userid = self.OwnerUserID, let sectionid = self.SectionID  else {return}
        Database.database().reference().child("Products").child(id).removeValue()
        Database.database().reference().child("UserProducts").child(userid).child(id).removeValue()
        Database.database().reference().child("SectionProducts").child(sectionid).child(id).removeValue()
        
        if let id = self.ID {
            for index in 1...10 {
                SearchObject(ID: id + "\(index)", SearchText: "", Stamp: Date().timeIntervalSince1970, ProductID: id).Remove()
            }
        }
    }
    
    func Rate(value: Int){
        guard let id = self.ID else {return}
        Auth.auth().addStateDidChangeListener { (auth, User) in
            if let userid = User?.uid {
                Database.database().reference().child("ProductRating").child(id).child(userid).setValue(value)
            }
        }
    }
    
    var RatingCount: Int?
    func getRate(completion: @escaping (_ value: Int)->()){
        guard let id = self.ID else {return}
        Database.database().reference().child("ProductRating").child(id).observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            if let value = snapshot.value as? [String : Int]{
                var Sum = 0
                for one in value.values {
                    Sum = Sum + one
                    let Result = Sum / value.count
                    self.RatingCount = value.count
                    completion(Result)
                }
            }
        }
    }
    
    
    func FavoriteProduct(){
        guard  let id = self.ID else {return}
        
            let userid = Auth.auth().currentUser?.uid
        Database.database().reference().child("Favorite").child(userid!).child(id).setValue(self.getFavorite())
    }
    
    func RemovFav(){
        guard  let id = self.ID else {return}
        let userid = Auth.auth().currentUser?.uid
        Database.database().reference().child("Favorite").child(userid!).child(id).removeValue()
    }
}

class ProductAPI{
    
    static func SearchFor(Text: String, completion: @escaping (_ prduct: productObject)->()){
        let wordFromText = Text.components(separatedBy: " ")
        for one in wordFromText {
            SearchAPI.SearchProductWith(word: one) { (searchObject: [SearchObject]) in
                for oneSearch in searchObject {
                    if let Productid = oneSearch.ProductID{
                        getProductFrom(ID: Productid, completion: { (theProduct: productObject) in
                            completion(theProduct)
                        })
                    }
                }
            }
        }
    }

    static func getAllProducts(lastStamp: TimeInterval?,completion: @escaping (_ product: [productObject])->()){
        var Ref: DatabaseQuery = Database.database().reference()
        if lastStamp == nil {
            Ref = Database.database().reference().child("Products").queryLimited(toLast: 20).queryOrdered(byChild: "Stamp")
        } else {
            Ref = Database.database().reference().child("Products").queryLimited(toLast: 20).queryOrdered(byChild: "Stamp").queryEnding(atValue: lastStamp! - 0.0000000000001)
        }
        Ref.removeAllObservers()
        Ref.observeSingleEvent(of: .value) { (Snapshot: DataSnapshot) in
            if let dectionary = Snapshot.value as? [String: [String: AnyObject]]{
                var tempProduct : [productObject] = []
                for one in dectionary.values {
                    tempProduct.append(productObject(Dectionary: one))
                    if tempProduct.count == dectionary.count {
                        completion(tempProduct)
                    }
                }
            }
        }
    }
    
    static func getProductFor(Section: sectionObject, lastStamp: TimeInterval?,completion: @escaping (_ product: [productObject])->()){
        guard let id = Section.ID else {return}
        var Ref: DatabaseQuery = Database.database().reference()
        if lastStamp == nil {
            Ref = Database.database().reference().child("SectionProducts").child(id).queryLimited(toLast: 20).queryOrderedByValue()
        } else {
            Ref = Database.database().reference().child("SectionProducts").child(id).queryLimited(toLast: 20).queryOrderedByValue().queryEnding(atValue: lastStamp! - 0.0000000000001)
        }
        Ref.removeAllObservers()
        Ref.observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            if let value = snapshot.value as? [String: AnyObject]{
                var tProduct: [productObject] = []
                for idProduct in value.keys{
                    getProductFrom(ID: idProduct, completion: { (product: productObject) in
                        tProduct.append(product)
                        if tProduct.count == value.count{
                            completion(tProduct)
                        }
                    })
                }
            }
        }
    }
    
    static func getProductFrom(ID: String, completion: @escaping (_ product: productObject)->()){
        Database.database().reference().child("Products").child(ID).observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            if let value = snapshot.value as? [String: AnyObject]{
                completion(productObject(Dectionary: value))
            }
        }
    }
    
    static func getProductForUser(ownerUser:String, completion: @escaping (_ product: [productObject])->()){
       // guard let id = Product.ID else {return}
        let ref = Database.database().reference().child("UserProducts").child(ownerUser)
        ref.observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            if let value = snapshot.value as? [String: AnyObject]{
                var tProduct: [productObject] = []
                for idProd in value.keys{
                    getProductFrom(ID: idProd, completion: { (prod: productObject) in
                        tProduct.append(prod)
                        if tProduct.count == value.count{
                            completion(tProduct)
                        }
                        })
                        
                    }
                }
            }
        }
    
    static func getFavoriteFor(userID: String,completion: @escaping (_ favorite: [productObject])->()){
        Database.database().reference().child("Favorite").child(userID).observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            if let value = snapshot.value as? [String: AnyObject]{
                var tFavorite: [productObject] = []
                for idfavorite in value.keys{
                    getProductFrom(ID: idfavorite, completion: { (fav: productObject) in
                        tFavorite.append(fav)
                        if tFavorite.count == value.count{
                            completion(tFavorite)
                        }
                    })
                }
            }
        }
    }
    
    }

