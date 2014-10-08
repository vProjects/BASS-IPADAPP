//
//  CountrayCollectionViewCell.h
//  Product
//
//  Copyright (c) 2014 Sumit Kumar Garu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountrayCollectionViewCell : UICollectionViewCell

@property (nonatomic, readwrite, strong) IBOutlet UILabel *countryName;
@property (nonatomic, readwrite, strong) IBOutlet UIButton *button;

- (void)updateCountryCode:(NSInteger)countryCode;

@end
