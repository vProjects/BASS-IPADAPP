//
//  UIImageView+PhotoFrame.m
//  KidsKard
//
//  Created by indranil roy on 03/09/13.
//  Copyright (c) 2013 Soumen Bhuin. All rights reserved.
//

#import "UIImageView+PhotoFrame.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImageView (PhotoFrame)

- (void)applyPhotoFrame {
    /*self.layer.borderColor = [UIColor whiteColor].CGColor;
     self.layer.borderWidth = 4.0f;
     self.layer.cornerRadius = 41.0f;
     self.layer.shadowColor = [UIColor blackColor].CGColor;
     self.layer.shadowOffset = CGSizeMake(-3, 4);
     self.layer.shadowOpacity = 0.9;
     self.layer.shadowRadius = 2;
     self.clipsToBounds = YES;*/
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //CGPathRef maskPath = CGPathCreateWithRoundedRect(self.bounds,10.0,10.0, NULL);
    CGPathRef maskPath = CGPathCreateWithRect(self.bounds, NULL);

    maskLayer.bounds = self.bounds;
    [maskLayer setPath:maskPath];
    [maskLayer setFillColor:[[UIColor blackColor] CGColor]];
    maskLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    [self.layer setMask:maskLayer];
    maskLayer=nil;
    CGPathRelease(maskPath);
    
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    CGPathRef maskPath1 = CGPathCreateWithRect(self.bounds, NULL);
    maskLayer1.bounds = self.bounds;
    [maskLayer1 setPath:maskPath1];
    [maskLayer1 setFillColor:[[UIColor clearColor] CGColor]];
    maskLayer1.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    maskLayer1.strokeColor = [[UIColor colorWithRed:106.0/255.0 green:92.0/255.0 blue:58.0/255.0 alpha:1.0] CGColor];
    maskLayer1.lineWidth = 10.0;
    [self.layer addSublayer:maskLayer1];
    maskLayer1=nil;
    CGPathRelease(maskPath1);
    
}

- (void)cleanPhotoFrame {
    /*self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 0.0f;
    self.layer.cornerRadius = 0.0f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, -3);
    self.layer.shadowOpacity = 0;
    self.layer.shadowRadius = 3;
    self.clipsToBounds = YES;*/
    
    [[self.layer sublayers] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    self.layer.mask = nil;
}

@end
