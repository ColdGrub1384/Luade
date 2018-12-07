//
//  Lua.swift
//  Luade
//
//  Created by Adrian Labbe on 11/27/18.
//  Copyright © 2018 Adrian Labbe. All rights reserved.
//

import ios_system

/// A class representing Lua.
class Lua {
    
    /// Returns the version and copyright of Lua.
    var version: String {
       return String(cString: lua_copyright())
    }
    
    private func setupIOS_SYSTEM(io: IO) {
        if ios_kill() == 0 {
            delegate?.lua(self, didExitWithCode: 9)
        }
        io.inputPipe = Pipe()
        io.stdin = fdopen(io.inputPipe.fileHandleForReading.fileDescriptor, "r")
        stdin = io.stdin ?? stdin
        
        ios_switchSession(io.stdout)
        ios_setStreams(io.stdin, io.stdout, io.stderr)
    }
    
    /// The queue running Lua.
    let queue = DispatchQueue.global(qos: .userInteractive)
    
    /// Returns `true` if Lua is running.
    private(set) var isRunning = false
    
    /// Runs the given script.
    ///
    /// - Parameters:
    ///     - script: The path of the script to run.
    ///     - io: The I/O stream to use.
    func run(script: String, withIO io: IO) {
        queue.async {
            self.setupIOS_SYSTEM(io: io)
            ios_setDirectoryURL(URL(fileURLWithPath: script).deletingLastPathComponent())
            self.delegate?.lua(self, willStartScriptWithArguments: [script])
            self.isRunning = true
            self.delegate?.lua(self, didExitWithCode: ios_system("lua '\(script)'"))
            self.isRunning = false
        }
    }
    
    /// Runs the REPL.
    ///
    /// - Parameters:
    ///     - io: The I/O stream to use.
    func runREPL(withIO io: IO) {
        queue.async {
            self.setupIOS_SYSTEM(io: io)
            ios_setDirectoryURL(FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)[0])
            self.delegate?.luaWillStartREPL(self)
            self.delegate?.lua(self, didExitWithCode: ios_system("lua"))
        }
    }
    
    /// The delegate.
    var delegate: LuaDelegate?
    
    // MARK: - Singleton
    
    /// The shared and unique instance.
    static let shared = Lua()
    
    private init() {}
}
