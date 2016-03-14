//
//  ViewController.m
//  custom Log
//
//  Created by LXF on 16/1/1.
//  Copyright © 2016年 LXF. All rights reserved.
//

#import "ViewController.h"

#import "ViewController+test.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *uiview;
@property (nonatomic, strong) UIView *uiview2;
@property (nonatomic, strong) UIView *uivie3w;
@property (nonatomic, strong) UIView *uivi4ew;


@end

@implementation ViewController

void testLog(){
    printW(@"函数里的调用");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    printD(@"普通打印");
    
    void (^block)() = ^{
        printE(@"这是%@",@"block 里面");
    };
    
    block();
    
    testLog();
    
    [self testLog];
    
//    assertx(NO, @"assserrae");
//    assertx2(@"assserrae");
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSString *str = nil;
    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData: [str dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
}

@end
