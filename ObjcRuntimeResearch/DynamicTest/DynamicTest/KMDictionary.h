//
//  KMDictionary.h
//  DynamicTest
//
//  Created by 周祺华 on 2016/12/22.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import "KMDynamicDictionary.h"

@interface KMDictionary : KMDynamicDictionary

@property (nonatomic, strong)NSString *string;
@property (nonatomic, strong)NSNumber *number;
@property (nonatomic, strong)NSDictionary *dic;
// Now we can not use assign to define 'C-type' variables according to "Type Encodings".
//@property (nonatomic, assign)NSInteger integer; // long

@end

