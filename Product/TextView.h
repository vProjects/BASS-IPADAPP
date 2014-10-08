//
//  TextView.h
//  Product
//
//  Created by Shimul Bhowmik on 8/19/14.
//

#import <UIKit/UIKit.h>

@interface TextView : UITextView

- (void)playAnimationfromFrame:(CGRect)initialFrame
                       toFrame:(CGRect)finalFrame
                        inTime:(double)time;

- (void)stopAnimation;

@end
