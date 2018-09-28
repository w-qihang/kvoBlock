//
//  NSObject+MyKVO.h
//  KVO封装公开课
//
//  Created by 汪启航 on 2018/7/27.
//  Copyright © 2018年 八点钟学院. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^kvoBlock)(void);

@interface NSObject (MyKVO)

//增加观察者后被观察者引用,引用计数加1
- (void)addObserver:(NSObject *)observer keyPath:(NSString *)keyPath block:(kvoBlock)block;
@end
