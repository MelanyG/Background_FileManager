//
//  ViewController.swift
//  Background_File_Monitoring
//
//  Created by Melaniia Hulianovych on 5/11/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit

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
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.receivedNotificationAboutChanges), name: folderChangedNotification, object: nil)
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
   
    func receivedNotificationAboutChanges() {
        scheduleNotification()
       
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

    func scheduleNotification(){
        
        let n = UILocalNotification()
        let c = Calendar.autoupdatingCurrent
        var comp = c.dateComponents(in: c.timeZone, from: Date())
        comp.second = comp.second!
        let date = c.date(from: comp)
        n.fireDate = date
        
        n.alertBody = "Folder you observed - changed!"
        n.alertAction = "Enter"
        n.category = "texted"
        UIApplication.shared.scheduleLocalNotification(n)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: folderChangedNotification, object: nil)
    }
}


class FileCell: UITableViewCell {
    
    @IBOutlet weak var textFileLbl: UILabel!
    
    func configureCell(_ text: String) {
        textFileLbl.text = text
    }
}
