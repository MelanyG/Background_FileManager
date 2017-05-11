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
    }
    
    var dataSource:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Available folders"
        dataSource = MHFileManager.shared.getFilesInDocumentsFolder()
        showInformationMessage(withMessage: Status.Entrance)
        print(dataSource)
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
        print(indexPath.row)
    }
    
    func showInformationMessage(withMessage current: Status) {
        
        let message = current.rawValue
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("OK")
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
   
}


class FileCell: UITableViewCell {
    
    @IBOutlet weak var textFileLbl: UILabel!
    
    func configureCell(_ text: String) {
        textFileLbl.text = text
    }
}
