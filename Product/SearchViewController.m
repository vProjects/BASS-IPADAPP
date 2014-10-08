//
//  SearchViewController.m
//  Product
//
//  Created by Sumit Kumar Garu on 22/06/14.
//  Copyright (c) 2014 Sumit Kumar Garu. All rights reserved.
//

#import "SearchViewController.h"
#import "ProductViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

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
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
    self.searchTxt.leftView = paddingView;
    self.searchTxt.leftViewMode = UITextFieldViewModeAlways;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)home:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark TEXTFIELD SCROLL ADJUSTMENTS

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length <= 0 || self.navigationController.topViewController != self) {
        return;
    }
    ProductViewController *collection=[[ProductViewController alloc] initWithNibName:@"ProductViewController" bundle:nil];
    collection.link=@"Search";
    collection.viewPushedName = @"Search";
    collection.serchString=self.searchTxt.text;
    [self.navigationController pushViewController:collection animated:YES];

}
@end
