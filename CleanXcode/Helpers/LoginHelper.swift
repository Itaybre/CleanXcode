//
//  LoginHelper.swift
//  CleanXcode
//
//  Created by Itay Brenner on 9/18/19.
//  Copyright © 2019 Itay Brenner. All rights reserved.
//

import Cocoa
import ServiceManagement

class LoginHelper {
    func loginEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: Constants.AutoLoginKey)
    }
    
    func setLoginEnabled(_ enabled: Bool) {
        let success = SMLoginItemSetEnabled(Constants.HelperBundleName as CFString, enabled)
        if success {
            UserDefaults.standard.set(enabled, forKey: Constants.AutoLoginKey)
        }
    }
}
