//
//  Picticulars.m
//  Places
//
//  Created by Tyler Perkins on 2011-07-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Picticulars.h"


@implementation Picticulars


@synthesize url = _url;
@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize lastViewed = _lastViewed;


/*  Use setValuesForKeysWithDictionary: to assign each property from an
    key-value pair in the given dictionary. This way, adding, removing, or
    changing any property (except url/"urlString") requires no change to the
    code below.    
*/
- (id) initFromDictionary:(NSDictionary*)d {
    self = [super init];
    if ( self ) {
        NSMutableDictionary* dict = [d mutableCopy];

        NSURL* newUrl = [[NSURL alloc]
            initWithString:[d objectForKey:@"urlString"]
        ];
        [dict setObject:newUrl forKey:@"url"];
        [newUrl release];

        [dict removeObjectForKey:@"urlString"];
        [self setValuesForKeysWithDictionary:dict];

        [dict release];
    }
    return  self;
}


- (void) dealloc {
    [_url release];
    [_title release];
    [_subtitle release];
    [_lastViewed release];
    [super dealloc];
}


- (NSDictionary*) newDictionary {
    NSMutableDictionary* dict = [[self
        dictionaryWithValuesForKeys:[NSArray
            arrayWithObjects:@"title", @"subtitle", @"lastViewed", nil
        ]
    ] mutableCopy];

    [dict setObject:[self.url absoluteString] forKey:@"urlString"];
    return  dict;
}


- (NSComparisonResult) compare:(Picticulars*)pic {
    return  [self.lastViewed compare:pic.lastViewed];
}


- (BOOL) isEqual:(id)other {
    return
        other == self  ||                                // Same object, or ...
        (   other &&                                     // Must not be nil.
            [other isKindOfClass:[self class]] &&        // Must be same class.
            [self.url isEqual:((Picticulars*)other).url] // Urls must be equal.
        );
}


- (NSUInteger) hash {
    return  [self.url hash];
}


- (NSString*) description {
    NSDictionary* dict = [self newDictionary];
    NSString* descStr = [dict description];
    [dict release];
    return  descStr;
}


@end
