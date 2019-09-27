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
    
    let menuController: MenuController = MenuController()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
        if let button = statusBarItem.button {
            button.image = NSImage(named:NSImage.Name("icon"))
            button.image?.isTemplate = true
        }
        statusBarItem.menu = menuController.getMenu()
    }
}

