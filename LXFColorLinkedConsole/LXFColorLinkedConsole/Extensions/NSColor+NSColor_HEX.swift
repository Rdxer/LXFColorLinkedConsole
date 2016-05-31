//
//  NSColor+NSColor_HEX.swift
//  LXFColorLinkedConsole
//
//  Created by LXF on 16/5/30.
//  Copyright © 2016年 LXF. All rights reserved.
//

import Foundation
import AppKit


func colorComponentFrom(string:String,start:Int,length:Int) -> CGFloat {
    let substring = (string as NSString).substringWithRange(NSMakeRange(start, length))
    let fullHex = length == 2 ? substring : (substring + substring)
    
    var hexComponent:UInt32 = 0
    NSScanner.init(string: fullHex).scanHexInt(&hexComponent)
    return CGFloat(hexComponent) / 255.0
}

extension NSColor {
    public static func color(colorWithHEXString HEXString:String)->NSColor?{
        
        var HEXStr = (HEXString as NSString).stringByReplacingOccurrencesOfString("#", withString: "")
        HEXStr = HEXStr.uppercaseString
        var alpha:CGFloat = 1
        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 0
        
        switch HEXStr.characters.count {
        case 3:
            alpha = 1
            red = colorComponentFrom(HEXStr, start: 0, length: 1)
            green = colorComponentFrom(HEXStr, start: 1, length: 1)
            blue = colorComponentFrom(HEXStr, start: 2, length: 1)
        case 4:
            alpha = colorComponentFrom(HEXStr, start: 0, length: 1)
            red = colorComponentFrom(HEXStr, start: 1, length: 1)
            green = colorComponentFrom(HEXStr, start: 2, length: 1)
            blue = colorComponentFrom(HEXStr, start: 3, length: 1)
        case 6:
            alpha = 1
            red = colorComponentFrom(HEXStr, start: 0, length: 2)
            green = colorComponentFrom(HEXStr, start: 2, length: 2)
            blue = colorComponentFrom(HEXStr, start: 4, length: 2)
        case 8:
            alpha = colorComponentFrom(HEXStr, start: 0, length: 2)
            red = colorComponentFrom(HEXStr, start: 2, length: 2)
            green = colorComponentFrom(HEXStr, start: 4, length: 2)
            blue = colorComponentFrom(HEXStr, start: 6, length: 2)
        default:
            return nil
        }
        return NSColor(calibratedRed: red, green: green, blue: blue, alpha: alpha)
    }
}
