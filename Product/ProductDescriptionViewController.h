//
//  ProductDescriptionViewController.h
//  Product
//
//  Created by Sumit Kumar Garu on 22/06/14.
//  Copyright (c) 2014 Sumit Kumar Garu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDescriptionViewController : UIViewController

@property(nonatomic,assign) NSInteger currentSelectedIndex;
@property(nonatomic,strong) NSArray *allProducts;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;
@property(nonatomic,strong) NSDictionary *productDict;
@property (weak, nonatomic) IBOutlet UIButton *informationBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgVw;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (nonatomic, weak) IBOutlet UIScrollView *textScrollView;

- (IBAction)information:(id)sender;
- (IBAction)productPrice:(id)sender;

- (IBAction)back:(id)sender;
- (IBAction)home:(id)sender;
@end
