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


#define defaultColor "_"

#define NSLog(format, ...)   {\
    LXFPrintf("😐",defaultColor,defaultColor,defaultColor,defaultColor,"🎉",format, ##__VA_ARGS__); \
}


// debug
#define printD(format, ...)   {\
    LXFPrintf("😁","00f",defaultColor,"00f",defaultColor,"🎉",format, ##__VA_ARGS__); \
}

// Warning
#define printW(format, ...)   {\
    LXFPrintf("⚠️","d84",defaultColor,"d84",defaultColor,"🎉",format, ##__VA_ARGS__); \
}

// error
#define printE(format, ...)   {\
    LXFPrintf("❌","f00",defaultColor,"f00",defaultColor,"🎉",format, ##__VA_ARGS__); \
}

// print obj
#define printOBJ(obj)   {\
    LXFPrintf("⚽️",defaultColor,defaultColor,defaultColor,defaultColor,"🎉",@"%@",obj); \
}




#define LXFPrintf(tag,titlefg,titlebg,contentfg,contentbg,split,format, ...)  {\
    const char *fileName = [NSString stringWithUTF8String:__FILE__].lastPathComponent.UTF8String;\
    const char *content = [[NSString stringWithFormat:format,##__VA_ARGS__]UTF8String];\
    printf("$(%s,%d,%s,%s,%s,%s)%s%s + %d %s %s$(end)\n",fileName,__LINE__,titlefg,titlebg,contentfg,contentbg,tag,__PRETTY_FUNCTION__,__LINE__,split,content);\
}

#endif /* CustomLogTools_h */
