//
//  AppDelegate.swift
//  Luade
//
//  Created by Adrian Labbe on 11/25/18.
//  Copyright © 2018 Adrian Labbe. All rights reserved.
//

import UIKit
import ios_system

/// The app's delegate
@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        UIMenuController.shared.menuItems = [
            UIMenuItem(title: Localizable.MenuItems.open, action: #selector(FileCollectionViewCell.open(_:))),
            UIMenuItem(title: Localizable.MenuItems.run, action: #selector(FileCollectionViewCell.run(_:))),
            UIMenuItem(title: Localizable.MenuItems.rename, action: #selector(FileCollectionViewCell.rename(_:))),
            UIMenuItem(title: Localizable.MenuItems.remove, action: #selector(FileCollectionViewCell.remove(_:))),
            UIMenuItem(title: Localizable.MenuItems.copy, action: #selector(FileCollectionViewCell.copyFile(_:))),
            UIMenuItem(title: Localizable.MenuItems.move, action: #selector(FileCollectionViewCell.move(_:)))
        ]
        
        initializeEnvironment()
    }
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
}

