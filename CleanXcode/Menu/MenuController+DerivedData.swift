//
//  MenuController+DerivedData.swift
//  CleanXcode
//
//  Created by Itay Brenner on 10/23/19.
//  Copyright © 2019 Itay Brenner. All rights reserved.
//

import Foundation

extension MenuController: DerivedDataManagerDelegate {
    func directoryCleaned() {
        let title = NSLocalizedString(Strings.NotificationTitleSuccess, comment: "")
        let baseMessage = NSLocalizedString(Strings.NotificationMessageSuccess, comment: "")
        let message = String.init(format: baseMessage, lastSize)
        notificationHelper.show(title: title, message: message)
    }
    
    func errorCleaning(error: String) {
        let title = NSLocalizedString(Strings.NotificationTitleSuccess, comment: "")
        let baseMessage = NSLocalizedString(Strings.NotificationMessageError, comment: "")
        let message = String.init(format: baseMessage, error)
        notificationHelper.show(title: title, message: message)
    }
}
