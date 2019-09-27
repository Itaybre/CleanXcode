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
    let helperBundleName = "com.itaysoft.CleanXcodeHelper"
    let autoLoginKey = "AutoLogin"
    
    func loginEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: autoLoginKey)
    }
    
    func setLoginEnabled(_ enabled: Bool) {
        let success = SMLoginItemSetEnabled(helperBundleName as CFString, enabled)
        if success {
            UserDefaults.standard.set(enabled, forKey: autoLoginKey)
        }
    }
}
