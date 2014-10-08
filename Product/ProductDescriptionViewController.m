//
//  ProductDescriptionViewController.m
//  Product
//
//  Created by Sumit Kumar Garu on 22/06/14.
//  Copyright (c) 2014 Sumit Kumar Garu. All rights reserved.
//

#import "ProductDescriptionViewController.h"

#import "FontUtility.h"
#import "ProductInfoViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TextView.h"

#define BASEURL @"http://app.newbyteas.com/chitra/photos/"

@interface ProductDescriptionViewController ()

@property (nonatomic, readwrite, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, readwrite, strong) UIImage *no_image;

@property (nonatomic, readwrite, strong) TextView *productDetails;
@property (nonatomic, readwrite, strong) TextView *productDetailsExtra;

@end

@implementation ProductDescriptionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];   
    
    _no_image=[UIImage imageNamed:@"no_imgae.png"];
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 1;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:doubleTapRecognizer];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe:)];
    
    // Setting the swipe direction.
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    // Adding the swipe gesture on image view
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
    [self setupScrollView];
    [self showProduct];
    self.productPrice.hidden = YES;
}

- (void)setupScrollView {
    self.textScrollView.contentSize = CGSizeMake(385, 200);
    self.productDetails = [[TextView alloc] initWithFrame:CGRectMake(0, 0, 375, 200)];
    self.productDetails.backgroundColor = [UIColor clearColor];
    self.productDetails.font = [UIFont systemFontOfSize:20.0f];
    self.productDetails.textColor = [UIColor whiteColor];
    self.productDetails.editable = NO;
    self.productDetailsExtra = [[TextView alloc] initWithFrame:CGRectMake(0, 0, 375, 200)];
    self.productDetailsExtra.backgroundColor = [UIColor clearColor];
    self.productDetailsExtra.font = [UIFont systemFontOfSize:20.0f];
    self.productDetailsExtra.textColor = [UIColor whiteColor];
    self.productDetailsExtra.editable = NO;
    [FontUtility updateFontsForView:self.productDetails];
    [FontUtility updateFontsForView:self.productDetailsExtra];
    [self.textScrollView addSubview:self.productDetails];
    [self.textScrollView addSubview:self.productDetailsExtra];
    self.productDetailsExtra.hidden = YES;
}

- (void)updateTextViews {
    [self.productDetails sizeToFit];
    NSInteger topPadding = self.productDetails.contentSize.height + 10;
    CGRect initialFrame = self.productDetailsExtra.frame;
    self.productDetailsExtra.frame = CGRectMake(initialFrame.origin.x, topPadding, self.productDetails.frame.size.width, initialFrame.size.height);
    [self updateScrollViewSizeForcefully:NO];
}

