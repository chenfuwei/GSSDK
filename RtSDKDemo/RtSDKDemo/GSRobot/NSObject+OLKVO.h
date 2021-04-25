//
//  NSObject+OLKVO.h
//  OkLine
//
//  Created by hxk on 17/2/15.
//  Copyright © 2017年 ding juanjuan. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface NSObject (OLKVO)

/**
 KVO监听
 @param keyPath 键值路径
 @param block   监听到属性发生改变后的Block回调
 */
- (void)addObserverBlockForKeyPath:(NSString*)keyPath
                             block:(void (^)(id _Nonnull obj, id _Nonnull oldVal, id _Nonnull newVal))block;
/**
 释放block，移除观察者对应的键值
 @param keyPath 键值路径
 */
- (void)removeObserverBlocksForKeyPath:(NSString*)keyPath;

/**
 释放Block，移除观察者和所有的关联键值
 */
- (void)removeObserverBlocks;
@end
NS_ASSUME_NONNULL_END

