//
//  IO.swift
//  Pyto
//
//  Created by Adrian Labbe on 9/24/18.
//  Copyright © 2018 Adrian Labbé. All rights reserved.
//

import UIKit

extension FileHandle {
    
    /// Writes given string to the file.
    ///
    /// - Parameters:
    ///     - str: Text to print.
    func write(_ str: String) {
        if let data = str.data(using: .utf8) {
            write(data)
        }
    }
}

/// A class for managing input and output.
class IO {
    
    /// Initialize for writting to the given terminal.
    ///
    /// - Parameters:
    ///     - console: The terminal that receives output.
    init() {
        stdout = fdopen(outputPipe.fileHandleForWriting.fileDescriptor, "w")
        stderr = fdopen(errorPipe.fileHandleForWriting.fileDescriptor, "w")
        stdin = fdopen(inputPipe.fileHandleForReading.fileDescriptor, "r")
        outputPipe.fileHandleForReading.readabilityHandler = { handle in
            if let str = String(data: handle.availableData, encoding: .utf8) {
                print(str, terminator: "")
                DispatchQueue.main.async {
                    self.console?.textView?.text.append(str)
                    self.console?.textView?.scrollToBottom()
                    self.console?.console += str
                }
            }
        }
        errorPipe.fileHandleForReading.readabilityHandler = outputPipe.fileHandleForReading.readabilityHandler
        setbuf(stdout!, nil)
        setbuf(stderr!, nil)
    }
    
    /// The shared instance.
    static let shared = IO()
    
    /// The Console view controller that receives.
    var console: ConsoleViewController?
    
    /// The stdin file.
    var stdin: UnsafeMutablePointer<FILE>?
    
    /// The stdout file.
    var stdout: UnsafeMutablePointer<FILE>?
    
    /// The stderr file.
    var stderr: UnsafeMutablePointer<FILE>?
    
    /// The output pipe.
    var outputPipe = Pipe()
    
    /// The error pipe.
    var errorPipe = Pipe()
    
    /// The input pipe.
    var inputPipe = Pipe()
    
    /// Sends given input for current running `ios_system` command.
    ///
    /// - Parameters:
    ///     - input: Input to send.
    func send(input: String) {
        if let data = input.data(using: .utf8) {
            inputPipe.fileHandleForWriting.write(data)
        }
    }
}
