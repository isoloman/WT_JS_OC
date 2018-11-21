//
//  WTInvokedUrlCommand.h
//  WT_JS_OC
//
//  Created by 灰太狼 on 2018/11/21.
//  Copyright © 2018 灰太狼. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WTInvokedUrlCommand : NSObject{
    NSString* _callbackId;
    NSString* _className;
    NSString* _methodName;
    NSArray* _arguments;
}

@property (nonatomic, readonly) NSArray* arguments;
@property (nonatomic, readonly) NSString* callbackId;
@property (nonatomic, readonly) NSString* className;
@property (nonatomic, readonly) NSString* methodName;


+ (WTInvokedUrlCommand*)commandFromJson:(NSArray*)jsonEntry;

- (id)initWithArguments:(NSArray*)arguments
             callbackId:(NSString*)callbackId
              className:(NSString*)className
             methodName:(NSString*)methodName;

- (id)initFromJson:(NSArray*)jsonEntry;

// 返回给定索引处的参数。
// 如果索引越界，返回nil。
// 如果给定索引处的参数为NSNull，则返回nil。
- (id)argumentAtIndex:(NSUInteger)index;
//与上面相同，但是返回defaultValue而不是nil。
- (id)argumentAtIndex:(NSUInteger)index withDefault:(_Nullable id)defaultValue;
//和上面一样，但是返回defaultValue而不是nil，如果参数不是给定的类，返回defaultValue
- (id)argumentAtIndex:(NSUInteger)index withDefault:(_Nullable id)defaultValue andClass:(_Nullable Class)aClass;

@end

NS_ASSUME_NONNULL_END
