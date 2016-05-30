//
//  LXFColorLinkedConsole.swift
//
//  Created by LXF on 16/5/30.
//  Copyright © 2016年 LXF. All rights reserved.
//

import AppKit

var sharedPlugin: LXFColorLinkedConsole?

class LXFColorLinkedConsole: NSObject {

    internal struct Strings {
        static let linkedFileName = "LXFColorLinkedConsoleFileName"
        static let linkedLine = "LXFColorLinkedConsoleLine"
    }
    
    var bundle: NSBundle
    lazy var center = NSNotificationCenter.defaultCenter()

    // MARK: - Initialization

    class func pluginDidLoad(bundle: NSBundle) {
        let allowedLoaders = bundle.objectForInfoDictionaryKey("me.delisa.XcodePluginBase.AllowedLoaders") as! Array<String>
        if allowedLoaders.contains(NSBundle.mainBundle().bundleIdentifier ?? "") {
            sharedPlugin = LXFColorLinkedConsole(bundle: bundle)
        }
    }

    init(bundle: NSBundle) {
        self.bundle = bundle

        super.init()
        // NSApp may be nil if the plugin is loaded from the xcodebuild command line tool
        if (NSApp != nil && NSApp.mainMenu == nil) {
            center.addObserver(self, selector: #selector(self.applicationDidFinishLaunching), name: NSApplicationDidFinishLaunchingNotification, object: nil)
             center.addObserver(self, selector: #selector(LXFColorLinkedConsole.didChange(_:)), name: "IDEControlGroupDidChangeNotificationName", object: nil)
        } else {
            initializeAndLog()
        }
    }

    private func initializeAndLog() {
        let name = bundle.objectForInfoDictionaryKey("CFBundleName")
        let version = bundle.objectForInfoDictionaryKey("CFBundleShortVersionString")
        let status = initialize() ? "loaded successfully" : "failed to load"
        NSLog("🔌 Plugin \(name) \(version) \(status)")
    }

    func applicationDidFinishLaunching() {
        center.removeObserver(self, name: NSApplicationDidFinishLaunchingNotification, object: nil)
        initializeAndLog()
    }
    
    deinit {
        center.removeObserver(self,name: "IDEControlGroupDidChangeNotificationName",object: nil)
    }
    
    // MARK: - Implementation

    func initialize() -> Bool {
//        guard let mainMenu = NSApp.mainMenu else { return false }
//        guard let item = mainMenu.itemWithTitle("Edit") else { return false }
//        guard let submenu = item.submenu else { return false }
//
//        let actionMenuItem = NSMenuItem(title:"Do Action", action:#selector(self.doMenuAction), keyEquivalent:"")
//        actionMenuItem.target = self
//
//        submenu.addItem(NSMenuItem.separatorItem())
//        submenu.addItem(actionMenuItem)
        swizzleMethods()
        return true
    }

    func doMenuAction() {
        let error = NSError(domain: "Hello World!", code:42, userInfo:nil)
        NSAlert(error: error).runModal()
    }
    
    func swizzleMethods() {
        guard let storageClass = NSClassFromString("NSTextStorage") as? NSObject.Type,
            let textViewClass = NSClassFromString("NSTextView") as? NSObject.Type else {
                return
        }
        
        do {
            try storageClass.jr_swizzleMethod(#selector(NSMutableAttributedString.fixAttributesInRange(_:)), withMethod: Selector("kz_fixAttributesInRange:"))
            try textViewClass.jr_swizzleMethod(#selector(NSResponder.mouseDown(_:)), withMethod: Selector("kz_mouseDown:"))
        }
        catch {
            Swift.print("Swizzling failed")
        }
    }
    func didChange(notification: NSNotification) {
        guard let consoleTextView = KZPluginHelper.consoleTextView(),
            let textStorage = consoleTextView.valueForKey("textStorage") as? NSTextStorage else {
                return
        }
        consoleTextView.linkTextAttributes = [
            NSCursorAttributeName: NSCursor.pointingHandCursor(),
            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue
        ]
        textStorage.kz_isUsedInXcodeConsole = true
    }

}

