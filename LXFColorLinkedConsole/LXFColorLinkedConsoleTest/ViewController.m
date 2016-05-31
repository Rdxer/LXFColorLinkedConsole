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
    
     LXFPrintf("😁","f00","9101f2","0f0","#0101f2","🎉",@"这个是啥");
    
    NSLog(@"这个是啥");
    printD(@"这个是啥");
    printW(@"这个是啥");
    printE(@"这个是啥");
    printOBJ(self)
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

@end
