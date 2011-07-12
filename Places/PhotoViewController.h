//
//  PhotoViewController.h
//  Places
//
//  Created by Tyler Perkins on 2011-06-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Picticulars.h"
#import "FlickrModel.h"

@interface PhotoViewController : UIViewController<UIScrollViewDelegate> {}

@property (nonatomic,retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic,retain) IBOutlet FlickrModel*  flickrModel;
@property (nonatomic,retain)          Picticulars*  picticulars;
@property (assign,nonatomic) BOOL                   picticularsDidChange;

@end
