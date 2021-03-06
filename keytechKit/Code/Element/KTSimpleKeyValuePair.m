//
//  SimpleKeyValuePair.m
//  keytech search ios
//
//  Created by Thorsten Claus on 14.10.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//

#import "KTSimpleKeyValuePair.h"
#import <RestKit/RestKit.h>

@implementation KTSimpleKeyValuePair

RKObjectMapping *_mapping;

+(RKObjectMapping*)mapping {
    
    if (!_mapping){
        
        RKObjectMapping *_mapping = [RKObjectMapping mappingForClass:[KTSimpleKeyValuePair class]];
        [_mapping addAttributeMappingsFromDictionary:@{
                                                       @"Key":@"itemKey",
                                                       @"ElementKey":@"itemValue"
                                                       }];
    }
    return _mapping;
}
@end
