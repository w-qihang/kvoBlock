//
//  Person.h
//  KVO的优雅封装
//
//  Created by 八点钟学院 on 2017/8/23.
//  Copyright © 2017年 八点钟学院. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
{
    NSString *adress;
}
@property(nonatomic, strong)NSString *name;
@property(nonatomic, assign)NSInteger age;
@property(nonatomic, strong)NSNumber *number;
@property(nonatomic, strong)NSMutableArray *arr;

@end
