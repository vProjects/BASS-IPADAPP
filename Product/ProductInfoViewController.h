//
//  ProductInfoViewController.h
//  Product
//
//  Created by Sumit Kumar Garu on 22/06/14.
//  Copyright (c) 2014 Sumit Kumar Garu. All rights reserved.
//

typedef void (^SlelectedPage)(NSInteger PageNo);

#import <UIKit/UIKit.h>

@interface ProductInfoViewController : UIViewController

@property(nonatomic,copy) SlelectedPage CurrentPage;
@property(nonatomic,assign) NSInteger currentSelectedIndex;
@property(nonatomic,strong) NSArray *allProducts;
@property (weak, nonatomic) IBOutlet UIImageView *imagVw;
- (IBAction)lbutnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollVw;
@property(nonatomic,strong) NSDictionary *productDict;
- (IBAction)back:(id)sender;
- (IBAction)home:(id)sender;
@end
