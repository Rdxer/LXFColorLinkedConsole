//
//  NSTextStorage+XcodeColors.m
//  LXFColorLinkedConsole
//
//  Created by LXF on 16/5/30.
//  Copyright © 2016年 LXF. All rights reserved.
//

#import "NSTextStorage+XcodeColors.h"

#define XCODE_COLORS_ESCAPE @"\033["

#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color

#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color


@implementation NSTextStorage (XcodeColors)

-(void)applyANSIColors:(NSRange)textStorageRange{
    ApplyANSIColors(self, textStorageRange,XCODE_COLORS_ESCAPE);
}

void ApplyANSIColors(NSTextStorage *textStorage, NSRange textStorageRange, NSString *escapeSeq){
    NSRange range = [[textStorage string] rangeOfString:escapeSeq options:0 range:textStorageRange];
    if (range.location == NSNotFound)
    {
        // No escape sequence(s) in the string.
        // 没有转意字符串
        return;
    }
    
    NSString *affectedString = [[textStorage string] substringWithRange:textStorageRange];
    
    // Split the string into components separated by the given escape sequence.
    // 分割字符串
    
    NSArray *components = [affectedString componentsSeparatedByString:escapeSeq];
    
    NSRange componentRange = textStorageRange;
    componentRange.length = 0;
    
    BOOL firstPass = YES;
    
    NSMutableArray *seqRanges = [NSMutableArray arrayWithCapacity:[components count]];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithCapacity:2];
    
    for (NSString *component in components)
    {
        if (firstPass)
        {
            // The first component in the array won't need processing.
            // If there was an escape sequence at the very beginning of the string,
            // then the first component in the array will be an empty string.
            // Otherwise the first component is everything before the first escape sequence.
        }
        else
        {
            // componentSeqRange : Range of escape sequence within component, e.g. "fg124,12,12;"
            
            NSColor *color = nil;
            NSUInteger colorCodeSeqLength = 0;
            
            BOOL stop = NO;
            
            BOOL reset = !stop && (stop = [component hasPrefix:@";"]);
            BOOL fg    = !stop && (stop = [component hasPrefix:@"fg"]);
            BOOL bg    = !stop && (stop = [component hasPrefix:@"bg"]);
            
            BOOL resetFg = fg && [component hasPrefix:@"fg;"];
            BOOL resetBg = bg && [component hasPrefix:@"bg;"];
            
            if (reset)
            {
                // Reset attributes
                [attrs removeObjectForKey:NSForegroundColorAttributeName];
                [attrs removeObjectForKey:NSBackgroundColorAttributeName];
                
                // Mark the range of the sequence (escape sequence + reset color sequence).
                NSRange seqRange = (NSRange){
                    .location = componentRange.location - [escapeSeq length],
                    .length = 1 + [escapeSeq length],
                };
                [seqRanges addObject:[NSValue valueWithRange:seqRange]];
            }
            else if (resetFg || resetBg)
            {
                // Reset attributes
                if (resetFg)
                    [attrs removeObjectForKey:NSForegroundColorAttributeName];
                else
                    [attrs removeObjectForKey:NSBackgroundColorAttributeName];
                
                // Mark the range of the sequence (escape sequence + reset color sequence).
                NSRange seqRange = (NSRange){
                    .location = componentRange.location - [escapeSeq length],
                    .length = 3 + [escapeSeq length],
                };
                [seqRanges addObject:[NSValue valueWithRange:seqRange]];
            }
            else if (fg || bg)
            {
                // Looking for something like this: "fg124,22,12;" or "bg17,24,210;".
                // These are the rgb values for the foreground or background.
                
                NSString *str_r = nil;
                NSString *str_g = nil;
                NSString *str_b = nil;
                
                NSRange range_search = NSMakeRange(2, MIN(4, [component length] - 2));
                NSRange range_separator;
                NSRange range_value;
                
                // Search for red separator
                range_separator = [component rangeOfString:@"," options:0 range:range_search];
                if (range_separator.location != NSNotFound)
                {
                    // Extract red substring
                    range_value.location = range_search.location;
                    range_value.length = range_separator.location - range_search.location;
                    
                    str_r = [component substringWithRange:range_value];
                    
                    // Update search range
                    range_search.location = range_separator.location + range_separator.length;
                    range_search.length = MIN(4, [component length] - range_search.location);
                    
                    // Search for green separator
                    range_separator = [component rangeOfString:@"," options:0 range:range_search];
                    if (range_separator.location != NSNotFound)
                    {
                        // Extract green substring
                        range_value.location = range_search.location;
                        range_value.length = range_separator.location - range_search.location;
                        
                        str_g = [component substringWithRange:range_value];
                        
                        // Update search range
                        range_search.location = range_separator.location + range_separator.length;
                        range_search.length = MIN(4, [component length] - range_search.location);
                        
                        // Search for blue separator
                        range_separator = [component rangeOfString:@";" options:0 range:range_search];
                        if (range_separator.location != NSNotFound)
                        {
                            // Extract blue substring
                            range_value.location = range_search.location;
                            range_value.length = range_separator.location - range_search.location;
                            
                            str_b = [component substringWithRange:range_value];
                            
                            // Mark the length of the entire color code sequence.
                            colorCodeSeqLength = range_separator.location + range_separator.length;
                        }
                    }
                }
                
                if (str_r && str_g && str_b)
                {
                    // Parse rgb values and create color
                    
                    int r = MAX(0, MIN(255, [str_r intValue]));
                    int g = MAX(0, MIN(255, [str_g intValue]));
                    int b = MAX(0, MIN(255, [str_b intValue]));
                    
                    color = [NSColor colorWithCalibratedRed:(r/255.0)
                                                      green:(g/255.0)
                                                       blue:(b/255.0)
                                                      alpha:1.0];
                    
                    if (fg)
                    {
                        [attrs setObject:color forKey:NSForegroundColorAttributeName];
                    }
                    else
                    {
                        [attrs setObject:color forKey:NSBackgroundColorAttributeName];
                    }
                    
                    //NSString *realString = [component substringFromIndex:colorCodeSeqLength];
                    
                    // Mark the range of the entire sequence (escape sequence + color code sequence).
                    NSRange seqRange = (NSRange){
                        .location = componentRange.location - [escapeSeq length],
                        .length = colorCodeSeqLength + [escapeSeq length],
                    };
                    [seqRanges addObject:[NSValue valueWithRange:seqRange]];
                }
                else
                {
                    // Wasn't able to parse a color code
                    
                    [attrs removeObjectForKey:NSForegroundColorAttributeName];
                    [attrs removeObjectForKey:NSBackgroundColorAttributeName];
                    
                    NSRange seqRange = (NSRange){
                        .location = componentRange.location - [escapeSeq length],
                        .length = [escapeSeq length],
                    };
                    [seqRanges addObject:[NSValue valueWithRange:seqRange]];
                }
            }
        }
        
        componentRange.length = [component length];
        
        [textStorage addAttributes:attrs range:componentRange];
        
        componentRange.location += componentRange.length + [escapeSeq length];
        firstPass = NO;
        
    } // END: for (NSString *component in components)
    
    
    // Now loop over all the discovered sequences, and apply "invisible" attributes to them.
    
    if ([seqRanges count] > 0)
    {
        NSDictionary *clearAttrs =
        [NSDictionary dictionaryWithObjectsAndKeys:
         [NSFont systemFontOfSize:0.001], NSFontAttributeName,
         [NSColor clearColor], NSForegroundColorAttributeName, nil];
        
        for (NSValue *seqRangeValue in seqRanges)
        {
            NSRange seqRange = [seqRangeValue rangeValue];
            [textStorage addAttributes:clearAttrs range:seqRange];
        }
    }
}

@end
