//
//  AppDelegate.swift
//  ShopAp
//
//  Created by mr Yacine on 11/24/18.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import UIKit
import Firebase
//adab8292aba5484a936665335a677cad
let baseUrl = "https://newsapi.org/v2/everything?q=apple&from=2019-05-07&to=2019-05-07&sortBy=popularity&apiKey=0c3c4b1199b54db5bb4445717da633c2" //"https://newsapi.org/v2/top-headlines?country=gb&category=sports&apiKey=0c3c4b1199b54db5bb4445717da633c2" 

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        UIApplication.shared.statusBarStyle = .lightContent
        UITabBar.appearance().tintColor = UIColor(red: 132.0/255.0, green: 136.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        //LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
        sleep(2)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func setInitialViewController(initialView: UIViewController)  {
        window = UIWindow(frame: UIScreen.main.bounds)
        let homeViewController = initialView
        let nav = UINavigationController(rootViewController: homeViewController)
        window!.rootViewController = nav
        window!.makeKeyAndVisible()
    }


}

