//
//  NSCompoundPredicate+PredicateKTFormat.h
//  keytechKit
//
//  Created by Thorsten Claus on 16.03.14.
//  Copyright (c) 2017 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Adds a predicateFormat that is suitable for keytech API queries
 */
@interface NSPredicate (PredicateKTFormat)

#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
/// Returns a list of keytech attributes with its value operators
-(NSString*)predicateKTFormat;

/// This predicate identifies a query text
-(NSString*)predicateKTQueryText;

/// This Part of a compound Predicate identified by /*classtypes*/ identifies a list of valid classes
-(NSString*)predicateKTClasstypes;

/// Some predicates are Special. This is YES if any not directly to  use predicates are found
-(BOOL)isSpecialPredicate;

#endif

@end



