//
//  AppDelegate.swift
//  Luade
//
//  Created by Adrian Labbe on 11/25/18.
//  Copyright © 2018 Adrian Labbe. All rights reserved.
//

import UIKit
import ios_system

/// The URL for shared scripts URL.
let sharedScriptsURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.luade.sharing")?.appendingPathComponent("Documents/Share Sheet") ?? FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)[0]

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
        
        window?.accessibilityIgnoresInvertColors = true
        
        initializeEnvironment()
        
        #if MAINAPP
        ReviewHelper.shared.launches += 1
        ReviewHelper.shared.requestReview()
        #endif
        
        if !FileManager.default.fileExists(atPath: sharedScriptsURL.path) {
            do {
                try FileManager.default.createDirectory(at: sharedScriptsURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        if let shareSheetExampleURL = Bundle.main.url(forResource: "Share Sheet Example", withExtension: "lua") {

            let newShareSheetExampleURL = sharedScriptsURL.appendingPathComponent("Example.lua")
            
            do {
                if FileManager.default.fileExists(atPath: newShareSheetExampleURL.path) {
                    try FileManager.default.removeItem(at: newShareSheetExampleURL)
                }
                
                try FileManager.default.copyItem(at: shareSheetExampleURL, to: newShareSheetExampleURL)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        if let shareSheetREADMEURL = Bundle.main.url(forResource: "Share Sheet README", withExtension: "lua") {
            
            let newShareSheetREADMEURL = sharedScriptsURL.appendingPathComponent("README.lua")
            
            do {
                if FileManager.default.fileExists(atPath: newShareSheetREADMEURL.path) {
                    try FileManager.default.removeItem(at: newShareSheetREADMEURL)
                }
                
                try FileManager.default.copyItem(at: shareSheetREADMEURL, to: newShareSheetREADMEURL)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        let docBrowser = DocumentBrowserViewController.visible
        let root = application.keyWindow?.rootViewController
        
        func runScript() {
            if let path = userActivity.userInfo?["filePath"] as? String {
                
                let url = URL(fileURLWithPath: RelativePathForScript(URL(fileURLWithPath: path)), relativeTo: FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first)
                
                if FileManager.default.fileExists(atPath: url.path) {
                    docBrowser?.openDocument(url, run: true)
                } else {
                    let alert = UIAlertController(title: Localizable.Errors.errorReadingFile, message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: Localizable.ok, style: .cancel, handler: nil))
                    root?.present(alert, animated: true, completion: nil)
                }
            } else {
                print("Invalid shortcut!")
            }
        }
        
        if root?.presentedViewController != nil {
            application.keyWindow?.rootViewController?.dismiss(animated: true, completion: {
                runScript()
            })
        } else {
            runScript()
        }
        
        return true
    }
}

