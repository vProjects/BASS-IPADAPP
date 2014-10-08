//
//  CountrayCollectionViewCell.m
//  Product
//
//  Created by Shimul Bhowmik on 8/5/14.
//  Copyright (c) 2014 Sumit Kumar Garu. All rights reserved.
//

#import "CountrayCollectionViewCell.h"

#import "FontUtility.h"

@interface CountrayCollectionViewCell ()

@property (nonatomic, readwrite, assign) NSInteger countryCode;
@property (nonatomic, readwrite, assign) BOOL isFontChanged;

@end

@implementation CountrayCollectionViewCell

- (void)updateCountryCode:(NSInteger)countryCode {
    self.countryCode = countryCode;
    if (!self.isFontChanged) {
        [FontUtility updateFontsForView:self];
        self.isFontChanged = YES;
    }
}

- (IBAction)didTapButton:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didTapCountryButton"
                                                        object:@{@"id": @(self.countryCode), @"name": self.countryName.text}];
}

@end
