//
//  AdminObject.swift
//  ShopAp
//
//  Created by mr Yacine on 12/25/18.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import Foundation
import Firebase

class AdminObject {
    var ID : String?
    var Name: String?
    var Stamp: TimeInterval?
    
    init(ID: String, Name: String, Stamp: TimeInterval) {
        self.ID = ID
        self.Name = Name
        self.Stamp = Stamp
    }
    
    init(Dictionary: [String : AnyObject]) {
        self.ID = Dictionary["ID"] as? String
        self.Name = Dictionary["Name"] as? String
        self.Stamp = Dictionary["Stamp"] as? TimeInterval
    }
    
    func GetDictionary()->[String : AnyObject]{
        var new : [String : AnyObject] = [:]
        new["ID"] = self.ID as AnyObject
        new["Name"] = self.Name as AnyObject
        new["Stamp"] = self.Stamp as AnyObject
        return new
    }
    
    func Upload(){
        guard let id = self.ID else {return}
        Database.database().reference().child("Admin").child(id).setValue(GetDictionary())
        let nc = NotificationCenter.default
        nc.post(name: NSNotification.Name(rawValue: "AdminAdded"), object: nil)
    }
    
    func Remove(){
        guard let id = self.ID else {return}
        Database.database().reference().child("Admin").child(id).removeValue()
    }
}

class AdminAPI {
    
    static func GetAdmin(completion: @escaping (_ Admin: [AdminObject])->()){
        Database.database().reference().child("Admin").observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            if let value = snapshot.value as? [String: [String : AnyObject]]{
                var TAdmin : [AdminObject] = []
                for one in value.values{
                    TAdmin.append(AdminObject(Dictionary: one))
                }
                completion(TAdmin)
            }
        }
    }
}
