//
//  CustomLogTools.h
//  custom Log
//
//  Created by LXF on 16/1/1.
//  Copyright © 2016年 LXF. All rights reserved.
//

#ifndef CustomLogTools_h
#define CustomLogTools_h


#define Xassert(condition, desc, ...) {\
if((condition) == NO){\
    NSString *str = [NSString stringWithFormat:desc,##__VA_ARGS__];    \
    LXFPrintf("💔",@"断言失败 -> %@", str);\
    NSAssert(NO, str);\
}\
}

#define Xassert2(desc, ...)  Xassert(NO,desc,##__VA_ARGS__)

#ifdef DEBUG



    #define NSLog(format, ...)   {\
        LXFPrintf("😐",format, ##__VA_ARGS__); \
        }
    // error
    #define printE(format, ...)   {\
        LXFPrintf("❌",format, ##__VA_ARGS__); \
        }
    // debug
    #define printD(format, ...)   {\
        LXFPrintf("😬",format, ##__VA_ARGS__); \
        }
    // print obj
    #define printOBJ(obj)   {\
        LXFPrintf("⚽️",@"%@",obj); \
    }
    // wran
    #define printW(format, ...)   {\
        LXFPrintf("⚠️",format, ##__VA_ARGS__); \
        }
    #define LXFPrintf(tag,format, ...)  printf("%s:%d %s%s + %d🎈 %s\n",[NSString stringWithUTF8String:__FILE__].lastPathComponent.UTF8String,__LINE__,\
    tag, __PRETTY_FUNCTION__, __LINE__,\
    [[NSString stringWithFormat:format,\
    ##__VA_ARGS__]UTF8String])

#else

    // print obj
    #define printOBJ(obj)   {\
        LXFPrintf("⚽️",@"%@",obj); \
    }

    #define NSLog(format, ...)
    // error
    #define printE(format, ...)   {\
        LXFPrintf("❌",format, ##__VA_ARGS__); \
    }

    // debug
    #define printD(format, ...)

    // wran
    #define printW(format, ...)

    #define LXFPrintf(tag,format, ...)  printf("%s:%d %s%s + %d🎈 %s\n",[NSString stringWithUTF8String:__FILE__].lastPathComponent.UTF8String,__LINE__,\
    tag, __PRETTY_FUNCTION__, __LINE__,\
    [[NSString stringWithFormat:format,\
    ##__VA_ARGS__]UTF8String])

#endif


#endif /* CustomLogTools_h */
