//
//  HomeViewController.m
//  Product
//
//  Created by Sumit Kumar Garu on 22/06/14.
//  Copyright (c) 2014 Sumit Kumar Garu. All rights reserved.
//

#import "HomeViewController.h"

#import "CollectionViewController.h"
#import "CountrayViewController.h"
#import "ProductViewController.h"
#import "SearchViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - ClassMethod

- (IBAction)latest:(id)sender {
    ProductViewController *collection=[[ProductViewController alloc] initWithNibName:@"ProductViewController" bundle:nil];
    collection.link=@"Latest";
    collection.viewPushedName = @"Latest Acquisitions";
    [self.navigationController pushViewController:collection animated:YES];
}

- (IBAction)search:(id)sender {
    SearchViewController *serach=[[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    serach.viewPushedName = @"Search";
    [self.navigationController pushViewController:serach animated:YES];
}

- (IBAction)collection:(id)sender {
    CollectionViewController *collection=[[CollectionViewController alloc] initWithNibName:@"CollectionViewController" bundle:nil];
    collection.viewPushedName = @"Collection";
    [self.navigationController pushViewController:collection animated:YES];
}

- (IBAction)didTapXXICenturyButton:(id)sender {
    ProductViewController *collection=[[ProductViewController alloc] initWithNibName:@"ProductViewController" bundle:nil];
    collection.link=@"XXICentury";
    collection.viewPushedName = @"XXI Century";
    [self.navigationController pushViewController:collection animated:YES];
}

- (IBAction)didTapElectroplateButton:(id)sender {
    ProductViewController *collection=[[ProductViewController alloc] initWithNibName:@"ProductViewController" bundle:nil];
    collection.link=@"Electroplate";
    collection.viewPushedName = @"Electroplate";
    [self.navigationController pushViewController:collection animated:YES];
}

- (IBAction)didTapRockCrystalButton:(id)sender {
    ProductViewController *collection=[[ProductViewController alloc] initWithNibName:@"ProductViewController" bundle:nil];
    collection.link=@"RockCrystal";
    collection.viewPushedName = @"Rock Crystal";
    [self.navigationController pushViewController:collection animated:YES];
}

@end
