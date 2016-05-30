//
//  NSTextStorage+XcodeColors.h
//  LXFColorLinkedConsole
//
//  Created by LXF on 16/5/30.
//  Copyright © 2016年 LXF. All rights reserved.
//

#import <Cocoa/Cocoa.h>





@interface NSTextStorage (XcodeColors)

-(void)applyANSIColors:(NSRange)textStorageRange;

@end
