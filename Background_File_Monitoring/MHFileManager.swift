//
//  MHFileManager.swift
//  Background_File_Monitoring
//
//  Created by Melaniia Hulianovych on 5/11/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation

class MHFileManager {
    
    var directoryNames: [URL] = []
    var stringDirectoryNames = [String]()
    let manager = FileManager.default
    
    static let shared: MHFileManager = {
        let instance = MHFileManager ()
        return instance
    }()
    
    func getFilesInDocumentsFolder() -> [String] {
        let documentsUrl =  manager.urls(for: .documentDirectory, in: .userDomainMask).first!
        directoryNames.append(documentsUrl)
        do {
            
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

                }

            }
            return getNamesForFolders(fromArray: directoryNames)

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

            guard let url = NSURL(string: urlNew)?.deletingPathExtension?.lastPathComponent else { continue }
            newArray.append(url)
        
        }
        return newArray
    }
}
