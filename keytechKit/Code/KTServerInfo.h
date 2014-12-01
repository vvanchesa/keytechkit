//
//  KTServerInfo.h
//  keytechKit
//
//  Created by Thorsten Claus on 13.05.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The keytech serverinfo data is available withoutthe need of a valid user logged in.
 It provides information about the server and keytech version, a unique servce ID and statistical data
 */
@interface KTServerInfo : NSObject


/**
 Provides the object Mapping for this class and given objectManager
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;

+(instancetype)sharedServerInfo;

/**
 returns TRUE if serverinfo was fetched
 */
@property (readonly) BOOL isLoaded;

/**
 Contains the full key-value list of all bom attribes, including all element attributes
 */
@property (readonly) NSMutableArray* keyValueList;

/**
 Returns the current API Version from Server
 */
@property (readonly)NSString *databaseVersion;

/**
 Return the API Kernel version from Server
 */
@property (readonly)NSString *APIVersion;

/**
 A unique key to identify the current Server
 */
@property (readonly) NSString *serverID;

/**
 Returns YES if web API supports index Server (SOLR server on vaults)
 */
@property (readonly) BOOL isIndexServerEnabled;

/**
 Returns the company String used for license generations
 */
@property (readonly) NSString* licencedCompany;


/**
 Loads the current Serverinfo with globally set ServerURL. 
 Waits until server responds.
 */
+(instancetype)serverInfo;


/**
 Loads the API's Serverinfo in background
 */
-(void)reload;
/**
 Reloads the API in background and executed block after succeed
 */
-(void)reloadWithCompletionBlock:(void(^)(NSError* error))completionBlock;

@end
