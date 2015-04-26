//
//  KTServerInfo.m
//  keytechKit
//
//  Created by Thorsten Claus on 13.05.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import "KTServerInfo.h"
#import "KTKeyValue.h"

@implementation KTServerInfo{
    BOOL _isloading;
    BOOL _isLoaded;

}
    static KTServerInfo *_serverInfo;


@synthesize keyValueList = _keyValueList;

// Mapping for Class
static RKObjectMapping *_mapping;
static RKObjectManager *_usedManager;

static KTServerInfo *_sharedServerInfo;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [KTServerInfo mappingWithManager:[RKObjectManager sharedManager]];
        _isLoaded = NO;
        _isloading = NO;
        _keyValueList = [NSMutableArray array];
    }
    return self;
}

/// Creates a shared instance and loads Data
+(instancetype)sharedServerInfo{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedServerInfo = [[KTServerInfo alloc]init];
    });

    return _sharedServerInfo;
}

-(BOOL)isLoaded{
    return _isLoaded;
}

// Sets the Object mapping for JSON
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager{
    
    if (_usedManager !=manager){
        _usedManager = manager;
        
       
        RKObjectMapping *kvMapping = [RKObjectMapping mappingForClass:[KTKeyValue class]];
        [kvMapping addAttributeMappingsFromDictionary:@{@"Key":@"key",
                                                       @"Value":@"value"}];
       
         _mapping = [RKObjectMapping mappingForClass:[self class]];
        [_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"ServerInfoResult" toKeyPath:@"_keyValueList" withMapping:kvMapping]];
        /*
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"ServerInfoResult"
                                                    toKeyPath:@"keyValueList"
                                                  withMapping:kvMapping];
        */
        
        
        NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
        RKResponseDescriptor *serverInfoDescriptor = [RKResponseDescriptor
                                                      responseDescriptorWithMapping:kvMapping
                                                      method:RKRequestMethodGET
                                                      pathPattern:nil
                                                      keyPath:@"ServerInfoResult"
                                                      statusCodes:statusCodes];
        
        
        [_usedManager addResponseDescriptorsFromArray:@[ serverInfoDescriptor ]];
        
        
    }
    
    return _mapping;
}

-(void)loadWithSuccess:(void (^)(KTServerInfo *))success failure:(void (^)(NSError *))failure {
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTServerInfo mappingWithManager:manager];
    
    if (_isloading) {
        [self waitUnitlLoad];
        if (success) {
            success(self);
        }
    }
    
    _isloading = YES;
    [manager getObject:_sharedServerInfo path:@"serverinfo" parameters:nil
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   NSLog(@"Serverinfo loaded.");
                   
                   [self.keyValueList removeAllObjects];
                   [self.keyValueList addObjectsFromArray:mappingResult.array];
                   
                   // Key Value liste austauschen
                   _keyValueList = [NSMutableArray arrayWithArray:mappingResult.array];
                   _isLoaded = YES;
                   _isloading = NO;
                   
                   if (success) {
                       success(self);
                   }
                   
               } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   NSLog(@"Error while getting the serverinfo resource: %@",error.localizedDescription);
                   _isLoaded = NO;
                   _isloading = NO;
                   
                   if (failure) {
                       failure(error);
                   }
                   
               }];
    
}

/// Loads the serverinfo and waits until return
-(void)reload{
    if (!_isloading) {
        _isLoaded = NO;
        _isloading = YES;
    
        RKObjectManager *manager = [RKObjectManager sharedManager];
        [KTServerInfo mappingWithManager:manager];
        
        
        [manager getObject:nil path:@"serverinfo" parameters:nil
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       NSLog(@"Serverinfo loaded.");
                       // Key Value liste austauschen
                    _keyValueList = [NSMutableArray arrayWithArray:mappingResult.array];
                       _isLoaded = YES;
                       _isloading = NO;
                   } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       NSLog(@"Error while getting the serverinfo resource: %@",error.localizedDescription);
                       _isLoaded = NO;
                       _isloading = NO;
                   }];

        
        [self waitUnitlLoad];
    }
    
    
}


/// Wait until request comnples
/// No async here, case the values matters
-(void)waitUnitlLoad{
    // Do some polling to wait for the connections to complete
#define POLL_INTERVAL 0.2 // 200ms
#define N_SEC_TO_POLL 30.0 // poll for 30s
#define MAX_POLL_COUNT N_SEC_TO_POLL / POLL_INTERVAL
    
    if (!_isloading && !_isLoaded) {
        // Load was not triggered
        return;
    }
    
    NSUInteger pollCount = 0;
    while (_isloading && (pollCount < MAX_POLL_COUNT)) {
        NSDate* untilDate = [NSDate dateWithTimeIntervalSinceNow:POLL_INTERVAL];
        [[NSRunLoop currentRunLoop] runUntilDate:untilDate];
        pollCount++;
    }
    
    if (pollCount== MAX_POLL_COUNT) {
        NSLog(@"Loading Error!");
    }
    
}

/// Extract the values from the key value list
-(id)valueForKey:(NSString *)key{
    
    for (KTKeyValue *kv in self.keyValueList) {
        if ([kv.key compare:key options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            return kv.value;
        }
    }
    return nil;
}
/// Returns a Boolean value
-(BOOL)boolValueForKey:(NSString *)key{
    
    for (KTKeyValue *kv in self.keyValueList) {
        if ([kv.key compare:key options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            
            if ([kv.value compare:@"true" options:NSCaseInsensitiveSearch]==NSOrderedSame){
                return YES;
            };
            
            if ([kv.value compare:@"yes" options:NSCaseInsensitiveSearch]==NSOrderedSame){
                return YES;
            };
            
            if ([kv.value compare:@"1" options:NSCaseInsensitiveSearch]==NSOrderedSame){
                return YES;
            };
            
            return NO;
            
        }
    }
    
    return NO;
}

+(instancetype)serverInfo{
    return [KTServerInfo sharedServerInfo];
}

-(NSString*)serverID{
    
    return [self valueForKey:@"ServerID"];
}

-(BOOL)isIndexServerEnabled{
    return [self boolValueForKey:@"Supports Index Server"];
}


-(NSString *)databaseVersion{
    return [self valueForKey:@"keytech database version"];
}

-(NSString *)APIVersion{
    return [self valueForKey:@"API version"];
}

-(NSString *)licencedCompany{
    return [self valueForKey:@"LicensedCompany"];
}

@end
