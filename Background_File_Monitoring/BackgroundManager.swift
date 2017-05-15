//
//  BackgroundManager.swift
//  Background_File_Monitoring
//
//  Created by Melaniia Hulianovych on 5/12/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation

protocol BackGroundDelegate {
    func didChangeHappend()
}

class BackgroundManager {
    
    var folderToMonitor: URL!
    var delegate:BackGroundDelegate?
    
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
            if self?.delegate != nil {
                self?.delegate?.didChangeHappend()
            }
        }
        _source.setCancelHandler { 
            [weak self] in
            self?.delegate = nil
            guard let desc = self?.fileDescriptor else { return }
            close(desc)
        }
        _source.resume()
    }

    
    
}
