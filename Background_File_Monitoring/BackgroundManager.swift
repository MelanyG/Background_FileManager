//
//  BackgroundManager.swift
//  Background_File_Monitoring
//
//  Created by Melaniia Hulianovych on 5/12/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation


let folderChangedNotification = Notification.Name("FolderChangedNotification")


class BackgroundManager {
    
    var folderToMonitor: URL!
    
    static let shared: BackgroundManager = {
        let instance = BackgroundManager ()
        return instance
        }()
    
    var  _dispatchQueue: DispatchQueue?
    var  _source: DispatchSourceProtocol!
    var fileDescriptor: Int32!
    
    func addFolderToMonitoring() {

        
        fileDescriptor = open(folderToMonitor.path, O_CREAT, 0o644)
        
        _dispatchQueue = DispatchQueue(label: "Monitor")
        
        _source = DispatchSource.makeFileSystemObjectSource(fileDescriptor: fileDescriptor, eventMask: .all, queue: _dispatchQueue)
        
        _source.setEventHandler {
            [weak self] in
            NotificationCenter.default.post(name: folderChangedNotification, object: nil)
            print(self?._source.mask)
        }
        _source.resume()
    }

    
    
}
