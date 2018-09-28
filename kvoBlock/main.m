//
//  main.m
//  kvoBlock
//
//  Created by 汪启航 on 2018/9/28.
//  Copyright © 2018年 q.h. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import "NSObject+MyKVO.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        Person *son = [[Person alloc]init];
        Person *father = [[Person alloc]init];
        [son addObserver:father keyPath:@"name" block:^{
            NSLog(@"gooooood");
        }];
        son.name = @"好好学习";
    }
    return 0;
}
