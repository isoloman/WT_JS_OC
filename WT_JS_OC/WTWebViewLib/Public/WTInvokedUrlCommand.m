//
//  WTInvokedUrlCommand.m
//  WT_JS_OC
//
//  Created by 灰太狼 on 2018/11/21.
//  Copyright © 2018 灰太狼. All rights reserved.
//

#import "WTInvokedUrlCommand.h"

@implementation WTInvokedUrlCommand
+ (WTInvokedUrlCommand *)commandFromJson:(NSArray*)jsonEntry
{
    return [[WTInvokedUrlCommand alloc] initFromJson:jsonEntry];
}

- (id)initFromJson:(NSArray *)jsonEntry{
    id tmp = [jsonEntry objectAtIndex:0];
    NSString* callbackId = tmp == [NSNull null] ? nil : tmp;
    NSString* className = [jsonEntry objectAtIndex:1];
    NSString* methodName = [jsonEntry objectAtIndex:2];
    NSMutableArray* arguments = [jsonEntry objectAtIndex:3];
    
    return [self initWithArguments:arguments
                        callbackId:callbackId
                         className:className
                        methodName:methodName];
}

- (id)initWithArguments:(NSArray*)arguments
             callbackId:(NSString*)callbackId
              className:(NSString*)className
             methodName:(NSString*)methodName
{
    self = [super init];
    if (self != nil) {
        _arguments = arguments;
        _callbackId = callbackId;
        _className = className;
        _methodName = methodName;
    }
    [self massageArguments];
    return self;
}

- (void)massageArguments
{
    NSMutableArray* newArgs = nil;
    
    for (NSUInteger i = 0, count = [_arguments count]; i < count; ++i) {
        id arg = [_arguments objectAtIndex:i];
        if (![arg isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        NSDictionary* dict = arg;
        NSString* type = [dict objectForKey:@"WTType"];
        if (!type || ![type isEqualToString:@"ArrayBuffer"]) {
            continue;
        }
        NSString* data = [dict objectForKey:@"data"];
        if (!data) {
            continue;
        }
        if (newArgs == nil) {
            newArgs = [NSMutableArray arrayWithArray:_arguments];
            _arguments = newArgs;
        }
        [newArgs replaceObjectAtIndex:i withObject:[[NSData alloc] initWithBase64EncodedString:data options:0]];
    }
}

- (id)argumentAtIndex:(NSUInteger)index
{
    return [self argumentAtIndex:index withDefault:nil];
}

- (id)argumentAtIndex:(NSUInteger)index withDefault:(_Nullable id)defaultValue
{
    return [self argumentAtIndex:index withDefault:defaultValue andClass:nil];
}

- (id)argumentAtIndex:(NSUInteger)index withDefault:(_Nullable id)defaultValue andClass:(_Nullable Class)aClass
{
    if (index >= [_arguments count]) {
        return defaultValue;
    }
    id ret = [_arguments objectAtIndex:index];
    if (ret == [NSNull null]) {
        ret = defaultValue;
    }
    if ((aClass != nil) && ![ret isKindOfClass:aClass]) {
        ret = defaultValue;
    }
    return ret;
}


@end
