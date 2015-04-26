//
//  KTManager
//  keytech PLM
//
//  Created by Thorsten Claus on 07.08.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//
//  Manages BaseURLs, Login names and Managing Data
//
#import <Foundation/Foundation.h>

#import "KTPreferencesConnection.h"
#import "KTServerInfo.h"

/**
 Provides basic initialization
 */
@interface KTManager : NSObject
// Formaly known as "Webservice"


/**
 Returns the shared instance
 */
+(instancetype) sharedManager;

/**
 Returns the default application data directory
 */
- (NSURL*)applicationDataDirectory;
/**
 Returns the default application cache directory
 */
- (NSURL*)applicationCacheDirectory;

@property (nonatomic,copy) NSString* servername;
@property (nonatomic,copy) NSString* username;
@property (nonatomic,copy) NSString* password;

/**
 A page and size structure to identify a specific page in multi page responses
 */
typedef struct {int page; int size;} PageDefinition;

/**
 Returns the current baseURL
 */
-(NSURL*)baseURL;

/**
 Sets a default header with the given settings
 */
-(void)setDefaultHeader:(NSString*)headerName withValue:(NSString*)value;

/**
 Adds default headers to mutable request
 */
-(void)setDefaultHeadersToRequest:(NSMutableURLRequest*)request;

/**
 Returns a dictionary with current defualt header values
 */
-(NSDictionary*)defaultHeaders;

/*
 If any error occured on the server side. This value retuns the original server error description
 */
-(NSString*) lastServerErrorText;

/**
 Returns YES if the user identified by its credentials has an active admin role
 */
-(BOOL)currentUserHasActiveAdminRole;

/**
 Simply check if current user credentials has right to login.
 @Returns A value If username or password failed (402), or license violation (403) or 400 if unknown.
 */
-(BOOL)currentUserHasLoginRight;


@property (readonly) KTPreferencesConnection* preferences;

//@property (nonatomic,weak) NSArray *simpleItemsList;


-(BOOL)needsInitialSetup;

/// Synchonizes changed user credentials with the api level.
-(void)synchronizeServerCredentials;



@end
