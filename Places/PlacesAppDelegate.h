//
//  PlacesAppDelegate.h
//  Places
//
//  Created by Tyler Perkins on 2011-06-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrModel.h"

@interface PlacesAppDelegate : NSObject
<UIApplicationDelegate, UITabBarControllerDelegate>
{}

@property (nonatomic, retain) IBOutlet UIWindow           *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet FlickrModel        *flickrModel;

@end
