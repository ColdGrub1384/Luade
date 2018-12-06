//
//  REPLConsoleViewController.swift
//  Luade
//
//  Created by Adrian Labbe on 11/25/18.
//  Copyright © 2018 Adrian Labbe. All rights reserved.
//

import UIKit
import ios_system

/// The View controller for interacting for the REPL.
class REPLConsoleViewController: ConsoleViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = []
        
        title = "REPL"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.text = ""
        console = ""
        
        Lua.shared.delegate = self
        Lua.shared.runREPL(withIO: IO.shared)
    }
}
