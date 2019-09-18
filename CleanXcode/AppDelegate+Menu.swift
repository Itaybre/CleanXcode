//
//  AppDelegate+Menu.swift
//  CleanXcode
//
//  Created by Itay Brenner on 9/18/19.
//  Copyright © 2019 Itay Brenner. All rights reserved.
//

import Cocoa

extension AppDelegate {
    @objc
    func cleanDerivedData() {
        DispatchQueue.global().async {
            do {
                let path = self.derivedDataFolder()
                let size = try self.sizeOfDirectory(path)
                try self.fileManager.removeItem(atPath: path)
                self.showNotification(title: "ATR", message: "Cleared: \(self.formatSize(size))")
            } catch {
                self.showNotification(title: "Error", message: "There was an error cleaning DerivedData: \(error.localizedDescription)")
            }
        }
    }
    
    func formatSize(_ size: UInt64) -> String {
        return ByteCountFormatter.string(fromByteCount: Int64(size), countStyle: .file)
    }
    
    func sizeOfDirectory(_ path: String) throws -> UInt64 {
        guard fileManager.fileExists(atPath: path) else {
            return 0
        }
        
        let filesArray: [String] = try fileManager.subpathsOfDirectory(atPath: path) as [String]
        var fileSize:UInt64 = 0
        
        for fileName in filesArray {
            var fileUrl = URL(fileURLWithPath: path)
            fileUrl.appendPathComponent(fileName)
            let fileDictionary: NSDictionary = try fileManager.attributesOfItem(atPath: fileUrl.path) as NSDictionary
            fileSize += UInt64(fileDictionary.fileSize())
        }
        
        return fileSize
    }
    
    @objc
    func exitApp() {
        NSApplication.shared.terminate(nil)
    }
    
    func derivedDataFolder() -> String {
        let homeURL = NSString("~").expandingTildeInPath
        return "\(homeURL)/Library/Developer/Xcode/DerivedData"
    }
}

extension AppDelegate: NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        DispatchQueue.global().async {
            self.updateSize()
        }
    }
}
