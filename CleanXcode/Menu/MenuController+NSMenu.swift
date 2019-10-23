//
//  MenuController+NSMenuDelegate.swift
//  CleanXcode
//
//  Created by Itay Brenner on 10/23/19.
//  Copyright © 2019 Itay Brenner. All rights reserved.
//

import Cocoa

extension MenuController: NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        if lastSize.count > 0 {
            let derivedData = NSLocalizedString(Strings.MenuRowSize, comment: "")
            sizeMenuItem.title = "\(derivedData) \(lastSize)"
        }
        DispatchQueue.global().async {
            self.updateSize()
        }
    }
}
