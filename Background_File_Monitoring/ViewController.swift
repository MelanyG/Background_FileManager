//
//  ViewController.swift
//  Background_File_Monitoring
//
//  Created by Melaniia Hulianovych on 5/11/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum Status: String {
        case Entrance = "Please select the folder to follow"
        case Exit = "Thanks, you will be notified about any changes in this folder. You can close the application"
        case ActionWithFolder = "In observed folder happened Action"
    }
    
    var dataSource:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Available folders"
        dataSource = MHFileManager.shared.getFilesInDocumentsFolder()
        showInformationMessage(withMessage: Status.Entrance)
        registerForNotifications()
        
    }
    
    // MARK:- UITableViewCell Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? FileCell
        cell?.configureCell(dataSource[indexPath.row])
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showInformationMessage(withMessage: Status.Exit)
        
        BackgroundManager.shared.folderToMonitor = MHFileManager.shared.directoryNames[indexPath.row]
        BackgroundManager.shared.addFolderToMonitoring()
        BackgroundManager.shared.delegate = self
        print(indexPath.row)
    }
    
    func showInformationMessage(withMessage current: Status) {
        
        var message = ""
        switch current {
        case .Entrance, .Exit:
            message = current.rawValue
        case .ActionWithFolder:
            message = current.rawValue
        }
        DispatchQueue.main.async {
            [weak self] in
            let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
            }
            
            alertController.addAction(okAction)
            self?.present(alertController, animated: true, completion: nil)
        }
    }
  
    
    deinit {
         BackgroundManager.shared.delegate = nil
    }
    
}

extension ViewController: BackGroundDelegate {
    func didChangeHappend() {
        scheduleNotification()
    }
}

extension ViewController: UNUserNotificationCenterDelegate {
    
    // MARK:- Notifications Actions
    
    func scheduleNotification() {
        
        let notif = UNMutableNotificationContent()
        notif.title = "I am a Reminder"
        notif.body = "Folder you observed - changed!"
        notif.sound = UNNotificationSound.default()
        notif.categoryIdentifier = "texted"
        
        let request = UNNotificationRequest(identifier: "texted", content: notif, trigger: nil)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {
            error in
            if error != nil {
                print(error?.localizedDescription ?? "some error")
                // completion(Success: false)
            } else {
                print("success")
                //completion(Sucess: true)
            }
        })
        
    }
    
    func registerForNotifications() {
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization
        }
        let info = UNNotificationAction(identifier: "Info", title: "Folder you observed - changed!", options: [])
        
        let category = UNNotificationCategory(identifier: "texted", actions: [info], intentIdentifiers: [], options: [.customDismissAction])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        UNUserNotificationCenter.current().delegate = self
    }
}

class FileCell: UITableViewCell {
    
    @IBOutlet weak var textFileLbl: UILabel!
    
    func configureCell(_ text: String) {
        textFileLbl.text = text
    }
}
