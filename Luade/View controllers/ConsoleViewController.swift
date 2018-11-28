//
//  ConsoleViewController.swift
//  Pyto
//
//  Created by Adrian Labbe on 9/8/18.
//  Copyright © 2018 Adrian Labbé. All rights reserved.
//

import UIKit
import ios_system
import FloatingPanel

/// A View controller containing Lua script output.
class ConsoleViewController: UIViewController, UITextViewDelegate, LuaDelegate {
    
    /// The current prompt.
    var prompt = ""
    
    /// The content of the console.
    var console = ""
    
    /// Set to `true` for asking the user for input.
    var isAskingForInput = false
    
    /// The Text view containing the console.
    var textView: ConsoleTextView!
    
    /// If set to `true`, the user will not be able to input.
    var ignoresInput = false
    
    /// The floating panel in wich this View controller is embedded in.
    var floatingPanel: FloatingPanelController?
    
    /// Requests the user for input.
    ///
    /// - Parameters:
    ///     - prompt: The prompt from the Lua function
    func input(prompt: String) {
        
        guard !ignoresInput else {
            return
        }
        
        textView.text += prompt
        isAskingForInput = true
        textView.isEditable = true
        textView.becomeFirstResponder()
    }
    
    /// Closes the View controller or dismisses keyboard.
    @objc func close() {
        
        if textView.isFirstResponder {
            textView.resignFirstResponder()
        } else {
            extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
            dismiss(animated: true, completion: nil)
        }
    }
    
    deinit {        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - View controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = []
        
        title = "Console"
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(close))]
        
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        effectView.frame = view.frame
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(effectView)
        view.backgroundColor = .clear
        
        textView = ConsoleTextView()
        textView.text = "\n"
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        view.addSubview(textView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        IO.shared.console = self
        textView.frame = view.safeAreaLayoutGuide.layoutFrame
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        guard view != nil else {
            return
        }
        
        let wasFirstResponder = textView.isFirstResponder
        textView.resignFirstResponder()
        
        _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.textView.frame = self.view.safeAreaLayoutGuide.layoutFrame
            if wasFirstResponder {
                self.textView.becomeFirstResponder()
            }
        }) // TODO: Anyway to to it without a timer?
    }
    
    // MARK: - Keyboard
    
    @objc func keyboardWillShow(_ notification:Notification) {
        let d = notification.userInfo!
        var r = d[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        
        r = textView.convert(r, from:nil)
        textView.contentInset.bottom = r.size.height
        textView.scrollIndicatorInsets.bottom = r.size.height
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        textView.contentInset = .zero
        textView.scrollIndicatorInsets = .zero
    }
    
    // MARK: - Text view delegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if floatingPanel?.position != FloatingPanelPosition.full {
            floatingPanel?.move(to: .full, animated: true)
        }
        
        _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            textView.selectedTextRange = textView.textRange(from: textView.endOfDocument, to: textView.endOfDocument)
        })
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard Lua.shared.isRunning else {
            textView.resignFirstResponder()
            return false
        }
        
        let location:Int = textView.offset(from: textView.beginningOfDocument, to: textView.endOfDocument)
        let length:Int = textView.offset(from: textView.endOfDocument, to: textView.endOfDocument)
        let end =  NSMakeRange(location, length)
        
        if end != range && !(text == "" && range.length == 1 && range.location+1 == end.location) {
            // Only allow inserting text from the end
            return false
        }
        
        if (textView.text as NSString).replacingCharacters(in: range, with: text).count >= console.count {
            prompt += text
            
            if text == "\n" {
                if let data = prompt.data(using: .utf8) {
                    IO.shared.inputPipe.fileHandleForWriting.write(data)
                }
                prompt = ""
                isAskingForInput = false
                textView.text += "\n"
                
                return false
            } else if text == "" && range.length == 1 {
                prompt = String(prompt.dropLast())
            }
            
            return true
        }
        
        return false
    }
    
    // MARK: - Lua delegate
    
    func lua(_ lua: Lua, willStartScriptWithArguments arguments: [String]) {
        DispatchQueue.main.async {
            self.textView.text = "\n"
            self.textView.becomeFirstResponder()
        }
    }
    
    func luaWillStartREPL(_ lua: Lua) {
        DispatchQueue.main.async {
            self.textView.text = "\n"
            self.textView.becomeFirstResponder()
        }
    }
    
    func lua(_ lua: Lua, didExitWithCode code: Int32) {
        DispatchQueue.main.async {
            self.textView.resignFirstResponder()
        }
    }
}
