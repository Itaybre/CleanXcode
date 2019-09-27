//
//  MenuBuilder.swift
//  CleanXcode
//
//  Created by Itay Brenner on 9/18/19.
//  Copyright © 2019 Itay Brenner. All rights reserved.
//

import Cocoa

class MenuBuilder {
    func buildMenu(_ controller: MenuController, items: [NSMenuItem]) -> NSMenu {
        let menu = NSMenu.init(title: "Menu")
        menu.delegate = controller
        
        for item in items {
            menu.addItem(item)
        }
        return menu
    }
    
    func buildSizeItem(_ controller: MenuController) -> NSMenuItem {
        return NSMenuItem.init(title: "Calculating size...",
                               action: nil,
                               keyEquivalent: "")
    }
    
    func buildCleanItem(_ controller: MenuController) -> NSMenuItem {
        let cleanItem = NSMenuItem.init(title: "Clean DerivedData",
                                        action: #selector(controller.cleanDerivedData),
                                        keyEquivalent: "c")
        cleanItem.keyEquivalentModifierMask = [.command, .control, .option]
        cleanItem.target = controller
        return cleanItem
    }
    
    func buildLoginItem(_ controller: MenuController) -> NSMenuItem {
        let item = NSMenuItem.init(title: "Start at Login",
                               action: #selector(controller.startAtLogin),
                               keyEquivalent: "")
        item.target = controller
        return item
    }
    
    func buildCloseItem(_ controller: MenuController) -> NSMenuItem {
        let item = NSMenuItem.init(title: "Quit",
                               action: #selector(controller.exitApp),
                               keyEquivalent: "q")
        item.target = controller
        return item
    }
    
    func buildSeparator() -> NSMenuItem {
        return NSMenuItem.separator()
    }
}
