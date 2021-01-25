//
//  SectionCaches.swift
//  ShopAp
//
//  Created by mr Yacine on 12/24/18.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import Foundation

class SectionCaches {
    
    static func AddSection(section: [sectionObject]){
        //var Icons: [String] = []
        var IDs: [String] = []
        var Names: [String] = []
        
        /*section.forEach { (one) in
            if let icon = one.Icon {
                Icons.append(icon)
            }
        }*/
        section.forEach { (one) in
            if let id = one.ID {
                IDs.append(id)
            }
        }
        section.forEach { (one) in
            if let name = one.Name {
                Names.append(name)
            }
        }
        //UserDefaults.standard.set(Icons, forKey: "Icons")
        UserDefaults.standard.set(IDs, forKey: "IDs")
        UserDefaults.standard.set(Names, forKey: "Names")
    }
    
    static func getSection()->[sectionObject]{
        guard /*let Icons = UserDefaults.standard.value(forKey: "Icons") as? [String],*/ let IDs = UserDefaults.standard.value(forKey: "IDs") as? [String], let Names = UserDefaults.standard.value(forKey: "Names") as? [String] else {return []}
        var TSection : [sectionObject] = []
        /*for (index, one) in Icons.enumerated() {
            let newSection = sectionObject(ID: IDs[index], Name: Names[index], Stamp: 0, Icon: one)
            TSection.append(newSection)
        }*/
        for (index, _) in Names.enumerated() {
            let newSection = sectionObject(ID: IDs[index], Name: Names[index], Stamp: 0)
            TSection.append(newSection)
        }
        return TSection
    }
}
