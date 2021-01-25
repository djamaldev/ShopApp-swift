//
//  userObject.swift
//  ShopAp
//
//  Created by mr Yacine on 11/26/18.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import Foundation
import Firebase

class userObject {
    
    var ID: String?
    var Name: String?
    var Age: Int?
    var Job: String?
    var Email: String?
    var Stamp: TimeInterval?
    var ProfileImage: String?
    var phoneNumber: String?
    
    init(ID: String, Name: String, Age: Int?, Job: String?, Email: String, Stamp: TimeInterval, ProfileImage: String?, phoneNumber: String) {
        self.ID = ID
        self.Name = Name
        self.Age = Age
        self.Job = Job
        self.Email = Email
        self.Stamp = Stamp
        self.ProfileImage = ProfileImage
        self.phoneNumber = phoneNumber
    }
    
    init(Dictionary: [String : AnyObject]) {
        self.ID = Dictionary["ID"] as? String
        self.Name = Dictionary["Name"] as? String
        self.Age = Dictionary["Age"] as? Int
        self.Job = Dictionary["Job"] as? String
        self.Email = Dictionary["Email"] as? String
        self.Stamp = Dictionary["Stamp"] as? TimeInterval
        self.ProfileImage = Dictionary["ProfileImage"] as? String
        self.phoneNumber = Dictionary["phoneNumber"] as? String
    }
    
    func getDictionary()->[String : AnyObject]{
        
        var new : [String: AnyObject] = [:]
        new["ID"] = self.ID as AnyObject
        new["Name"] = self.Name as AnyObject
        new["Age"] = self.Age as AnyObject
        new["Job"] = self.Job as AnyObject
        new["Email"] = self.Email as AnyObject
        new["Stamp"] = self.Stamp as AnyObject
        new["ProfileImage"] = self.ProfileImage as AnyObject
        new["phoneNumber"] = self.phoneNumber as AnyObject
        return new
    }
    
    func Upload(){
        if let id = self.ID{
            Database.database().reference().child("Users").child(id).setValue(getDictionary())
        }
        
    }
    
    func remove(){
        if let id = self.ID{
            Database.database().reference().child("Users").child(id).removeValue()
        }
    }
}

class userApi {
    
    private static var refUser = Database.database().reference().child("Users")
    
    static func getUser(lastStamp: TimeInterval?, Quantite: UInt, completion: @escaping (_ Users: [AnyObject])->()){
        var newRef = refUser.queryOrdered(byChild: "Stamp").queryLimited(toLast: Quantite)
        if let laststamp = lastStamp {
            newRef = refUser.queryOrdered(byChild: "Stamp").queryLimited(toLast: Quantite).queryStarting(atValue: laststamp - 0.00000001)
        }
        newRef.observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            if let Value = snapshot.value as? [String: [String: AnyObject]]{
                var tempUser : [userObject] = []
                for oneUser in Value.values {
                    let newUser = userObject(Dictionary: oneUser)
                    tempUser.append(newUser)
                    if tempUser.count == Value.count{
                        completion(tempUser)
                    }
                }
            }
        }
    }
    
    static func getUser(with ID : String, completion: @escaping (_ user: userObject)->()){
        refUser.child(ID).observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            if let Value = snapshot.value as? [String: AnyObject]{
                completion(userObject(Dictionary: Value))
            }
        }
    }
    
    static func getUserWith(ID: String, completion: @escaping (_ users: [userObject])->()){
        Database.database().reference().child("Users").child(ID).observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            if let dectionary = snapshot.value as? [String: [String: AnyObject]] {
                var tempUser : [userObject] = []
                for one in dectionary.values {
                    tempUser.append(userObject(Dictionary: one))
                    if tempUser.count == dectionary.count {
                        completion(tempUser)
                    }
                }
            }
        }
        
    }
}
