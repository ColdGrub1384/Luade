//
//  LuaDelegate.swift
//  Luade
//
//  Created by Adrian Labbe on 11/28/18.
//  Copyright © 2018 Adrian Labbe. All rights reserved.
//

import Foundation

/// The delegate for `Lua` singleton.
///
/// All theses methods are called from the Lua queue, so you should return to the main thread to touch the UI.
protocol LuaDelegate {
    
    /// Called when Lua will start a script.
    ///
    /// - Parameters:
    ///     - lua: The Lua instance.
    ///     - arguments: The arguments send to the main function.
    func lua(_ lua: Lua, willStartScriptWithArguments arguments: [String])
    
    /// Called when Lua will start the REPL.
    ///
    /// - Parameters:
    ///     - lua: The Lua instance.
    func luaWillStartREPL(_ lua: Lua)
    
    /// Called when Lua exited.
    ///
    /// - Parameters:
    ///     - lua: The Lua instance.
    ///     - code: The exit code returned by lua.
    func lua(_ lua: Lua, didExitWithCode code: Int32)
}
