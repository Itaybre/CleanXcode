//
//  NotificationHelper.swift
//  CleanXcode
//
//  Created by Itay Brenner on 9/18/19.
//  Copyright © 2019 Itay Brenner. All rights reserved.
//

import Cocoa

class NotificationHelper: NSObject, NSUserNotificationCenterDelegate {
    func show(title: String, message: String) -> Void {
        let notification = NSUserNotification()
        notification.title = title
        notification.informativeText = message
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.deliver(notification)
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true;
    }
}
