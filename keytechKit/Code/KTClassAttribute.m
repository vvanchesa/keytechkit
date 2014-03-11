//
//  KTClassAttribute.m
//  keytechKit
//
//  Created by Thorsten Claus on 01.03.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import "KTClassAttribute.h"
#import <RestKit/RestKit.h>

@implementation KTClassAttribute
    static RKObjectMapping *_mapping = nil;


+(id)mapping{
    if (!_mapping){
        
        _mapping = [RKObjectMapping mappingForClass:[KTClassAttribute class]];
        [_mapping addAttributeMappingsFromDictionary:@{@"AttributeLength":@"attributeLength",
                                                       @"AttributeType":@"attributeType",
                                                       @"Description":@"attributeDescription",
                                                       @"Displayname":@"attributeDisplayname",
                                                       @"NativeName":@"attributeName"
                                                       }];
        
        [[RKObjectManager sharedManager] addResponseDescriptor:
         [RKResponseDescriptor responseDescriptorWithMapping:_mapping method:RKRequestMethodAny
                                                 pathPattern:nil
                                                     keyPath:@"AttributesList" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
        
        
    }
    
    return _mapping;
}

-(NSString *)debugDescription{
    return self.attributeName;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.attributeDescription = [coder decodeObjectForKey:@"attributeDescription"];
        self.attributeDisplayname = [coder decodeObjectForKey:@"attributeDisplayname"];
        self.attributeLength = [coder decodeIntForKey:@"attributeLength"];
        self.attributeName = [coder decodeObjectForKey:@"attributeName"];
        self.attributeType = [coder decodeObjectForKey:@"attributeType"];
        
    }
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.attributeDescription forKey:@"attributeDescription"];
    [aCoder encodeObject:self.attributeDisplayname forKey:@"attributeDisplayname"];
    [aCoder encodeInt:self.attributeLength forKey:@"attributeLength"];
    [aCoder encodeObject:self.attributeName forKey:@"attributeName"];
    [aCoder encodeObject:self.attributeType forKey:@"attributeType"];
    
    
}

@end
