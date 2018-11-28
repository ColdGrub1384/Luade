//
//  PyDocument.swift
//  Pyto
//
//  Created by Adrian Labbe on 9/8/18.
//  Copyright © 2018 Adrian Labbé. All rights reserved.
//

import UIKit

/// Errors opening the document.
enum LuaDocumentError: Error {
    case unableToParseText
    case unableToEncodeText
}

/// A document representing a Lua script.
class LuaDocument: UIDocument {
    
    /// The text of the Lua script to save.
    var text = ""
    
    override func contents(forType typeName: String) throws -> Any {
        guard let data = text.data(using: .utf8) else {
            throw LuaDocumentError.unableToEncodeText
        }
        
        return data
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        guard let data = contents as? Data else {
            // This would be a developer error.
            fatalError("*** \(contents) is not an instance of NSData.***")
        }
        
        guard let newText = String(data: data, encoding: .utf8) else {
            throw LuaDocumentError.unableToParseText
        }
                
        text = newText
    }
}
