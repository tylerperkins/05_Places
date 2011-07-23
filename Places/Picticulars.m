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


/*  Initializes the receiver, assigning each key's value to the receiver's
    property whose name matches the key. The value for key "urlString" is
    translated into an NSURL object and assigned to property url.
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


/*  Returns a new dictionary representing the data in the receiver. Keys match
    the receiver's property names and each key's value is the corresponding
    property's value. The sole exception is property url, whose value is
    represented as a string and is associated with key "urlString". There is
    therefore no "url" key in the returned dictionary. Note that the returned
    object has a retain count of 1, so should be released.
*/
- (NSDictionary*) newDictionary {
    NSMutableDictionary* dict = [[self
        dictionaryWithValuesForKeys:[NSArray
            arrayWithObjects:@"title", @"subtitle", @"lastViewed", nil
        ]
    ] mutableCopy];

    [dict setObject:[self.url absoluteString] forKey:@"urlString"];
    return  dict;
}


/*  A Picticular is "greater than" this one if and only if it was viewed
    more recently.
*/
- (NSComparisonResult) compare:(Picticulars*)pic {
    return  [self.lastViewed compare:pic.lastViewed];
}


/*  We identify a Picticulars object strictly by its url property.
*/
- (BOOL) isEqual:(id)other {
    return
        other == self  ||
        (   other &&
            [other isKindOfClass:[self class]] &&
            [self.url isEqual:((Picticulars*)other).url]
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
