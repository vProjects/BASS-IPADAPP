//
//  ProductViewController.h
//  Product
//
//  Created by Sumit Kumar Garu on 22/06/14.
//  Copyright (c) 2014 Sumit Kumar Garu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SingleRequest.h"
#import "ViewController.h"

@interface ProductViewController : ViewController

@property(nonatomic,assign) NSInteger mid;
@property(nonatomic,assign) NSInteger CountrayId;
@property(nonatomic ,strong) NSString *serchString;
@property(nonatomic, strong) NSString *link;
@property(nonatomic ,strong) NSMutableArray *searchFrndArr;
@property(nonatomic,assign) NSInteger CurrenetPageINdex;
@property(nonatomic,assign) NSInteger parsePageIndex;


- (IBAction)back:(id)sender;
- (IBAction)home:(id)sender;
@end
