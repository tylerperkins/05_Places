//
//  PhotoViewController.m
//  Places
//
//  Created by Tyler Perkins on 2011-06-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoViewController.h"
#import "FlickrModel.h"


@interface PhotoViewController ()
@property (retain,nonatomic) UIImageView* imageView;
@property (assign,nonatomic) BOOL         picticularsDidChange;
- (void) downloadAndDisplayPic:(Picticulars*)pic;
- (void) setScrollViewZoom;
@end

CGFloat scaleToFillOrFit( BOOL shouldFill, CGSize boundsSz, CGSize imageSz );


@implementation PhotoViewController


@synthesize scrollView = _scrollView;
@synthesize flickrModel = _flickrModel;
@synthesize imageView = _imageView;
@synthesize picticulars = _picticulars;
@synthesize picticularsDidChange = _picticularsDidChange;


- (void) dealloc {
    [_scrollView release];
    [_picticulars release];
    [_imageView release];
    [_flickrModel release];
    [super dealloc];
}


- (void) didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle


- (void) viewDidUnload {
    self.imageView = nil;
    self.picticularsDidChange = YES;  // Forces download. (We lost imageView.)
    self.scrollView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if ( self.picticularsDidChange ) {
        //  We've been given a new URL, so we must retrive the image data
        //  from Flickr. Essentially, the image is cached in the imageView
        //  property itself.

        //  Remove previous image. Shows only grey screen until new image is
        //  finished downloading.
        [self.imageView removeFromSuperview];
        
        //  Turn on the network activity indicator and wait 50 msec before
        //  starting the download to allow for the indicator to appear.
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self performSelector:@selector(downloadAndDisplayPic:)
                   withObject:self.picticulars
                   afterDelay:0.05
        ];

        //  Next time, don't reload the image unless we're given a new URL.
        self.picticularsDidChange = NO;
    }
}


- (BOOL) shouldAutorotateToInterfaceOrientation:
  (UIInterfaceOrientation)interfaceOrientation
{
    return  YES;
}


- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)ornt
                                          duration:(NSTimeInterval)duration
{
    [self setScrollViewZoom];
}


#pragma mark - Explicit accessors


/*  Besides remembering the given Particulars object in property picticulars,
    also records in property picticularsDidChange whether or not this one is
    different from the one given the last time. This often allows us to avoid
    re-downloading image data in method viewWillAppear:.
*/
- (void) setPicticulars:(Picticulars*)pic {
    self.picticularsDidChange = ! [pic isEqual:_picticulars];
    if ( self.picticularsDidChange ) {
        [_picticulars release];
        _picticulars = [pic retain];
    }
}


#pragma mark - Implementation of protocol UIScrollViewDelegate


- (UIView*) viewForZoomingInScrollView:(UIScrollView*)scrollView {
    return  self.imageView;
}


#pragma mark - Private functions and methods


/*  Downloads the image data specified by the given Picticulars, and store it
    in the new NSImage of a new UIImageView. The UIImageView is saved in
    property imageView, and replaces the existing view in scrollView.
*/
- (void) downloadAndDisplayPic:(Picticulars*)pic {
    self.imageView = [[UIImageView alloc]
        initWithImage:[self.flickrModel imageFromPicticulars:pic]
    ];
    [self.imageView release];   // Because retained by setImageView:.
    
    //  Done downloading. Turn off the indicator.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    [self.scrollView addSubview:self.imageView];
    
    //  Adjust how we look at the image view.
    [self setScrollViewZoom];
}


/*  Adjust content properties of self.scrollView to properly accommodate its
    subview, self.imageView.
*/
- (void) setScrollViewZoom {

    //  The requirements specify that when the user first sees the image,
    //  there is no "unused space" around it. So now we zoom in just enough
    //  to make the smaller of image height and width equal to scrollView's
    //  width and height, respectively.
    self.scrollView.zoomScale = scaleToFillOrFit(
        YES,
        self.scrollView.bounds.size,
        self.imageView.bounds.size
    );

    //  Center the scaled image.
    self.scrollView.contentOffset = CGPointMake(
        self.imageView.center.x - self.scrollView.bounds.size.width /2.0,
        self.imageView.center.y - self.scrollView.bounds.size.height/2.0
    );

    //  Make it so the user can zoom out only as far as the entire image
    //  becomes visible.
    self.scrollView.minimumZoomScale = scaleToFillOrFit(
        NO,
        self.scrollView.bounds.size,
        self.imageView.bounds.size
    );
}


/*  Calculates the scale value, which, when multiplied by the given image size,
    results in a size whose width or height is equal to that of the given
    bounds' size. If shouldFill is YES, the resulting size JUST CONTAINS the
    bounds' size, i.e., its dimensions are greater than or equal to the
    corresponding dimensions of the bounds. If shouldFill is NO, the reverse
    is true -- the resulting size IS JUST CONTAINED BY the bounds' size.
 
    If shouldFill  ==>  Bounds are just filled by the image.
    Otherwise      ==>  The image just fits in the bounds.
*/
CGFloat scaleToFillOrFit( BOOL shouldFill, CGSize boundsSz, CGSize imageSz ) {
    CGFloat widthScale  = boundsSz.width  / imageSz.width;
    CGFloat heightScale = boundsSz.height / imageSz.height;
    return  shouldFill
    ?   MAX(widthScale, heightScale)
    :   MIN(widthScale, heightScale);
}


@end
