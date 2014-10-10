//
//  ProductCell.h
//  Product
//
//  Created by Sumit Kumar Garu on 22/06/14.
//  Copyright (c) 2014 Sumit Kumar Garu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCell : UITableViewCell
@property (nonatomic, readwrite, assign) NSInteger columnNumber;
@property (strong, nonatomic) IBOutlet UIImageView *imageVw1;
@property (strong, nonatomic) IBOutlet UIImageView *imageVw2;
@property (strong, nonatomic) IBOutlet UIImageView *imageVw3;
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UILabel *label3;
@property (strong, nonatomic) IBOutlet UIButton *btn1;
@property (strong, nonatomic) IBOutlet UIButton *btn2;
@property (strong, nonatomic) IBOutlet UIButton *btn3;

+(id)productCell;
- (void)getActualPositionForPoint:(CGPoint)point;

@end
