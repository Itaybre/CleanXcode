//
//  MenuController.swift
//  CleanXcode
//
//  Created by Itay Brenner on 9/18/19.
//  Copyright © 2019 Itay Brenner. All rights reserved.
//

import Cocoa

class MenuController: NSObject {
    let notificationHelper: NotificationHelper = NotificationHelper()
    let derivedDataHelper: DerivedDataHelper = DerivedDataHelper()
    let menuBuilder: MenuBuilder = MenuBuilder()
    let loginHelper: LoginHelper = LoginHelper()
    
    var sizeMenuItem: NSMenuItem!
    var loginMenuItem: NSMenuItem!
    var lastSize: String = ""
    
    override init() {
        super.init()
        self.derivedDataHelper.delegate = self
        NSUserNotificationCenter.default.delegate = notificationHelper
    }
    
    func getMenu() -> NSMenu {
        sizeMenuItem = menuBuilder.buildSizeItem(self)
        let cleanItem = menuBuilder.buildCleanItem(self)
        let separator = menuBuilder.buildSeparator()
        loginMenuItem = menuBuilder.buildLoginItem(self)
        let separator2 = menuBuilder.buildSeparator()
        let closeItem = menuBuilder.buildCloseItem(self)
        
        let menu = menuBuilder.buildMenu(self,
                                         items: [sizeMenuItem, cleanItem, separator, loginMenuItem, separator2, closeItem])
        
        updateLoginButton()
        preloadSize()
        
        return menu
    }
    
    func preloadSize() {
        DispatchQueue.global().async {
            self.lastSize = self.derivedDataHelper.formatedSize()
        }
    }
    
    @objc
    public func cleanDerivedData() {
        derivedDataHelper.clean()
    }
    
    func updateLoginButton() {
        loginMenuItem?.state = loginHelper.loginEnabled() ? .on : .off
    }
    
    @objc
    func startAtLogin() {
        loginHelper.setLoginEnabled(!loginHelper.loginEnabled())
        updateLoginButton()
    }
    
    @objc
    public func exitApp() {
        NSApplication.shared.terminate(nil)
    }
    
    func updateSize() {
        lastSize = derivedDataHelper.formatedSize()
        DispatchQueue.main.sync {
            self.sizeMenuItem.title = "DerivedData size: \(lastSize)"
        }
    }
}

extension MenuController: NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        if lastSize.count > 0 {
            sizeMenuItem.title = "DerivedData size: \(lastSize)"
        }
        DispatchQueue.global().async {
            self.updateSize()
        }
    }
}

extension MenuController: DerivedDataHelperDelegate {
    func directoryCleaned() {
        notificationHelper.show(title: "Success", message: "Successfuly cleared \(lastSize) of space")
    }
    
    func errorCleaning(error: String) {
        notificationHelper.show(title: "Error", message: "Error while cleaning DerivedData: \(error)")
    }
}
