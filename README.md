# LXFColorLinkedConsole
Xcode 插件, 使用 CustomLogTools 可以实现 点击跳转到对应行,以及自定义颜色,XcodeConsole颜色不再单一!

##使用:
###1.安装
clone -> run -> 完全退出xcode -> 重新打开xcode -> 弹窗-> loadbundel 
###2.打印
pch 中 '#import "CustomLogTools.h"'
提供了这几种默认的方式
```
    printOK(@"这个是内容");
    printD(@"这个是内容");
    printW(@"这个是内容");
    printE(@"这个是内容");
```
效果:



