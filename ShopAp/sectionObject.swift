//
//  sectionObject.swift
//  ShopAp
//
//  Created by mr Yacine on 12/22/18.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import Foundation
import Firebase

class sectionObject {
    var ID: String?
    var Name: String?
    var Stamp: TimeInterval?
    var Icon: String?
    
   /* init(ID: String, Name: String, Stamp: TimeInterval, Icon: String) {
        self.ID = ID
        self.Name = Name
        self.Stamp = Stamp
        self.Icon = Icon
    }*/
    
    init(ID: String, Name: String, Stamp: TimeInterval) {
        self.ID = ID
        self.Name = Name
        self.Stamp = Stamp
    }
    
    init(Dictionary: [String : AnyObject]) {
        self.ID = Dictionary["ID"] as? String
        self.Name = Dictionary["Name"] as? String
        self.Stamp = Dictionary["Stamp"] as? TimeInterval
        //self.Icon = Dictionary["Icon"] as? String
    }
    
    func getDictionnay()-> [String : AnyObject]{
        var new: [String : AnyObject] = [:]
        new["ID"] = self.ID as AnyObject
        new["Name"] = self.Name as AnyObject
        new["Stamp"] = self.Stamp as AnyObject
        //new["Icon"] = self.Icon as AnyObject
        return new
    }
    
    func upload(){
        guard let id = self.ID else {return}
        Database.database().reference().child("Section").child(id).setValue(getDictionnay())
        let nc = NotificationCenter.default
        nc.post(name: NSNotification.Name(rawValue: "SectionAdded"), object: nil)
    }
    
    func remove(){
        guard let id = self.ID else {return}
        Database.database().reference().child("Section").child(id).removeValue()
    }
}

class SectionAPI {
    
   static func getSection(completion: @escaping (_ section: [sectionObject])->()){
        Database.database().reference().child("Section").observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            if let Value = snapshot.value as? [String: [String: AnyObject]]{
                var tempSection : [sectionObject] = []
                for oneSection in Value.values {
                    let newSection = sectionObject(Dictionary: oneSection)
                    tempSection.append(newSection)
                    if tempSection.count == Value.count{
                        completion(tempSection)
                    }
                }
            }
        }
    }
    
    static func getSectionfrom(sectionID: String)-> sectionObject?{
        let section = SectionCaches.getSection()
        for one in section{
            if one.ID == sectionID{
                return one
            }
        }
        return nil
    }
    
}
