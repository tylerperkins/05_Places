//
//  Picticulars.h
//  Places
//
//  Created by Tyler Perkins on 2011-07-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/*  This class defines data objects holding PICture parTICULARS.
*/
@interface Picticulars : NSObject {}

@property (copy,nonatomic) NSURL*    url;
@property (copy,nonatomic) NSString* title;
@property (copy,nonatomic) NSString* subtitle;
@property (copy,nonatomic) NSDate*   lastViewed;

/*  Initializes the receiver, assigning each key's value to the receiver's
    property whose name matches the key. The value for key "urlString" is
    translated into an NSURL object and assigned to property url.
 */
- (id) initFromDictionary:(NSDictionary*)dict;

/*  Returns a new dictionary representing the data in the receiver. Keys match
    the receiver's property names and each key's value is the corresponding
    property's value. The sole exception is property url, whose value is
    represented as a string and is associated with key "urlString". There is
    therefore no "url" key in the returned dictionary. Note that the returned
    object has a retain count of 1, so should be released.
 */
- (NSDictionary*) newDictionary;

/*  A Picticular is "greater than" this one if and only if it was viewed
    more recently.
 */
- (NSComparisonResult) compare:(Picticulars*)pic;

/*  We identify a Picticulars object strictly by its url property. Although
    they are ordered by their lastViewed property, two Picticulars objects
    are deemed equal if and only if their url properties are equal. We over-
    ride methods isEqual: and hash so Picticulars work in sets and dictionaries.
*/
- (BOOL) isEqual:(id)other;
- (NSUInteger) hash;

/*  Returns the description of a dictionary representation of the receiver.
*/
- (NSString*) description;

@end
