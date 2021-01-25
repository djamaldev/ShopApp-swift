//
//  ContainerViewController.swift
//  ShopAp
//
//  Created by mr Yacine on 4/20/19.
//  Copyright © 2019 mr Yacine. All rights reserved.
//

import SidebarOverlay

class ContainerViewController: SOContainerViewController {
    var isMenu: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuSide = .left
        self.topViewController = self.storyboard?.instantiateViewController(withIdentifier: "topScreen")
        self.sideViewController = self.storyboard?.instantiateViewController(withIdentifier: "leftScreen")
    }
    @IBAction func show(_ sender: Any) {
        
        if isMenu{
            if let container = self.so_containerViewController{
                container.isSideViewControllerPresented = false
            }
        }else {
            if let container = self.so_containerViewController{
                container.isSideViewControllerPresented = true
            }
        }
        isMenu = !isMenu
    }
}
