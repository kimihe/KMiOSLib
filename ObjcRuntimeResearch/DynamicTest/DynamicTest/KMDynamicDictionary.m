//
//  KMDynamicDictionary.m
//  DynamicTest
//
//  Created by 周祺华 on 2016/12/22.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import "KMDynamicDictionary.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface KMDynamicDictionary ()

@property (nonatomic, strong)NSMutableDictionary *store;

@end

@implementation KMDynamicDictionary


- (instancetype)init {
    if (self = [super init]) {
        _store = [NSMutableDictionary new];
    }
    return self;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    NSString *selectorString = NSStringFromSelector(sel);
    if ([selectorString hasPrefix:@"set"]) {
        class_addMethod(self, sel, (IMP)autoDictionarySetter, "v@:@");
    }
    else {
        class_addMethod(self, sel, (IMP)autoDictionaryGetter, "@@:");
    }
    
    return YES;
}

# pragma mark - Getter & Setter
id autoDictionaryGetter(id self, SEL _cmd) {
    
    KMDynamicDictionary *typedSelf = (KMDynamicDictionary *)self;
    NSString *key = NSStringFromSelector(_cmd);
    return [typedSelf.store objectForKey:key];
}

void autoDictionarySetter(id self, SEL _cmd, id value) {
    KMDynamicDictionary *typedSelf = (KMDynamicDictionary *)self;
    NSMutableString *key = [NSStringFromSelector(_cmd) mutableCopy];
    
    // Remove the 'set' at the end
    [key deleteCharactersInRange:NSMakeRange(key.length-1, 1)];
    
    // Remove the 'set' prefix
    [key deleteCharactersInRange:NSMakeRange(0, 3)];
    
    // Lowercase the first character
    NSString *lowercaseFirstChar = [[key substringToIndex:1] lowercaseString];
    [key replaceCharactersInRange:NSMakeRange(0, 1) withString:lowercaseFirstChar];
    
    if (value) {
        [typedSelf.store setObject:value forKey:key];
    }
    else {
        [typedSelf.store removeObjectForKey:key];
    }
}

#pragma mark - showAllProperties
- (void )showAllProperties
{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    if (count != 0) {
        NSMutableDictionary *resultDict = [@{} mutableCopy];
        
        for (NSUInteger i = 0; i < count; i ++) {
            const void *propertyName = property_getName(properties[i]);
            NSString *name = [NSString stringWithUTF8String:propertyName];
            
            SEL getter = [self propertyGetterByKey:name];
            if (getter) {
                id value = ((id (*)(id, SEL))objc_msgSend)(self, getter);
                if (value) {
                    resultDict[name] = value;
                } else {
                    resultDict[name] = @"(null)";
                }
                
            }
        }
        
        free(properties);
        
        NSLog(@"<%@> : %@", [self class], resultDict);
    }
    else {
        free(properties);
        
        NSLog(@"<%@> : %@", [self class], @"(null)");
    }
}

// 生成getter方法的SEL
- (SEL)propertyGetterByKey:(NSString *)key
{
    SEL getter = NSSelectorFromString(key);
    if ([self respondsToSelector:getter]) {
        return getter;
    }
    return nil;
}

@end
