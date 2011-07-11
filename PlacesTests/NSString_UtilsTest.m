//
//  NSString_UtilsTest.m
//  Places
//
//  Created by Tyler Perkins on 2011-06-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSString_UtilsTest.h"
#import "NSString+Utils.h"


@implementation NSString_UtilsTest


- (void) testIsNotBlank {
    STAssertFalse(
        [(NSString*)nil isNotBlank], @"A nil value is considered blank."
    );
    STAssertFalse( [@"" isNotBlank], @"An empty string is blank" );
    STAssertFalse(
        [@" \n \t " isNotBlank], @"A string containing only whitespace is blank"
    );
    STAssertTrue(
        [@"x" isNotBlank], @"A string with 1 non-whitespace char is not blank"
    );
    STAssertTrue(
        [@" x " isNotBlank],
        @"A string with 1 non-space char surrounded by spaces is not blank"
    );
}


@end