- (void)updateScrollViewSizeForcefully:(BOOL)shouldUpdateForcefully {
    NSInteger minHeight = self.productDetails.frame.size.height +
    ((self.productDetailsExtra.isHidden && ! shouldUpdateForcefully)? 0 : self.productDetailsExtra.frame.size.height);
    self.textScrollView.contentSize = CGSizeMake(self.textScrollView.contentSize.width, minHeight + 5);
    if (shouldUpdateForcefully && self.textScrollView.contentSize.height > self.textScrollView.frame.size.height) {
        CGPoint bottomOffset = CGPointMake(0, self.textScrollView.contentSize.height - self.textScrollView.bounds.size.height);
        [self.textScrollView setContentOffset:bottomOffset animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - class Method


- (void)imageViewTapped:(UITapGestureRecognizer*)swipe {
    
    ProductInfoViewController *productInfo=[[ProductInfoViewController alloc] initWithNibName:@"ProductInfoViewController" bundle:nil];
    [productInfo setCurrentPage:^(NSInteger selectedpage){
        self.currentSelectedIndex=selectedpage;
        self.productDict=[self.allProducts objectAtIndex:self.currentSelectedIndex];
        [self showProduct];

    }];
    productInfo.productDict=self.productDict;
    productInfo.currentSelectedIndex=self.currentSelectedIndex;
    productInfo.allProducts=self.allProducts;
    [self.navigationController pushViewController:productInfo animated:YES];

}

- (void)handleLeftSwipe:(UISwipeGestureRecognizer *)swipe {
    [self hideBothInfoAndPriceText];
    if (self.currentSelectedIndex<self.allProducts.count - 1) {
        self.currentSelectedIndex++;
        if (self.allProducts.count>self.currentSelectedIndex) {
            self.productDict=[self.allProducts objectAtIndex:self.currentSelectedIndex];
            [self pushtrastion];
            [self updateTextViews];
        }
    }
}

- (void)handleRightSwipe:(UISwipeGestureRecognizer *)swipe {
    [self hideBothInfoAndPriceText];

    if (self.currentSelectedIndex>0) {
        self.currentSelectedIndex--;
        self.productDict=[self.allProducts objectAtIndex:self.currentSelectedIndex];
        [self popTranstion];
        [self updateTextViews];
    }
}

-(void)showProduct{
    
    self.imgVw.image=nil;
    if ([self.productDict valueForKey:@"Photos"]!= [NSNull null]) {
        NSArray *arr=[[self.productDict valueForKey:@"Photos"] componentsSeparatedByString:@","];
        NSLog(@"photos %@",arr);
        NSLog(@"url %@%@",BASEURL,[arr objectAtIndex:0]);
        if (arr.count>0) {
            [self setupActivityViewIndicator];
            __weak ProductDescriptionViewController *weakSelf = self;
            [self.imgVw setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASEURL,[arr objectAtIndex:0]]]
                       placeholderImage:nil
                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                __strong ProductDescriptionViewController *strongSelf = weakSelf;
                [strongSelf stopActivityViewIndicator];
                self.imgVw.image = image;
            }
                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                __strong ProductDescriptionViewController *strongSelf = weakSelf;
                [strongSelf stopActivityViewIndicator];
            }];
        }else{
            
            [self.imgVw setImage:_no_image];
        }
    }
    
    [self setupProductDescriptionText];

    [self updateTextViews];
    
}

- (void)setupProductDescriptionText {
    NSArray *paramsArr = @[@"FolioNumber", @"Provenance", @"DateOfOrigin", @"MakerName", @"Description"];
    NSDictionary *requiredParams = @{@"FolioNumber" : @"Product ID",
                                     @"Provenance" : @"Item Period",
                                     @"DateOfOrigin" : @"Date of origin",
                                     @"MakerName" : @"Maker",
                                     @"Description": @"Description"};
    NSMutableString *productDetails = [NSMutableString string];

    UIColor *foregroundColor = [UIColor whiteColor];
    UIFont *headingFont = [UIFont fontWithName:kFontSemiBold size:33.0];
    NSDictionary *headingAttr = @{NSFontAttributeName: headingFont, NSForegroundColorAttributeName: foregroundColor};
    UIFont *titleFont = [UIFont fontWithName:kFontSemiBold size:24.0];
    NSDictionary *titleAttr = @{NSFontAttributeName: titleFont, NSForegroundColorAttributeName: foregroundColor};
    UIFont *regularFont = [UIFont fontWithName:kFontRegular size:24.0];
    NSDictionary *defaultAttr = @{NSFontAttributeName: regularFont, NSForegroundColorAttributeName: foregroundColor};
    NSMutableDictionary *rangeToFont = [NSMutableDictionary dictionary];
    if ([self.productDict valueForKey:@"ItemName"]!= [NSNull null] && [self.productDict valueForKey:@"ItemName"]) {
        [productDetails appendString:[self stringByStrippingHTML:[self.productDict valueForKey:@"ItemName"]]];
        rangeToFont[[NSValue valueWithRange:NSMakeRange(0, productDetails.length)]] = headingAttr;
    }
    [productDetails appendString:@"\n\n"];
    for (NSString *key in paramsArr) {
        if ([self.productDict valueForKey:key]!= [NSNull null] && [self.productDict valueForKey:key]) {
            rangeToFont[[NSValue valueWithRange:NSMakeRange(productDetails.length, [requiredParams[key] length] + 1)]] = titleAttr;
            [productDetails appendFormat:@"%@: %@\n", requiredParams[key], [self stringByStrippingHTML:[self.productDict valueForKey:key]]];
        }
    }

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:productDetails
                                                                                         attributes:defaultAttr];
    for (NSValue *value in rangeToFont) {
        NSRange range = [value rangeValue];
        NSDictionary *attr = rangeToFont[value];
        [attributedString setAttributes:attr range:range];
    }

    [self.productDetails setAttributedText:attributedString];
}

