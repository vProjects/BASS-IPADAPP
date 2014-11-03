//
//  CountrayViewController.m
//  Product
//
//  Created by Sumit Kumar Garu on 28/06/14.
//  Copyright (c) 2014 Sumit Kumar Garu. All rights reserved.
//

#import "CountrayViewController.h"
#import "ProductViewController.h"
#import "CountrayCollectionViewCell.h"

#import <UIKit/UICollectionView.h>
#import <UIKit/UICollectionViewCell.h>

#import "ASIFormDataRequest.h"

#define kCountryURL @"http://app.newbyteas.com/chitra/json/getCountry.php"
#define kCountryID @"CountryID"
#define kCountryName @"CountryName"

@interface CountrayViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, readwrite, strong) UIActivityIndicatorView *activityViewIndicator;

@property (nonatomic, readwrite, strong) NSMutableArray *countryData;

@end

@implementation CountrayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _countryData = [NSMutableArray array];
        [self addObserver];
    }
    return self;
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedButtonTappedNotification:)
                                                 name:@"didTapCountryButton"
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupActivityIndicator];
    [self requestCountryData];
}

- (void)requestCountryData {
    NSURL *url = [NSURL URLWithString:kCountryURL];
    
    __weak ASIFormDataRequest *countryDataRequest = [ASIFormDataRequest requestWithURL:url];
    countryDataRequest.timeOutSeconds = 20.0f;
    __weak CountrayViewController *weakSelf = self;
    [countryDataRequest setCompletionBlock:^{
        __strong CountrayViewController *strongSelf = weakSelf;
        NSError *error = nil;
        NSArray *data=[NSJSONSerialization JSONObjectWithData:countryDataRequest.responseData options:kNilOptions error:&error];
        [strongSelf didReceiveCountryWithData:data];
    }];

    [countryDataRequest setFailedBlock:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                        message:@"You must be connected to the internet to use this app."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];
    countryDataRequest.requestMethod = @"GET";
    [countryDataRequest startAsynchronous];
}

- (void)setupActivityIndicator {
    _activityViewIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:_activityViewIndicator];
    [_activityViewIndicator startAnimating];
    CGSize screenSize = self.view.bounds.size;
    _activityViewIndicator.center = CGPointMake(screenSize.width/2, screenSize.height/2);
}

- (void)removeActivityIndicator {
    [self.activityViewIndicator stopAnimating];
    [self.activityViewIndicator removeFromSuperview];
}

- (void)didReceiveCountryWithData:(NSArray *)data {
    [self.countryData addObjectsFromArray:data];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"xyz"];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self removeActivityIndicator];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionView Data source
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.countryData.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CountrayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"xyz" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell updateCountryCode:0];
        cell.countryName.text = @"See All";
    } else {
        NSDictionary *data = self.countryData[indexPath.row - 1];
        [cell updateCountryCode:[data[kCountryID] integerValue]];
        cell.countryName.text = data[kCountryName];
    }
    return cell;
}

#pragma mark – UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retval = CGSizeMake(250, 55);
    return retval;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 0, 0, 0);
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (IBAction)home:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)receivedButtonTappedNotification:(NSNotification *)notification {
    NSDictionary *data = notification.object;
    NSInteger countryId = [data[@"id"] integerValue];
    NSString *countryName = data[@"name"];
    ProductViewController *collection=[[ProductViewController alloc] initWithNibName:@"ProductViewController" bundle:nil];
    collection.link = @"Countary";
    collection.mid = self.mid;
    collection.CountrayId = countryId;
    collection.viewPushedName = countryName;
    [self.navigationController pushViewController:collection animated:YES];
}

@end
