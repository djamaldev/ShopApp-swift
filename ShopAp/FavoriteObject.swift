//
//  FavoriteObject.swift
//  ShopAp
//
//  Created by mr Yacine on 2/3/19.
//  Copyright © 2019 mr Yacine. All rights reserved.
//

import UIKit
import Firebase

class FavoriteObject {
    
    var ID: String?
    var Name: String?
    var SmallImage: String?
    var price: String?
    
    init(ID: String, Name: String, price: String, SmallImage: String) {
        self.ID = ID
        self.Name = Name
        self.price = price
        self.SmallImage = SmallImage
    }
    
    init(Dectionary: [String : AnyObject]) {
        self.ID = Dectionary["ID"] as? String
        self.Name = Dectionary["Name"] as? String
        self.SmallImage = Dectionary["SmallImage"] as? String
        self.price = Dectionary["Price"] as? String
    }
    
    func GetDectionary()->[String : AnyObject]{
        var new : [String : AnyObject] = [:]
        new["ID"] = self.ID as AnyObject
        new["Name"] = self.Name as AnyObject
        new["SmallImage"] = self.SmallImage as AnyObject
        new["Price"] = self.price as AnyObject
        return new
    }
    
    func Upload(){
        guard let id = self.ID else {return}
                Database.database().reference().child("Favorite").child(id).setValue(self.GetDectionary())
            }
    
    func remove(){
        guard  let id = self.ID else {return}
        Database.database().reference().child("Favorite").child(id).removeValue()
    }
    
}

class FavoriteAPI {
    
    static func getFavoriteFrom(ID: String, completion: @escaping (_ favorite: FavoriteObject)->()){
        guard let userid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("Favorite").child(userid).child(ID).observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            if let value = snapshot.value as? [String: AnyObject]{
                completion(FavoriteObject(Dectionary: value))
            }
        }
    }
    
    static func getFavoriteFor(userID: String,completion: @escaping (_ favorite: [FavoriteObject])->()){
        Database.database().reference().child("Favorite").child(userID).observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            if let value = snapshot.value as? [String: AnyObject]{
                var tFavorite: [FavoriteObject] = []
                for idfavorite in value.keys{
                    getFavoriteFrom(ID: idfavorite, completion: { (fav: FavoriteObject) in
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
