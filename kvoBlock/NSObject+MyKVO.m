//
//  NSObject+MyKVO.m
//  KVO封装公开课
//
//  Created by 汪启航 on 2018/7/27.
//  Copyright © 2018年 八点钟学院. All rights reserved.
//

#import "NSObject+MyKVO.h"
#import <objc/runtime.h>

typedef void(^deallocBlock)(void);

//用于监听对象的dealloc
@interface DeallocProxy : NSProxy
@property (nonatomic, strong) NSObject *retainObj;
@property (nonatomic, strong) NSMutableArray <deallocBlock>*blockArr;
@end

@implementation DeallocProxy

-(NSMutableArray<deallocBlock> *)blockArr {
    if (!_blockArr) {
        _blockArr = [NSMutableArray array];
    }
    return _blockArr;
}
- (void)dealloc {
    NSLog(@"%s",__func__);
    [self.blockArr enumerateObjectsUsingBlock:^(deallocBlock  _Nonnull block, NSUInteger idx, BOOL * _Nonnull stop) {
        block();
    }];
}
@end

@interface NSObject()
@property (nonatomic, strong)DeallocProxy *deallocProxy; //observer的属性,observer调用dealloc后,此对象会dealloc
@property (nonatomic, strong)NSMutableDictionary <NSString *, kvoBlock> *kvoBlockDic; //observer的属性,存block

@end

@implementation NSObject (MyKVO)

//增加观察者后被观察者引用,引用计数加1
- (void)addObserver:(NSObject *)observer keyPath:(NSString *)keyPath block:(kvoBlock)block {
    NSString *key = [NSString stringWithFormat:@"%p%@",observer,keyPath];
    observer.kvoBlockDic[key] = block;
    
    [self addObserver:observer forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    
    //建立引用关系
    observer.deallocProxy.retainObj = self;
    __unsafe_unretained typeof(observer) weakObserver = observer;
    [observer.deallocProxy.blockArr addObject:^{
        [self removeObserver:weakObserver forKeyPath:keyPath];
    }];
}

//observer里来调用
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    ///执行block
    NSString *key = [NSString stringWithFormat:@"%p%@",self,keyPath];
    kvoBlock block = self.kvoBlockDic[key];
    if(block) {
        block();
    }
}

//getter 和 setter方法
- (NSMutableDictionary<NSString *,kvoBlock> *)kvoBlockDic {
    NSMutableDictionary *dic = objc_getAssociatedObject(self, @selector(kvoBlockDic));
    if(!dic) {
        dic = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, @selector(kvoBlockDic), dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dic;
}
- (DeallocProxy *)deallocProxy {
    DeallocProxy *proxy = objc_getAssociatedObject(self, @selector(deallocProxy));
    if (!proxy) {
        proxy = [DeallocProxy alloc];
        objc_setAssociatedObject(self, @selector(deallocProxy), proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return proxy;
    
}
@end




