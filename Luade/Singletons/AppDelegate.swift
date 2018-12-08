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
                if FileManager.default.fileExists(atPath: newShareSheetExampleURL.path), let defaultData = (try? Data(contentsOf: shareSheetExampleURL)), let data = (try? Data(contentsOf: newShareSheetExampleURL)), defaultData == data  {
                    try FileManager.default.removeItem(at: newShareSheetExampleURL)
                }
                
                // try FileManager.default.copyItem(at: shareSheetExampleURL, to: newShareSheetExampleURL)
                // Removed!
            } catch {
                print(error.localizedDescription)
            }
        }
        
        if let shareSheetREADMEURL = Bundle.main.url(forResource: "Share Sheet README", withExtension: "lua") {
            
            let newShareSheetREADMEURL = sharedScriptsURL.appendingPathComponent("README.lua")
            
            do {
                if FileManager.default.fileExists(atPath: newShareSheetREADMEURL.path), let defaultData = (try? Data(contentsOf: shareSheetREADMEURL)), let data = (try? Data(contentsOf: newShareSheetREADMEURL)), defaultData == data {
                    try FileManager.default.removeItem(at: newShareSheetREADMEURL)
                }
                
                // try FileManager.default.copyItem(at: shareSheetREADMEURL, to: newShareSheetREADMEURL)
                // Removed!
            } catch {
                print(error.localizedDescription)
            }
        }
        
        let docs = DocumentBrowserViewController.localContainerURL
        let iCloudDriveContainer = DocumentBrowserViewController.iCloudContainerURL
        
        if let iCloudURL = iCloudDriveContainer {
            if !FileManager.default.fileExists(atPath: iCloudURL.path) {
                try? FileManager.default.createDirectory(at: iCloudURL, withIntermediateDirectories: true, attributes: nil)
            }
            
            for file in ((try? FileManager.default.contentsOfDirectory(at: docs, includingPropertiesForKeys: nil, options: .init(rawValue: 0))) ?? []) {
                
                try? FileManager.default.moveItem(at: file, to: iCloudURL.appendingPathComponent(file.lastPathComponent))
            }
        }
    }
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ app: UIApplication, open inputURL: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        
        guard let documentBrowserViewController = DocumentBrowserViewController.visible else {
            window?.rootViewController?.dismiss(animated: true, completion: {
                _ = self.application(app, open: inputURL, options: options)
            })
            return true
        }
        
        // Ensure the URL is a file URL
        guard inputURL.isFileURL else {
            return false
        }
        
        // Reveal / import the document at the URL
        
        documentBrowserViewController.openDocument(inputURL, run: false)
        
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        let root = application.keyWindow?.rootViewController
        
        func runScript() {
            if let path = userActivity.userInfo?["filePath"] as? String {
                
                let url = URL(fileURLWithPath: RelativePathForScript(URL(fileURLWithPath: path)).replacingFirstOccurrence(of: "iCloud/", with: (DocumentBrowserViewController.iCloudContainerURL?.path ?? DocumentBrowserViewController.localContainerURL.path)+"/"), relativeTo: FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first)
                
                if FileManager.default.fileExists(atPath: url.path) {
                    DocumentBrowserViewController.visible?.openDocument(url, run: true)
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
            root?.dismiss(animated: true, completion: {
                runScript()
            })
        } else {
            runScript()
        }
        
        return true
    }
}

