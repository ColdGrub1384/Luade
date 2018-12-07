//
//  LuaLexer.swift
//  Luade
//
//  Created by Adrian Labbe on 11/27/18.
//  Copyright © 2018 Adrian Labbe. All rights reserved.
//

import SourceEditor
import SavannaKit

/// A lexer for Lua.
class LuaLexer: SourceCodeRegexLexer {
    
    /// Lua keywords.
    let keywords = "and break do else elseif end false for function if in local nil not or repeat return then true until while".components(separatedBy: " ")
    
    lazy private var generators: [TokenGenerator] = {
        
        var generators = [TokenGenerator?]()
        // Functions
        generators.append(regexGenerator("(\\bprint(?=\\())|(\\brequire(?=\\())", tokenType: .identifier))
        
        generators.append(regexGenerator("(?<=[^a-zA-Z])\\d+", tokenType: .number))
        
        generators.append(regexGenerator("\\.\\w+", tokenType: .identifier))
        
        generators.append(keywordGenerator(keywords, tokenType: .keyword))
        
        // Line comment
        generators.append(regexGenerator("--(.*)", tokenType: .comment))
        
        // Block comment or multi-line string literal
        generators.append(regexGenerator("--[[.*--]])", options: [.dotMatchesLineSeparators], tokenType: .comment))
        
        // Single-line string literal
        generators.append(regexGenerator("('.*')|(\".*\")", tokenType: .string))
        
        // Editor placeholder
        var editorPlaceholderPattern = "(<#)[^\"\\n]*"
        editorPlaceholderPattern += "(#>)"
        generators.append(regexGenerator(editorPlaceholderPattern, tokenType: .editorPlaceholder))
        
        return generators.compactMap( { $0 })
    }()
    
    public func generators(source: String) -> [TokenGenerator] {
        return generators
    }
}
