//
//  ViewController.m
//  LXFColorLinkedConsoleTest
//
//  Created by LXF on 16/5/30.
//  Copyright © 2016年 LXF. All rights reserved.
//

#import "ViewController.h"


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    LXFPrintf("⚠️","0f0","f0f","00f","f00","🍘",@"aaa");
    printW(@"这个是啥");
    printW(@"这个是啥");
    printW(@"这个是啥");
    printW(@"这个是啥");
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

@end
