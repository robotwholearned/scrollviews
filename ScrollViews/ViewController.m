//
//  ViewController.m
//  ScrollViews
//
//  Created by Cassandra Sandquist on 13/02/2014.
//  Copyright (c) 2014 self.edu.robotwholearned. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *imageView;

-(void)centerScrollViewContents;
-(void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer;
-(void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIImage * image = [UIImage imageNamed:@"photo1.png"];
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=image.size};
    //add full sized image to scroll view
    [self.scrollView addSubview:self.imageView];
    //so scrollview knows the size it can scroll to the ends
    self.scrollView.contentSize = image.size;
    
    //setup double tap to zoom, two finger tap to zoom out
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    [self.scrollView addGestureRecognizer:twoFingerTapRecognizer];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth =  scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);

    //scale = 1 is normal size, scale < 1 is zoomed out, scale > 1 is zoomed in
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.maximumZoomScale = 1.0f;
    self.scrollView.zoomScale = minScale;
    
    [self centerScrollViewContents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)centerScrollViewContents
{
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    contentsFrame.origin.x = (contentsFrame.size.width < boundsSize.width)? ((boundsSize.width - contentsFrame.size.width) / 2.0f):(0.0f);
    contentsFrame.origin.y = (contentsFrame.size.height < boundsSize.height)? ((boundsSize.height - contentsFrame.size.height) / 2.0f): (0.0f);

    self.imageView.frame = contentsFrame;
}
-(void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer
{
    CGPoint pointInView = [recognizer locationInView:self.imageView];
    CGFloat newZoomScale = self.scrollView.zoomScale * 1.5f;
    
    newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat width = scrollViewSize.width / newZoomScale;
    CGFloat height = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (width / 2.0f);
    CGFloat y = pointInView.y - (height / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, width, height);
    
    [self.scrollView zoomToRect:rectToZoomTo animated:YES];
}
-(void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer
{
    [self.scrollView setZoomScale:MAX((self.scrollView.zoomScale /1.5f), self.scrollView.minimumZoomScale) animated:YES];
}
@end
