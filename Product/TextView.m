//
//  TextView.m
//  Product
//
//  Created by Shimul Bhowmik on 8/19/14.
//

#import "TextView.h"

@interface TextView ()

@property (nonatomic, readwrite, assign) BOOL stopAllAnimation;
@property (nonatomic, readwrite, assign) CGRect initialFrame;
@property (nonatomic, readwrite, assign) CGRect finalFrame;
@property (nonatomic, readwrite, assign) double totalTime;
@property (nonatomic, readwrite, assign) NSTimer *timer;
@property (nonatomic, readwrite, assign) float intervalHeightChange;
@property (nonatomic, readwrite, assign) float intervalWidthChange;
@property (nonatomic, readwrite, assign) NSInteger intervalRemaining;

@end

#define kTimerInterval 0.1

@implementation TextView

- (void)playAnimationfromFrame:(CGRect)initialFrame
                       toFrame:(CGRect)finalFrame
                        inTime:(double)time {
    if (time < kTimerInterval) {
        return;
    }
    [self stopAnimation];
    self.stopAllAnimation = NO;
    self.initialFrame = initialFrame;
    self.finalFrame = finalFrame;
    self.totalTime = time;
    NSInteger intervals = time / kTimerInterval;
    self.intervalRemaining = intervals;
    self.intervalHeightChange = (self.finalFrame.size.height - self.initialFrame.size.height) / intervals;
    self.intervalWidthChange = (self.finalFrame.size.width - self.initialFrame.size.width) / intervals;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval
                                                  target:self
                                                selector:@selector(updateAnimation)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)stopAnimation {
    self.stopAllAnimation = YES;
    if (self.timer && self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)updateAnimation {
    if (CGRectEqualToRect(self.finalFrame, self.frame) || self.intervalRemaining <= 0) {
        [self stopAnimation];
    } else {
        self.frame = CGRectMake(self.frame.origin.x,
                                self.frame.origin.y,
                                self.frame.size.width + self.intervalWidthChange,
                                self.frame.size.height+self.intervalHeightChange);
        self.intervalRemaining--;
    }
}

@end
