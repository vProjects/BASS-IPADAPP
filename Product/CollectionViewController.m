//
//  CollectionViewController.m
//  Product
//
//  Created by Sumit Kumar Garu on 22/06/14.
//  Copyright (c) 2014 Sumit Kumar Garu. All rights reserved.
//

#import "CollectionViewController.h"
#import "CountrayViewController.h"
#import "ProductViewController.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)home:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)seeAll:(id)sender
{
    CountrayViewController *countray=[[CountrayViewController alloc] initWithNibName:@"CountrayViewController" bundle:nil];
    countray.mid=0;
    countray.viewPushedName = @"See All";
    [self.navigationController pushViewController:countray animated:YES];
}

- (IBAction)other:(id)sender
{
    ProductViewController *collection=[[ProductViewController alloc] initWithNibName:@"ProductViewController" bundle:nil];
    collection.link=@"Other";
    collection.viewPushedName = @"Other";
    [self.navigationController pushViewController:collection animated:YES];
}

- (IBAction)Silverware:(id)sender {
    CountrayViewController *countray=[[CountrayViewController alloc] initWithNibName:@"CountrayViewController" bundle:nil];
    countray.mid=2;
    countray.viewPushedName = @"Silver";
    [self.navigationController pushViewController:countray animated:YES];
}

- (IBAction)Ceramic:(id)sender {
    CountrayViewController *countray=[[CountrayViewController alloc] initWithNibName:@"CountrayViewController" bundle:nil];
    countray.mid=10;
    countray.viewPushedName = @"Ceramic";
    [self.navigationController pushViewController:countray animated:YES];
    
}
@end
