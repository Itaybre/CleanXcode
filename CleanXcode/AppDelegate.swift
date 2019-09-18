//
//  AppDelegate.swift
//  CleanXcode
//
//  Created by Itay Brenner on 9/18/19.
//  Copyright © 2019 Itay Brenner. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusBarItem: NSStatusItem!
    let fileManager = FileManager.default
    
    var sizeMenuItem: NSMenuItem?
    var loginMenuItem: NSMenuItem?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSUserNotificationCenter.default.delegate = self
        
        statusBarItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
        if let button = statusBarItem.button {
            button.image = NSImage(named:NSImage.Name("icon"))
            button.image?.isTemplate = true
        }
        statusBarItem.menu = buildMenu()
    }

    func buildMenu() -> NSMenu {
        let menu = NSMenu.init(title: "Menu")
        menu.delegate = self
        
        sizeMenuItem = NSMenuItem.init(title: "Calculating size...",
                                       action: nil,
                                       keyEquivalent: "")
        let cleanItem = NSMenuItem.init(title: "Clean DerivedData",
                                       action: #selector(cleanDerivedData),
                                       keyEquivalent: "C")
        loginMenuItem = NSMenuItem.init(title: "Start at Login",
                                        action: #selector(startAtLogin),
                                        keyEquivalent: "S")
        let closeItem = NSMenuItem.init(title: "Quit",
                                        action: #selector(exitApp),
                                        keyEquivalent: "Q")
        updateLoginButton()
        
        menu.addItem(sizeMenuItem!)
        menu.addItem(cleanItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(loginMenuItem!)
        menu.addItem(closeItem)
        return menu
    }
    
    func updateSize() {
        do {
            let path = derivedDataFolder()
            let size = try sizeOfDirectory(path)
            let formatedSize = formatSize(size)
            DispatchQueue.main.sync {
                self.sizeMenuItem?.title = "DerivedData size: \(formatedSize)"
            }
        } catch let error {
            print("Error: \(error)")
        }
    }
    
    func updateLoginButton() {
        let theStr2 = doShellScript()
        if theStr2.contains("CleanXcode") {
            loginMenuItem?.state = .on
        } else {
            loginMenuItem?.state = .off
        }
    }
    
    @objc
    func startAtLogin() {
        let theStr = doShellScript()
        if theStr.contains("CleanXcode") {
            let theCmd4 = "tell application \"System Events\" to delete login item \"CleanXcode\""
            doScriptScript(source: theCmd4)
        } else {
            let theCmd1 = "tell application \"System Events\" to make login item at end with properties {path:\""
            let theCmd2 = "\", hidden:false}"
            let thePath = Bundle.main.bundlePath
            doScriptScript(source: (theCmd1 + thePath + theCmd2))
        }
        
        updateLoginButton()
    }
    
    func doShellScript() -> String {
        let theLP = "/usr/bin/osascript"
        let theParms = ["-e", "tell application \"System Events\" to get the name of every login item"]
        let task = Process()
        task.launchPath = theLP
        task.arguments = theParms
        let outPipe = Pipe()
        task.standardOutput = outPipe
        task.launch()
        let fileHandle = outPipe.fileHandleForReading
        let data = fileHandle.readDataToEndOfFile()
        task.waitUntilExit()
        let status = task.terminationStatus
        if (status != 0) {
            return "Failed, error = " + String(status)
        } else {
            return (NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String)
        }
    }
    
    func doScriptScript(source: String) {
        if let appleScript = NSAppleScript(source: source) {
            var errorDict: NSDictionary? = nil
            var _ = appleScript.executeAndReturnError(&errorDict)
        }
    }
}

