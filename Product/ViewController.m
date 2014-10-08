//
//  ViewController.m
//  Product
//
//  Created by Shimul Bhowmik on 8/14/14.
//  Copyright (c) 2014 Sumit Kumar Garu. All rights reserved.
//

#import "ViewController.h"

#import "FontUtility.h"

#define kFontName @"WOXYKI+Bembo-Semibold"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableString *viewStackDisplayString = [NSMutableString string];
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[ViewController class]]) {
            ViewController *namedViewController = (ViewController *)viewController;
            if (viewStackDisplayString.length > 0 && namedViewController.viewPushedName) {
                [viewStackDisplayString appendString:@" - "];
            }
            if (namedViewController.viewPushedName) {
                [viewStackDisplayString appendString:namedViewController.viewPushedName];
            }
        }
    }
    if (viewStackDisplayString) {
        UILabel *viewNameLabel = [[UILabel alloc] init];
        viewNameLabel.textColor = [UIColor whiteColor];
        viewNameLabel.text = viewStackDisplayString;
        viewNameLabel.frame = CGRectMake(self.view.center.x, 30, 500, 20);
        viewNameLabel.center = CGPointMake(viewNameLabel.frame.origin.x, viewNameLabel.frame.origin.y);
        viewNameLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:viewNameLabel];
    }

    // Change all fonts to custom font
    [FontUtility updateFontsForView:self.view];
}

@end
