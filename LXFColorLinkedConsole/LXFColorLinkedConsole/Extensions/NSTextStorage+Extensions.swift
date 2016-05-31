//
// Created by Krzysztof Zabłocki on 05/12/15.
// Copyright (c) 2015 pixle. All rights reserved.
//

import Foundation
import AppKit

extension NSTextStorage {

    private struct AssociatedKeys {
        static var isConsoleKey = "isConsoleKey"
    }

    var kz_isUsedInXcodeConsole: Bool {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.isConsoleKey) as? NSNumber else {
                return false
            }

            return value.boolValue
        }

        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isConsoleKey, NSNumber(bool: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func kz_fixAttributesInRange(range: NSRange) {
        kz_fixAttributesInRange(range) //! call original implementation first

        if !self.kz_isUsedInXcodeConsole {
            return
        }

        injectLinksIntoLogs(range)
        applyANSIColors(range)
    }
    private func injectLinksIntoLogs(range: NSRange) {
        let text = string as NSString
        let matches = pattern.matchesInString(string, options: .ReportProgress, range: NSRange(location: 0, length: text.length))
        for result in matches where result.numberOfRanges == 14{
            
            var index = 0
            
            let fullRange = result.rangeAtIndex(index)
            index += 1
            
            let prefixRange = result.rangeAtIndex(index)
            index += 1
            let fileNameRange = result.rangeAtIndex(index)
            index += 1
            let fileNameEXRange = result.rangeAtIndex(index)
            index += 1
            let lineNumRange = result.rangeAtIndex(index)
            index += 1
            
            
            let tfgRange = result.rangeAtIndex(index)
            index += 1
            let tbgRange = result.rangeAtIndex(index)
            index += 1
            let cfgRange = result.rangeAtIndex(index)
            index += 1
            let cbgRange = result.rangeAtIndex(index)
            index += 1
            
            let fulltitleRange = result.rangeAtIndex(index)
            index += 1
            let titleRange = result.rangeAtIndex(index)
            index += 1
            let showLineNumRange = result.rangeAtIndex(index)
            index += 1
            
            
            let fullContentRange = result.rangeAtIndex(index)
            index += 1
            let suffixRange = result.rangeAtIndex(index)
            
            let fileName = "\(text.substringWithRange(fileNameRange)).\(text.substringWithRange(fileNameEXRange))"
            let lineNum = text.substringWithRange(lineNumRange)
            
            let tfg = text.substringWithRange(tfgRange)
            let tbg = text.substringWithRange(tbgRange)
            let cfg = text.substringWithRange(cfgRange)
            let cbg = text.substringWithRange(cbgRange)
            
            let title = text.substringWithRange(titleRange)
            let showLineNum = text.substringWithRange(showLineNumRange)
            let fullContent = text.substringWithRange(fullContentRange)
            
            
            print(fileName+"_"+lineNum+"_"+tfg+"_"+tbg+"_"+cfg+"_"+cbg+"_"+title+"_"+showLineNum+"_"+fullContent)
            
            // link
            addAttribute(NSLinkAttributeName, value: "", range: fulltitleRange)
            addAttribute(LXFColorLinkedConsole.Strings.linkedFileName, value: fileName, range: fulltitleRange)
            addAttribute(LXFColorLinkedConsole.Strings.linkedLine, value: lineNum, range: fulltitleRange)
            
            // hide prefix
            addAttribute(NSFontAttributeName, value:NSFont.systemFontOfSize(0.0001), range: prefixRange)
            addAttribute(NSForegroundColorAttributeName, value: NSColor.clearColor(), range: prefixRange)
            // hide suffix
            addAttribute(NSFontAttributeName, value:NSFont.systemFontOfSize(0.0001), range: suffixRange)
            addAttribute(NSForegroundColorAttributeName, value: NSColor.clearColor(), range: suffixRange)
            
            
            // addAttribute title / fbg
            if let v = NSColor.color(colorWithHEXString: tfg){
                addAttribute(NSForegroundColorAttributeName, value: v, range: fulltitleRange)
            }
            if let v = NSColor.color(colorWithHEXString: tbg){
                addAttribute(NSBackgroundColorAttributeName, value: v, range: fulltitleRange)
            }
            
            // addAttribute content / fbg
            if let v = NSColor.color(colorWithHEXString: cfg){
                addAttribute(NSForegroundColorAttributeName, value: v, range: fullContentRange)
            }
            if let v = NSColor.color(colorWithHEXString: cbg){
                addAttribute(NSBackgroundColorAttributeName, value: v, range: fullContentRange)
            }
        }
    }
    
    private var pattern: NSRegularExpression {
          return try! NSRegularExpression(pattern: "(\\$\\((.*?)\\.(.*?)\\,(.*?)\\,(.*?),(.*?),(.*?),(.*?)\\)).((.*?).?\\+ (.*?)) . (.*?)(\\$\\(end\\))", options: .CaseInsensitive)
    }
}


