//
//  ProductInfoViewController.m
//  Product
//
//  Created by Sumit Kumar Garu on 22/06/14.
//  Copyright (c) 2014 Sumit Kumar Garu. All rights reserved.
//

#import "ProductInfoViewController.h"
#import "UIImageView+AFNetworking.h"
#define BASEURL @"http://app.newbyteas.com/chitra/photos/"

@interface ProductInfoViewController ()
{
    UIImage *no_image;
}
@end

@implementation ProductInfoViewController

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
    // Do any additional setup after loading the view from its nib.
    
    no_image=[UIImage imageNamed:@"no_imgae.png"];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe:)];
    
    // Setting the swipe direction.
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    // Adding the swipe gesture on image view
    [self.scrollVw addGestureRecognizer:swipeLeft];
    [self.scrollVw addGestureRecognizer:swipeRight];
   
    UIPinchGestureRecognizer *doubleTapRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    [self.scrollVw addGestureRecognizer:doubleTapRecognizer];
    [self showProducts];


}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Set up the minimum & maximum zoom scales
    CGRect scrollViewFrame = self.scrollVw.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollVw.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollVw.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    self.scrollVw.minimumZoomScale = minScale;
    self.scrollVw.maximumZoomScale = 6.0f;
    self.scrollVw.zoomScale = minScale;
    [self centerScrollViewContents];
}

-(void)showProducts{
    self.imagVw.image=nil;
    if ([self.productDict valueForKey:@"Photos"]!= [NSNull null]) {
      
        NSArray *arr=[[self.productDict valueForKey:@"Photos"] componentsSeparatedByString:@","];
        NSLog(@"photos %@",arr);
        NSLog(@"url %@%@",BASEURL,[arr objectAtIndex:0]);
        if (arr.count>0) {
            [self.imagVw setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASEURL,[arr objectAtIndex:0]]] placeholderImage:nil];
        }
        else{
            [self.imagVw setImage:no_image];
        }
    }
   
    
    self.lbl.text=[self stringByStrippingHTML:[self.productDict valueForKey:@"Description"]];
    self.scrollVw.contentSize = self.imagVw.frame.size;
    self.lbl.text=[self stringByStrippingHTML:[self.productDict valueForKey:@"ItemName"]];

    [self centerScrollViewContents];


}

-(void)pushtrastion{
    
    self.imagVw.image=nil;
    if ([self.productDict valueForKey:@"Photos"]!= [NSNull null]) {
        
        NSArray *arr=[[self.productDict valueForKey:@"Photos"] componentsSeparatedByString:@","];
        NSLog(@"photos %@",arr);
        NSLog(@"url %@%@",BASEURL,[arr objectAtIndex:0]);
        if (arr.count>0) {
            [self.imagVw setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASEURL,[arr objectAtIndex:0]]] placeholderImage:nil];
        }else{
            [self.imagVw setImage:no_image];
        }
   
    }
    
    self.lbl.text=[self stringByStrippingHTML:[self.productDict valueForKey:@"Description"]];
    self.scrollVw.contentSize = self.imagVw.frame.size;
    self.lbl.text=[self stringByStrippingHTML:[self.productDict valueForKey:@"ItemName"]];
    
    [self centerScrollViewContents];
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.scrollVw.layer addAnimation:transition forKey:@"push-transition"];
}

-(void)popTranstion{
    
    self.imagVw.image=nil;
    if ([self.productDict valueForKey:@"Photos"]!= [NSNull null]) {
        NSArray *arr=[[self.productDict valueForKey:@"Photos"] componentsSeparatedByString:@","];
        NSLog(@"photos %@",arr);
        NSLog(@"url %@%@",BASEURL,[arr objectAtIndex:0]);
        if (arr.count>0) {
            [self.imagVw setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASEURL,[arr objectAtIndex:0]]] placeholderImage:nil];
        }else{
            [self.imagVw setImage:no_image];
        }
    }
    
    
    self.lbl.text=[self stringByStrippingHTML:[self.productDict valueForKey:@"Description"]];
    self.scrollVw.contentSize = self.imagVw.frame.size;
    self.lbl.text=[self stringByStrippingHTML:[self.productDict valueForKey:@"ItemName"]];
    
    [self centerScrollViewContents];
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionPush;
    [transition setSubtype:kCATransitionFromLeft];
    [self.scrollVw.layer addAnimation:transition forKey:@"push-transition"];
}


- (void)handleLeftSwipe:(UISwipeGestureRecognizer *)swipe {
    
    if (self.currentSelectedIndex<self.allProducts.count - 1) {
        self.currentSelectedIndex++;
        if (self.allProducts.count>self.currentSelectedIndex) {
            self.productDict=[self.allProducts objectAtIndex:self.currentSelectedIndex];
            [self pushtrastion];
        }
    }
}

- (void)handleRightSwipe:(UISwipeGestureRecognizer *)swipe {
    
    if (self.currentSelectedIndex>0) {
        self.currentSelectedIndex--;
        self.productDict=[self.allProducts objectAtIndex:self.currentSelectedIndex];
        [self popTranstion];
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Class Method
- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollVw.bounds.size;
    CGRect contentsFrame = self.imagVw.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imagVw.frame = contentsFrame;
}

- (void)scrollViewDoubleTapped:(UIPinchGestureRecognizer*)recognizer {
    // Get the location within the image view where we tapped
    CGPoint pointInView = [recognizer locationInView:self.imagVw];
    
    // Get a zoom scale that's zoomed in slightly, capped at the maximum zoom scale specified by the scroll view
    CGFloat newZoomScale = self.scrollVw.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, self.scrollVw.maximumZoomScale);
    
    // Figure out the rect we want to zoom to, then zoom to it
    CGSize scrollViewSize = self.scrollVw.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    [self.scrollVw zoomToRect:rectToZoomTo animated:YES];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that we want to zoom
    return self.imagVw;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so we need to re-center the contents
    [self centerScrollViewContents];
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
- (IBAction)back:(id)sender {
    self.CurrentPage(self.currentSelectedIndex);
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)home:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];

}
- (IBAction)lbutnAction:(id)sender {
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Information" message:[self stringByStrippingHTML:[self.productDict valueForKey:@"InvoiceDescription"]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];

}
@end
