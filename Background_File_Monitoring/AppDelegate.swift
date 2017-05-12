//
//  AppDelegate.swift
//  Background_File_Monitoring
//
//  Created by Melaniia Hulianovych on 5/11/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        registerForNotifications()
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

    func registerForNotifications() {
        
        //        let enterInfo = UIMutableUserNotificationAction()
        //        enterInfo.identifier = "enter"
        //        enterInfo.title = "Enter your name"
        //        enterInfo.behavior = .textInput //this is the key to this example
        //        enterInfo.activationMode = .foreground
        
        let info = UIMutableUserNotificationAction()
        info.identifier = "Info"
        info.title = "Folder you observed - changed!"
        
        let category = UIMutableUserNotificationCategory()
        category.identifier = "texted"
        category.setActions([info], for: .default)
        
        let settings = UIUserNotificationSettings(
            types: .alert, categories: [category])
        
        UIApplication.shared.registerUserNotificationSettings(settings)
        
    }
}

