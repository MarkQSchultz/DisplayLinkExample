//
//  ViewController.m
//  DisplayLinkExample
//
//  Created by Mark Schultz on 1/2/14.
//  Copyright (c) 2014 QZero Labs, LLC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSTimeInterval remainingTime;
@property (nonatomic, assign) NSTimeInterval lastDrawTime;
@property (nonatomic, strong) UIView *animatedView;
@property (nonatomic, assign) CGRect startingRect;
@property (nonatomic, assign) CGRect finalRect;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
    self.duration = self.remainingTime = 2.0;
    self.lastDrawTime = 0;
    
    self.startingRect = CGRectMake(0, 0, 10, 10);
    self.finalRect = CGRectMake(50, 50, 75, 75);
    
    self.animatedView = [[UIView alloc] initWithFrame:self.startingRect];
    self.animatedView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.animatedView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self performSelector:@selector(addDisplayLinkToRunLoop) withObject:nil afterDelay:1.0];
}

- (void)addDisplayLinkToRunLoop
{
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)update:(CADisplayLink *)displayLink
{
    NSTimeInterval timestamp = displayLink.timestamp;
    
    // Check if we've drawn yet
    if (self.lastDrawTime == 0)
    {
        // If not, then set our last draw time to the current timestamp of our display link
        self.lastDrawTime = timestamp;
    }
    
    NSTimeInterval elapsedTimeSinceLastUpdate = timestamp - self.lastDrawTime;
    self.remainingTime = MAX(self.remainingTime - elapsedTimeSinceLastUpdate, 0);
    
    if (self.remainingTime > 0)
    {
        NSTimeInterval totalElapsedTime = self.duration - self.remainingTime;
        CGFloat percentageComplete = totalElapsedTime / self.duration;
        CGFloat x = (self.finalRect.origin.x - self.startingRect.origin.x) * percentageComplete + self.startingRect.origin.x;
        CGFloat y = (self.finalRect.origin.y - self.startingRect.origin.y) * percentageComplete + self.startingRect.origin.y;
        CGFloat width = (self.finalRect.size.width - self.startingRect.size.width) * percentageComplete + self.startingRect.size.width;
        CGFloat height = (self.finalRect.size.height - self.startingRect.size.height) * percentageComplete + self.startingRect.size.height;
        CGRect frame = CGRectMake(x, y, width, height);
        self.animatedView.frame = frame;
    }
    else
    {
        [self.displayLink invalidate];
    }
    
    self.lastDrawTime = timestamp;
}

@end
