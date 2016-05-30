//
//  CustomLogTools.h
//  custom Log
//
//  Created by LXF on 16/1/1.
//  Copyright © 2016年 LXF. All rights reserved.
//

#ifndef CustomLogTools_h
#define CustomLogTools_h

#define XCC         @"\033["
#define XCCFG(rgb)  XCC @"fg"rgb";"
#define XCCBG(rgb)  XCC @"bg"rgb";"

#define XCCFG_END   XCC @"fg;"
#define XCCBG_END   XCC @"bg;"
#define XCC_END     XCC ";"


#define defaultColor "defColor"

#define printW(format, ...)   {\
    LXFPrintf("⚠️",defaultColor,defaultColor,"00f",content,"🍘",format, ##__VA_ARGS__); \
}

#define LXFPrintf(tag,titlefg,titlebg,contentfg,contentbg,split,format, ...)  {\
    const char *fileName = [NSString stringWithUTF8String:__FILE__].lastPathComponent.UTF8String;\
    const char *content = [[NSString stringWithFormat:format,##__VA_ARGS__]UTF8String];\
    printf("$(%s,%d,%s,%s,%s,%s)%s%s + %d %s %s\n",fileName,__LINE__,titlefg,titlebg,contentfg,contentbg,tag,__PRETTY_FUNCTION__,__LINE__,split,content);\
}

#endif /* CustomLogTools_h */