- (void)setupActivityViewIndicator {
    if (!self.activityIndicator) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.view addSubview:self.activityIndicator];
        CGSize screenSize = self.imgVw.bounds.size;
        self.activityIndicator.center = CGPointMake(screenSize.width/2, screenSize.height/2);
    }
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = NO;
}

- (void)stopActivityViewIndicator {
    if (self.activityIndicator) {
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
    }
}

-(void)pushtrastion{
    
    self.imgVw.image=nil;
    self.productPrice.text=@"";

    if ([self.productDict valueForKey:@"Photos"]!= [NSNull null]) {
        NSArray *arr=[[self.productDict valueForKey:@"Photos"] componentsSeparatedByString:@","];
        if (arr.count>0) {
            [self setupActivityViewIndicator];
            __weak ProductDescriptionViewController *weakSelf = self;
            [self.imgVw setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASEURL,[arr objectAtIndex:0]]]
                       placeholderImage:nil
                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                    __strong ProductDescriptionViewController *strongSelf = weakSelf;
                                    [strongSelf stopActivityViewIndicator];
                                    strongSelf.imgVw.image = image;
            }
                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                    __strong ProductDescriptionViewController *strongSelf = weakSelf;
                                    [strongSelf stopActivityViewIndicator];
                                    strongSelf.imgVw.image = _no_image;
            }];
        }else{
            [self.imgVw setImage:_no_image];
        }
    }

    [self setupProductDescriptionText];
    
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.imgVw.layer addAnimation:transition forKey:@"push-transition"];
}

-(void)popTranstion{
    
    self.imgVw.image=nil;
    self.productPrice.text=@"";

    if ([self.productDict valueForKey:@"Photos"]!= [NSNull null]) {
        
        NSArray *arr=[[self.productDict valueForKey:@"Photos"] componentsSeparatedByString:@","];
        if (arr.count>0) {
            [self setupActivityViewIndicator];
            __weak ProductDescriptionViewController *weakSelf = self;
            [self.imgVw setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASEURL,[arr objectAtIndex:0]]]
                       placeholderImage:nil
                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                    __strong ProductDescriptionViewController *strongSelf = weakSelf;
                                    [strongSelf stopActivityViewIndicator];
                                    strongSelf.imgVw.image = image;
                                }
                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                    __strong ProductDescriptionViewController *strongSelf = weakSelf;
                                    [strongSelf stopActivityViewIndicator];
                                    strongSelf.imgVw.image = _no_image;
                                }];

        }else{
            [self.imgVw setImage:_no_image];
        }
    }
    
    [self setupProductDescriptionText];
    
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionPush;
    [transition setSubtype:kCATransitionFromLeft];
    [self.imgVw.layer addAnimation:transition forKey:@"push-transition"];
}


-(NSString *) stringByStrippingHTML:(NSString *)htmlString {
    NSRange r;
    NSString *s = [htmlString copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"-/:;()$&@\?!\[]{}#%^*+=_|~<>€£¥"];
    NSString *resultString = [[s componentsSeparatedByCharactersInSet:doNotWant] componentsJoinedByString:@" "];
    NSLog (@"Result: %@", resultString);
    return resultString;
}



- (IBAction)information:(UIButton*)sender {
    CGRect initialFrame, animationStartFrame, animationEndFrame;
    self.productDetailsExtra.textColor = [UIColor whiteColor];
    [self.priceBtn setSelected:NO];
    if ([sender isSelected]) {
        [sender setSelected:NO];
        initialFrame = self.productDetailsExtra.frame;
        animationStartFrame = initialFrame;
        animationEndFrame = CGRectMake(initialFrame.origin.x, initialFrame.origin.y, initialFrame.size.width, 0);
        [self updateScrollViewSizeForcefully:YES];
    }else{
        [sender setSelected:YES];
        [self informationText];
        [self.productDetailsExtra sizeToFit];
        [self updateTextViews];
        initialFrame = self.productDetailsExtra.frame;
        animationStartFrame = CGRectMake(initialFrame.origin.x, initialFrame.origin.y, initialFrame.size.width, 0);
        animationEndFrame = initialFrame;
        [self updateScrollViewSizeForcefully:YES];
        self.productDetailsExtra.frame = CGRectMake(initialFrame.origin.x, initialFrame.origin.y, initialFrame.size.width, 0);
        self.productDetailsExtra.hidden = NO;
    }
    [self.productDetailsExtra playAnimationfromFrame:animationStartFrame
                                             toFrame:animationEndFrame
                                              inTime:0.5];
}

