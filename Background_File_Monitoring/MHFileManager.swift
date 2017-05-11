//
//  MHFileManager.swift
//  Background_File_Monitoring
//
//  Created by Melaniia Hulianovych on 5/11/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation

var directoryNames: [URL] = []
var stringDirectoryNames = [String]()
let manager = FileManager.default

class MHFileManager {
    
    static let shared: MHFileManager = {
        let instance = MHFileManager ()
        return instance
    }()
    
    func getFilesInDocumentsFolder() -> [String] {
        let documentsUrl =  manager.urls(for: .documentDirectory, in: .userDomainMask).first!
        directoryNames.append(documentsUrl)
        do {

            let directoryContents = try manager.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            //        splitFilesInFolder(array: directoryContents)
            //        checkForDirectories(inPath: documentsUrl, withAlreadyExisted: directoryContents)
            
            let resourceKeys : [URLResourceKey] = [.isDirectoryKey]
            
            let enumerator = manager.enumerator(at: documentsUrl,
                                                includingPropertiesForKeys: resourceKeys,
                                                options: [.skipsHiddenFiles], errorHandler: { (url, error) -> Bool in
                                                    print("directoryEnumerator error at \(url): ", error)
                                                    return true
            })!
            
            for case let fileURL as URL in enumerator {
                let resourceValues = try fileURL.resourceValues(forKeys: Set(resourceKeys))
                if resourceValues.isDirectory! {
                    directoryNames.append(fileURL)
                    //                let directoryContents = try manager.contentsOfDirectory(at: fileURL, includingPropertiesForKeys: nil, options: [])
                    //                if directoryNames.contains(fileURL.lastPathComponent) {
                    //                    splitFilesInFolder(array: directoryContents, specialFolder: true)
                    //                } else {
                    //                    splitFilesInFolder(array: directoryContents)
                    //                }
                }
                print(fileURL.path, resourceValues.creationDate, resourceValues.isDirectory)
                print("***-----------***--------***")
            }
            return getNamesForFolders(fromArray: directoryNames)
            //        onCompletion(DataSource.shared.allFiles, DataSource.shared.allSavedFiles)
        } catch {
            print(error)
            return []
        }
    }
    
    func getNamesForFolders(fromArray array: [URL]) -> [String] {
        var newArray = [String]()
        for file in array {
        var urlNew: String = file.path
        if urlNew.containsWhitespace {
            urlNew = urlNew.replacingOccurrences(of: " ", with: "_")
        }
//        let url = NSURL(string: urlNew)?.deletingPathExtension?.lastPathComponent
            guard let url = NSURL(string: urlNew)?.deletingPathExtension?.lastPathComponent else { continue }
            newArray.append(url)
        
        }
        return newArray
    }
}
