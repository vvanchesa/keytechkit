//
//  SimpleFileInfo.m
//  keytech search ios
//
//  Created by Thorsten Claus on 18.10.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//


#import "KTFileInfo.h"
#import "Webservice.h"

@implementation KTFileInfo
{
    NSString* _fileDivider;
}

@synthesize isLoading = _isLoading;
@synthesize localFileURL = _localFileURL;

    static RKObjectMapping* _mapping;

- (id)init
{
    self = [super init];
    if (self) {
        _fileDivider = @"-+-";
    }
    return self;
}

/**
 Sets the object mapping
 */
+(id)mapping{
    
    if (!_mapping){
        _mapping = [RKObjectMapping mappingForClass:[KTFileInfo class]];
        [_mapping addAttributeMappingsFromDictionary:@{@"FileID":@"fileID",
                                                       @"FileName":@"fileName",
                                                       @"FileSize":@"fileSize",
                                                       @"FileStorageType":@"fileStorageType"
                                                       }];

        NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
        RKResponseDescriptor *notesDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:_mapping
                                                                                             method:RKRequestMethodAny
                                                                                        pathPattern:nil
                                                                                            keyPath:@"FileInfos" statusCodes:statusCodes];
        
        [[RKObjectManager sharedManager]addResponseDescriptor:notesDescriptor];
        
    }
    return _mapping;
}

// Returns the shortende filename
-(NSString*)shortFileName{
    if(self.fileName !=nil){
//self.itemClassKey rangeOfString:@"_MI"].location !=NSNotFound
        
        NSUInteger location = [self.fileName rangeOfString:_fileDivider].location;
        
        if (location !=NSNotFound){ // Found divider
            
            NSArray *array = [self.fileName componentsSeparatedByString:@"."]; // Splitt to file attachment
            
            NSString* fileSuffix;
            NSString* fileNamePart;
            
            if ([array count]>1){
                fileSuffix = array[1];
                fileNamePart = array[0];
            } else
                fileNamePart = self.fileName;
            
            NSString* shortendFilename;
            
            // Find by divider
            NSArray* filenameParts = [fileNamePart componentsSeparatedByString:_fileDivider];
            if (filenameParts.count>1){
                // First part is the filename we want
                // second part can be thrown away
                
                shortendFilename = [NSString stringWithFormat:@"%@.%@",filenameParts[0],fileSuffix];
                
            }else
                shortendFilename = self.fileName;
            
            // Return the new, shortened filename
            return shortendFilename;
            
        }
        
    }
    
    return self.fileName;
}

/**
Checks if the file is already transferd to local machine
 */
-(BOOL)isLocalLoaded{
    
    // Objekt ist nicht zugewiesen

    return self.localFileURL !=nil;
        

}

// Loads the file, if not locally available
//TODO: What is with chaing / Reloading ? 
-(void)loadRemoteFile{
    
    if (![self isLocalLoaded] && !_isLoading){
        _isLoading = YES;
        NSString* resource = [NSString stringWithFormat:@"files/%ld",(long)self.fileID];
    
        //NSURL *fileURL = [NSURL URLWithString:resource relativeToURL:[[RKObjectManager sharedManager].HTTPClient baseURL]];
        //NSMutableURLRequest *request =  [NSMutableURLRequest requestWithURL:fileURL];
        
        NSMutableURLRequest *request = [[RKObjectManager sharedManager].HTTPClient requestWithMethod:@"GET" path:resource parameters:nil ];
        
                                                   
        NSURLSession *session = [NSURLSession sharedSession];
        [[session downloadTaskWithRequest:request
                       completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                           NSLog(@"File loaded at: %@",location);
                           if (location) {
                               
                           
                           NSFileManager *manager = [NSFileManager defaultManager];
                           NSError *err;
                           NSURL *targetURL = [[[Webservice sharedWebservice]applicationDataDirectory] URLByAppendingPathComponent:self.fileName];
                          
                           targetURL = [NSURL fileURLWithPath:[targetURL path]];
                           
                           [manager moveItemAtURL:location toURL:targetURL error:&err];
                           

                           [self willChangeValueForKey:@"localFileURL"];
                           _localFileURL = targetURL;
                           _isLoading = NO;
                           [self didChangeValueForKey:@"localFileURL"];
                           } else {
                               // Fehler, Datei konnte nicht geladen werden
                               _isLoading = NO;
                           }
                           
                       }] resume];
        
        
        
        _isLoading = YES;
        return;

    } else {
        return;
    }
}



/**
 Debugger helper
 */
-(NSString*)description{
    return [NSString stringWithFormat:@"ID: %ld, Filename: %@",(long)self.fileID, self.fileName];
}
@end