- (void)informationText {
    NSMutableString *info = [NSMutableString string];
    NSArray *valuesToAdd = @[@"Material", @"DateAquired", @"ItemPurchasedFrom", @"PurchaseManner", @"Provenance"];
    NSDictionary *requiredParams = @{@"Material" : @"Material",
                                     @"DateAquired" : @"Date acquired",
                                     @"ItemPurchasedFrom" : @"Item purchased from",
                                     @"PurchaseManner" : @"Purchase Manner",
                                     @"Provenance": @"Provenance"};
    UIColor *foregroundColor = [UIColor whiteColor];
    UIFont *titleFont = [UIFont fontWithName:kFontSemiBold size:24.0];
    NSDictionary *titleAttr = @{NSFontAttributeName: titleFont, NSForegroundColorAttributeName: foregroundColor};
    UIFont *regularFont = [UIFont fontWithName:kFontRegular size:24.0];
    NSDictionary *defaultAttr = @{NSFontAttributeName: regularFont, NSForegroundColorAttributeName: foregroundColor};
    NSMutableDictionary *rangeToFont = [NSMutableDictionary dictionary];

    for (NSString *key in valuesToAdd) {
        if ([self.productDict valueForKey:key]!= nil) {
            rangeToFont[[NSValue valueWithRange:NSMakeRange(info.length, [requiredParams[key] length] + 1)]] = titleAttr;
            [info appendFormat:@"%@: ",requiredParams[key]];
            [info appendString:[self stringByStrippingHTML:[self.productDict valueForKey:key]]];
            [info appendString:@"\n"];
        }
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:info
                                                                                         attributes:defaultAttr];
    for (NSValue *value in rangeToFont) {
        NSRange range = [value rangeValue];
        NSDictionary *attr = rangeToFont[value];
        [attributedString setAttributes:attr range:range];
    }
    self.productDetailsExtra.attributedText = attributedString;
}

- (IBAction)productPrice:(UIButton*)sender {
    [self.informationBtn setSelected:NO];
    self.productDetailsExtra.textColor = self.productPrice.textColor;
    self.productDetailsExtra.font = [UIFont fontWithName:kFontSemiBold size:33.0];
    CGRect initialFrame, animationStartFrame, animationEndFrame;
    if ([sender isSelected]) {
        [sender setSelected:NO];
        initialFrame = self.productDetailsExtra.frame;
        animationStartFrame = initialFrame;
        animationEndFrame = CGRectMake(initialFrame.origin.x, initialFrame.origin.y, initialFrame.size.width, 0);
        [self updateScrollViewSizeForcefully:YES];
    }else{
        [sender setSelected:YES];
        
        NSString *str=nil;
        if ([self.productDict valueForKey:@"PurchasePrice"]) {
            str=[self.productDict valueForKey:@"PurchasePrice"];
        }
        if ([self.productDict valueForKey:@"PremiumCurrency"] && str) {
            str=[NSString stringWithFormat:@"%@%@",str,[self.productDict valueForKey:@"PremiumCurrency"]];
        }else if(!str){
            if ([self.productDict valueForKey:@"PremiumCurrency"]) {
                str=[self.productDict valueForKey:@"PremiumCurrency"];
            }
        }
        if (str) {
            self.productDetailsExtra.text=str;
 
        }
        [self.productDetailsExtra sizeToFit];
        [self updateTextViews];
        initialFrame = self.productDetailsExtra.frame;
        animationStartFrame = CGRectMake(initialFrame.origin.x, initialFrame.origin.y, initialFrame.size.width, 0);
        animationEndFrame = initialFrame;
        [self updateScrollViewSizeForcefully:YES];
        self.productDetailsExtra.frame = CGRectMake(initialFrame.origin.x, initialFrame.origin.y, initialFrame.size.width, 0);
        self.productDetailsExtra.hidden = NO;
    }
    [self.productDetailsExtra playAnimationfromFrame:animationStartFrame
                                             toFrame:animationEndFrame
                                              inTime:0.5];
}

- (void)hideBothInfoAndPriceText {
    [self.priceBtn setSelected:NO];
    [self.informationBtn setSelected:NO];
    self.productDetailsExtra.hidden = YES;
    [self updateScrollViewSizeForcefully:NO];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)home:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
