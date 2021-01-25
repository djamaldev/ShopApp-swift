//
//  SearchObject.swift
//  ShopAp
//
//  Created by mr Yacine on 12/26/18.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import Foundation
import Firebase

class SearchObject {
    
    var ID : String?
    var Stamp: TimeInterval?
    var SearchText: String?
    var ProductID: String?
    
    init(ID: String, SearchText: String, Stamp: TimeInterval, ProductID: String) {
        self.ID = ID
        self.SearchText = SearchText
        self.Stamp = Stamp
        self.ProductID = ProductID
    }
    
    init(Dictionary: [String : AnyObject]) {
        self.ID = Dictionary["ID"] as? String
        self.SearchText = Dictionary["SearchText"] as? String
        self.Stamp = Dictionary["Stamp"] as? TimeInterval
        self.ProductID = Dictionary["ProductID"] as? String
    }
    
    func GetDictionary()->[String : AnyObject]{
        var new : [String : AnyObject] = [:]
        new["ID"] = self.ID as AnyObject
        new["SearchText"] = self.SearchText as AnyObject
        new["Stamp"] = self.Stamp as AnyObject
        new["ProductID"] = self.ProductID as AnyObject
        return new
    }
    
    func Upload(){
        guard let id = self.ID else {return}
        Database.database().reference().child("SearchProduct").child(id).setValue(GetDictionary())
    }
    
    func Remove(){
        guard let id = self.ID else {return}
        Database.database().reference().child("SearchProduct").child(id).removeValue()
    }
    
}

class SearchAPI {
    
   static func SearchProductWith(word: String, completion: @escaping (_ searchResult: [SearchObject])->()){
        Database.database().reference().child("SearchProduct").queryOrdered(byChild: "SearchText").queryStarting(atValue: word).queryEnding(atValue: word + "\u{f8ff}").observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            if let value = snapshot.value as? [String : [String : AnyObject]]{
                var TSearchObject: [SearchObject] = []
                for oneSearchResult in value.values{
                    TSearchObject.append(SearchObject(Dictionary: oneSearchResult))
                    if value.count == TSearchObject.count {
                        completion(TSearchObject)
                    }
                }
            }
        }
    }
}
