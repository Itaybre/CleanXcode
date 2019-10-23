//
//  DerivedDataHelper.swift
//  CleanXcode
//
//  Created by Itay Brenner on 9/18/19.
//  Copyright © 2019 Itay Brenner. All rights reserved.
//

import Foundation

protocol DerivedDataManagerDelegate {
    func directoryCleaned()
    func errorCleaning(error: String)
}

class DerivedDataManager {
    let fileManager = FileManager.default
    var delegate: DerivedDataManagerDelegate?
    
    func derivedDataFolder() -> String {
        let pw = getpwuid(getuid());
        let home = pw?.pointee.pw_dir
        let homePath = fileManager.string(withFileSystemRepresentation: home!,
                                                  length: Int(strlen(home!)))
        return "\(homePath)/Library/Developer/Xcode/DerivedData"
    }
    
    func clean() {
        DispatchQueue.global().async { [weak self] in
            do {
                if let self = self {
                    let path = self.derivedDataFolder()
                    let folders = try self.getFolders(path: path)
                    let success = self.removeDirectoriesAtPaths(folders)
                    if success {
                        self.delegate?.directoryCleaned()
                    } else {
                        self.delegate?.errorCleaning(error: "")
                    }
                }
            } catch let error {
                self?.delegate?.errorCleaning(error: error.localizedDescription)
            }
        }
    }
    
    fileprivate func getFolders(path: String) throws -> [String] {
        return try contentsOfDirectory(path)
    }
    
    fileprivate func contentsOfDirectory(_ path: String) throws -> [String] {
        let paths = try fileManager.contentsOfDirectory(atPath: path)
        return paths.map({ (content) -> String in
            return "\(path)/\(content)"
        })
    }
    
    fileprivate func removeDirectoriesAtPaths(_ paths: [String]) -> Bool {
        return paths.reduce(true) { $0 && removeDirectoryAtPath($1) }
    }
    
    fileprivate func removeDirectoryAtPath(_ path: String) -> Bool {
        do {
            try fileManager.removeItem(atPath: path)
            
            // retry once
            if fileManager.fileExists(atPath: path) {
                try fileManager.removeItem(atPath: path)
            }
        }
        catch let error {
            print("Xcode Helper: Failed to remove directory: \(path) -> \(error)")
        }
        return !fileManager.fileExists(atPath: path)
    }
    
    func size() -> Int64 {
        let path = derivedDataFolder()
        
        guard fileManager.fileExists(atPath: path) else {
            return 0
        }
        
        let filesArray: [String]
        var fileSize:Int64 = 0
        
        do {
            filesArray = try fileManager.subpathsOfDirectory(atPath: path) as [String]
        } catch let error {
            print("Error: \(error)")
            return 0
        }
        
        for fileName in filesArray {
            var fileUrl = URL(fileURLWithPath: path)
            fileUrl.appendPathComponent(fileName)
            
            do {
                let fileDictionary: NSDictionary = try fileManager.attributesOfItem(atPath: fileUrl.path) as NSDictionary
                fileSize += Int64(fileDictionary.fileSize())
            } catch let error {
                print("Error: \(error)")
            }
        }
        
        return fileSize
    }
    
    func formatedSize() -> String {
        return ByteCountFormatter.string(fromByteCount: size(),
                                         countStyle: .file)
    }
}
