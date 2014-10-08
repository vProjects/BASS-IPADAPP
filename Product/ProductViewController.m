//
//  ProductViewController.m
//  Product
//
//  Created by Sumit Kumar Garu on 22/06/14.
//  Copyright (c) 2014 Sumit Kumar Garu. All rights reserved.
//

#import "ProductViewController.h"
#import "ProductCell.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "ProductDescriptionViewController.h"
#import "UIImageView+PhotoFrame.h"
#import "EasyTableView.h"
#import "FontUtility.h"

#define BASEURL @"http://app.newbyteas.com/chitra/thumbnails/"
#define kMaxItemPerPage 15
#define kThresholdForLazyLoading 15
#define kPaginationButtonImage @"round.png"

@interface ProductViewController ()
{
    UIImage *defaultImage;
}
@end

@interface ProductViewController () <EasyTableViewDelegate>

@property (nonatomic, readwrite, strong) EasyTableView *tableView;
@property (nonatomic, readwrite, assign) NSInteger totalItems;
@property (nonatomic, readwrite, strong) NSMutableArray *paginationButtonArray;
@property (nonatomic, readwrite, strong) UIButton *selectedPaginationButton;
@property (nonatomic, readwrite, assign) BOOL isDownloadingDataFromServer;
@property (nonatomic, readwrite, assign) NSInteger currentPage;

@end

@implementation ProductViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    defaultImage=[UIImage imageNamed:@"thumbImage.png"];
    self.parsePageIndex=1;
    self.CurrenetPageINdex=0;
    self.searchFrndArr=[[NSMutableArray alloc] init];
    [self downloadNextProducts];
}

- (void)downloadNextProducts {
    if ([self.link isEqualToString:@"Latest"])
    {
        [self LatestProduct];
    }
    //codes by singh
    else if([self.link isEqualToString:@"Electroplate"])
    {
        [self GetElectroplate];
    }
    //codes by singh
    else if([self.link isEqualToString:@"RockCrystal"])
    {
        [self GetRockCrystal];
    }
    else if ([self.link isEqualToString:@"Search"])
    {
        [self serachProduct:self.serchString];
    }
    else if ([self.link isEqualToString:@"Other"]){
        [self inviteSospoFriends];
    }else if ([self.link isEqualToString:@"Countary"]){
        if (self.mid==0) {
            [self countaryProduct];
        }else{
            [self countaryProductWwithMid];
        }
    }
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupTableView {
    if (!self.searchFrndArr.count) {
        return;
    }
    if (!self.tableView) {
        NSDictionary *data = self.searchFrndArr.firstObject;
        if (!data) {
            return;
        }
        self.totalItems = [data[@"count_total"] integerValue];
        [self setupPagination];
        self.tableView = [[EasyTableView alloc] initWithFrame:CGRectMake(50, 50, 900, 680) numberOfColumns:(((self.totalItems - 1) / 3 )+ 1) ofWidth:180];
        [self.view addSubview:self.tableView];
        self.tableView.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receivedProductTappedNotification:)
                                                     name:@"itemTappedNotification"
                                                   object:nil];
    }
    if (self.totalItems < self.searchFrndArr.count) {
        NSInteger extraElements = self.searchFrndArr.count - self.totalItems;
        [self.searchFrndArr removeObjectsInRange:NSMakeRange(self.totalItems, extraElements)];
#ifdef DEBUG
        [self showDebugAlertMessage:@"The total no of available items sent in count_total isn't equal to total amounts sent by server. Possibly because the server is still sending data even when no data should be sent, like if no data found for page 2, it sends back the 1st page data [DON'T DO THAT]"];
#endif
    }
    self.tableView.numberOfCells = ((self.searchFrndArr.count - 1) / 3) + 1;
    [self.tableView reloadData];
    [self refreshPaginationButtons];
    self.isDownloadingDataFromServer = NO;
}

- (void)showDebugAlertMessage:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:@"Wrong number of items sent"
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"OKAY"
                      otherButtonTitles:nil, nil] show];

}
- (void)setupPagination {
    NSInteger totalPage = 3;
    self.paginationButtonArray = [NSMutableArray arrayWithCapacity:totalPage];
    NSInteger padding = 20;
    NSInteger buttonWidth = 20;
    NSInteger buttonHeight = 20;
    NSInteger totalPaginationBarWidthRequired = (padding + buttonWidth) * totalPage - padding;
    NSInteger screenWidth = self.view.frame.size.width;
    NSInteger startingPoint = ((screenWidth - totalPaginationBarWidthRequired) / 2);
    startingPoint = MAX(0, startingPoint);
    for (NSInteger index = 0; index < totalPage; index++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSInteger buttonXPosition = startingPoint + index * (buttonWidth + padding);
        button.frame = CGRectMake(buttonXPosition, 735, buttonWidth, buttonHeight);
        [button setBackgroundImage:[UIImage imageNamed:kPaginationButtonImage] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:kPaginationButtonImage] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:kPaginationButtonImage] forState:UIControlStateHighlighted];
        [button setTag:index];
        [button setEnabled:NO];
        [button addTarget:self
                   action:@selector(didTapPaginationButton:)
         forControlEvents:UIControlEventTouchUpInside];
        if (index == 1) {
            button.transform = CGAffineTransformMakeScale(1.5,1.5);
        }
        [self.view addSubview:button];
        [self.paginationButtonArray addObject:button];
    }
}

- (void)refreshPaginationButtons {
    for (UIButton *button in self.paginationButtonArray) {
        [button setEnabled:YES];
    }
}

- (IBAction)didTapPaginationButton:(id)sender {
    NSInteger tag = [sender tag];
    NSInteger pageNumberToScrollTo = 0;
    if (tag == 0) {
        pageNumberToScrollTo = self.currentPage - 1;
    } else if (tag == 2) {
        pageNumberToScrollTo = self.currentPage + 1;
    } else {
        return;
    }
    NSInteger itemToScrollTo = kMaxItemPerPage * pageNumberToScrollTo;
    NSInteger indexPathToScroll = itemToScrollTo / 3;
    [self.tableView selectCellAtIndexPath:[NSIndexPath indexPathForRow:indexPathToScroll inSection:0]
                                 animated:YES];
}

- (void)receivedProductTappedNotification:(NSNotification *)notification {
    NSInteger index = [notification.object integerValue];
    ProductDescriptionViewController *product=[[ProductDescriptionViewController alloc] initWithNibName:@"ProductDescriptionViewController" bundle:nil];
    if (index < self.searchFrndArr.count) {
        product.productDict=[self.searchFrndArr objectAtIndex:index];
        product.allProducts=self.searchFrndArr;
        product.currentSelectedIndex = index;
        [self.navigationController pushViewController:product animated:YES];
    }

    
}

- (UIView *)easyTableView:(EasyTableView *)easyTableView viewForRect:(CGRect)rect {
    ProductCell *cell = [ProductCell productCell];
    return cell;
}

- (void)easyTableView:(EasyTableView *)easyTableView setDataForView:(UIView *)view forIndexPath:(NSIndexPath *)indexPath {
    ProductCell *cell  = (ProductCell *)view;
    cell.columnNumber = indexPath.row;
    NSArray *btnArray = @[cell.btn1, cell.btn2, cell.btn3];
    NSArray *imageArray = @[cell.imageVw1, cell.imageVw2, cell.imageVw3];
    NSArray *labelArray = @[cell.label1, cell.label2, cell.label3];
    for (NSInteger index = 0; index < btnArray.count; index++) {
        NSInteger requiredItemIndex = (indexPath.row * btnArray.count) + index;
        UIImageView *imageView = imageArray[index];
        UILabel *label = labelArray[index];
        UIButton *button = btnArray[index];
        if (self.searchFrndArr.count <= requiredItemIndex) {
            button = nil;
            imageView = [[UIImageView alloc] initWithImage:defaultImage];
            label = [[UILabel alloc] init];
            [label setHidden:true];
            continue;
        }
        NSDictionary *dataDictionary = self.searchFrndArr[requiredItemIndex];
        label.text = [self stringByStrippingHTML:dataDictionary[@"Provenance"]];
        NSString *photoURL;
        if (dataDictionary[@"Photos"]) {
            photoURL = [dataDictionary[@"Photos"] componentsSeparatedByString:@","].firstObject;
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASEURL, photoURL]];
            if (url) {
                [imageView setImageWithURL:url placeholderImage:defaultImage];

            } else {
                NSLog(@"url not found");
            }
        } else {
            imageView.image = defaultImage;
#ifdef DEBUG
            [self showDebugAlertMessage:[NSString stringWithFormat:@"%@ missing photo", label.text]];
#endif
        }
        [imageView applyPhotoFrame];

    }
    [self updatePaginationSelectedButtonForColumn:indexPath.row];
    if ((indexPath.row * 3) + kThresholdForLazyLoading >= self.searchFrndArr.count && !self.isDownloadingDataFromServer && self.searchFrndArr.count < self.totalItems) {
        self.isDownloadingDataFromServer = YES;
        [self downloadNextProducts];
    }
}

- (void)updatePaginationSelectedButtonForColumn:(NSInteger)column {
    NSInteger pageNumber = (column / 5) + 1;
    NSInteger totalPage = self.totalItems / kMaxItemPerPage + 1;
    if (pageNumber == 1) {
        [self.paginationButtonArray[0] setHidden:YES];
    } else {
        [self.paginationButtonArray[0] setHidden:NO];
    }
    if (pageNumber == totalPage) {
        [self.paginationButtonArray[2] setHidden:YES];
    } else {
        [self.paginationButtonArray[2] setHidden:NO];
    }
    for (NSInteger index = 0; index < self.paginationButtonArray.count; index ++) {
        UIButton *button = (UIButton *)self.paginationButtonArray[index];
        [button setTitle:[NSString stringWithFormat:@"%d", pageNumber - 1 + index]
                forState:UIControlStateNormal];
        button.font = [UIFont systemFontOfSize:10.0f];
        [FontUtility updateFontsForView:button.titleLabel];
    }
    self.currentPage = pageNumber - 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma  mark - ClassMethod

- (IBAction)back:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)home:(id)sender
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(NSString *) stringByStrippingHTML:(NSString *)htmlString {
    NSRange r;
    NSString *s = [htmlString copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"-/:;()$&@\?!\[]{}#%^*+=_|~<>€£¥"];
    NSString *resultString = [[s componentsSeparatedByCharactersInSet:doNotWant] componentsJoinedByString:@""];
    return resultString;
}

- (void)inviteSospoFriends
{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://app.newbyteas.com/chitra/json/json.php?limit=%d",self.parsePageIndex]];
    
    __weak ASIFormDataRequest *loginRequest = [ASIFormDataRequest requestWithURL:url];
    
    [loginRequest setTimeOutSeconds:30.0];
    [loginRequest setCompletionBlock:^{
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        NSError *error=nil;
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:loginRequest.responseData options:kNilOptions error:&error];
        [self.searchFrndArr addObjectsFromArray:arr];
        self.parsePageIndex++;
        [self loadNextProduct];
    }];
    
    [loginRequest setFailedBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
    [loginRequest setRequestMethod:@"GET"];
    [loginRequest startAsynchronous];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}


- (void)loadNextProduct
{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://app.newbyteas.com/chitra/json/json.php?limit=%d",self.parsePageIndex]];
    
    __weak ASIFormDataRequest *loginRequest = [ASIFormDataRequest requestWithURL:url];
    
    [loginRequest setTimeOutSeconds:30.0];
    [loginRequest setCompletionBlock:^{
        
        
        NSError *error=nil;
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:loginRequest.responseData options:kNilOptions error:&error];
        [self.searchFrndArr addObjectsFromArray:arr];
        [self setupTableView];
        if (self.searchFrndArr.count==0) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Product Found!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            self.parsePageIndex++;
        }
        
    }];
    
    [loginRequest setFailedBlock:^{
        
    }];
    
    [loginRequest setRequestMethod:@"GET"];
    [loginRequest startAsynchronous];
    
}

//codes by Singh ---------------#Starts

-(void)GetElectroplate
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://app.newbyteas.com/chitra/json/getItemByMaterial.php?mid=15&p=%d",self.parsePageIndex]];
    
    __weak ASIFormDataRequest *loginRequest = [ASIFormDataRequest requestWithURL:url];
    
    [loginRequest setTimeOutSeconds:30.0];
    [loginRequest setCompletionBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSError *error=nil;
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:loginRequest.responseData options:kNilOptions error:&error];
        
        [self.searchFrndArr addObjectsFromArray:arr];
        self.parsePageIndex++;
        [self GetElectroplateNext];
        [self setupTableView];
        
    }];
    
    [loginRequest setFailedBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    }];
    
    [loginRequest setRequestMethod:@"GET"];
    [loginRequest startAsynchronous];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)GetElectroplateNext
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://app.newbyteas.com/chitra/json/getItemByMaterial.php?mid=15&p=%d",self.parsePageIndex]];
    
    __weak ASIFormDataRequest *loginRequest = [ASIFormDataRequest requestWithURL:url];
    
    [loginRequest setTimeOutSeconds:30.0];
    [loginRequest setCompletionBlock:^{
        
        NSError *error=nil;
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:loginRequest.responseData options:kNilOptions error:&error];
        [self.searchFrndArr addObjectsFromArray:arr];
        
        [self setupTableView];
        if (self.searchFrndArr.count==0) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Product Found!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            self.parsePageIndex++;
        }
    }];
    
    [loginRequest setFailedBlock:^{
        
        
    }];
    
    [loginRequest setRequestMethod:@"GET"];
    [loginRequest startAsynchronous];
}

-(void)GetRockCrystal
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://app.newbyteas.com/chitra/json/getItemByMaterial.php?mid=22&p=%d",self.parsePageIndex]];
    
    __weak ASIFormDataRequest *loginRequest = [ASIFormDataRequest requestWithURL:url];
    
    [loginRequest setTimeOutSeconds:30.0];
    [loginRequest setCompletionBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSError *error=nil;
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:loginRequest.responseData options:kNilOptions error:&error];
        
        [self.searchFrndArr addObjectsFromArray:arr];
        self.parsePageIndex++;
        [self GetElectroplateNext];
        [self setupTableView];
        
    }];
    
    [loginRequest setFailedBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    }];
    
    [loginRequest setRequestMethod:@"GET"];
    [loginRequest startAsynchronous];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)GetRockCrystalNext
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://app.newbyteas.com/chitra/json/getItemByMaterial.php?mid=22&p=%d",self.parsePageIndex]];
    
    __weak ASIFormDataRequest *loginRequest = [ASIFormDataRequest requestWithURL:url];
    
    [loginRequest setTimeOutSeconds:30.0];
    [loginRequest setCompletionBlock:^{
        
        NSError *error=nil;
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:loginRequest.responseData options:kNilOptions error:&error];
        [self.searchFrndArr addObjectsFromArray:arr];
        
        [self setupTableView];
        if (self.searchFrndArr.count==0) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Product Found!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            self.parsePageIndex++;
        }
    }];
    
    [loginRequest setFailedBlock:^{
        
        
    }];
    
    [loginRequest setRequestMethod:@"GET"];
    [loginRequest startAsynchronous];
}

//codes by Singh ---------------#ends

-(void)LatestProduct
{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://app.newbyteas.com/chitra/json/getItemsByAccDate.php?p=%d",self.parsePageIndex]];
    
    __weak ASIFormDataRequest *loginRequest = [ASIFormDataRequest requestWithURL:url];
    
    [loginRequest setTimeOutSeconds:30.0];
    [loginRequest setCompletionBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSError *error=nil;
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:loginRequest.responseData options:kNilOptions error:&error];
        [self.searchFrndArr addObjectsFromArray:arr];
        self.parsePageIndex++;
        [self LatestProductNext];
        [self setupTableView];
        
    }];
    
    [loginRequest setFailedBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    }];
    
    [loginRequest setRequestMethod:@"GET"];
    [loginRequest startAsynchronous];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)LatestProductNext
{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://app.newbyteas.com/chitra/json/getItemsByAccDate.php?p=%d",self.parsePageIndex]];
    
    __weak ASIFormDataRequest *loginRequest = [ASIFormDataRequest requestWithURL:url];
    
    [loginRequest setTimeOutSeconds:30.0];
    [loginRequest setCompletionBlock:^{
        
        NSError *error=nil;
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:loginRequest.responseData options:kNilOptions error:&error];
        [self.searchFrndArr addObjectsFromArray:arr];
        
        [self setupTableView];
        if (self.searchFrndArr.count==0) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Product Found!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            self.parsePageIndex++;
        }
    }];
    
    [loginRequest setFailedBlock:^{
        
        
    }];
    
    [loginRequest setRequestMethod:@"GET"];
    [loginRequest startAsynchronous];
}



-(void)serachProduct:(NSString *)search{
    
    NSString *combineUrl=[NSString stringWithFormat:@"http://app.newbyteas.com/chitra/json/getItemWithImage.php?name=%@&p=%d",search,self.parsePageIndex];
    NSURL *url = [NSURL URLWithString:combineUrl];
    __weak ASIFormDataRequest *loginRequest = [ASIFormDataRequest requestWithURL:url];
    
    [loginRequest setTimeOutSeconds:30.0];
    [loginRequest setCompletionBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSError *error=nil;
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:loginRequest.responseData options:kNilOptions error:&error];
        [self.searchFrndArr addObjectsFromArray:arr];
        self.parsePageIndex++;
        [self serachProductNext:search];
        [self setupTableView];
        
    }];
    
    [loginRequest setFailedBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    }];
    
    [loginRequest setRequestMethod:@"GET"];
    [loginRequest startAsynchronous];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

}

-(void)serachProductNext:(NSString *)search{
    
    NSString *combineUrl=[NSString stringWithFormat:@"http://app.newbyteas.com/chitra/json/getItemWithImage.php?name=%@&p=%d",search,self.parsePageIndex];
    NSURL *url = [NSURL URLWithString:combineUrl];
    __weak ASIFormDataRequest *loginRequest = [ASIFormDataRequest requestWithURL:url];
    
    [loginRequest setTimeOutSeconds:30.0];
    [loginRequest setCompletionBlock:^{
        
        NSError *error=nil;
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:loginRequest.responseData options:kNilOptions error:&error];
        [self.searchFrndArr addObjectsFromArray:arr];
        
        [self setupTableView];
        if (self.searchFrndArr.count==0) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Product Found!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            self.parsePageIndex++;
        }
        
    }];
    
    [loginRequest setFailedBlock:^{
        
        
    }];
    
    [loginRequest setRequestMethod:@"GET"];
    [loginRequest startAsynchronous];
    
}

-(void)countaryProduct{
    
    NSString *combineUrl;
    if (self.CountrayId == 0) {
        combineUrl = [NSString stringWithFormat:@"http://app.newbyteas.com/chitra/json/getItemWithImage.php?p=%d", self.parsePageIndex];
    } else {
        combineUrl = [NSString stringWithFormat:@"http://app.newbyteas.com/chitra/json/getItemByCountry.php?cid=%d&p=%d",self.CountrayId,self.parsePageIndex];
    }
    NSURL *url = [NSURL URLWithString:combineUrl];
    __weak ASIFormDataRequest *loginRequest = [ASIFormDataRequest requestWithURL:url];
    
    [loginRequest setTimeOutSeconds:30.0];
    [loginRequest setCompletionBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSError *error=nil;
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:loginRequest.responseData options:kNilOptions error:&error];
        [self.searchFrndArr addObjectsFromArray:arr];
        self.parsePageIndex++;
        [self countaryProductNext];
        [self setupTableView];
    }];
    
    [loginRequest setFailedBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    }];
    
    [loginRequest setRequestMethod:@"GET"];
    [loginRequest startAsynchronous];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)countaryProductNext{
    NSString *combineUrl;
    if (self.CountrayId == 0) {
        combineUrl = [NSString stringWithFormat:@"http://app.newbyteas.com/chitra/json/getItemWithImage.php?p=%d", self.parsePageIndex];
    } else {
        combineUrl = [NSString stringWithFormat:@"http://app.newbyteas.com/chitra/json/getItemByCountry.php?cid=%d&p=%d",self.CountrayId,self.parsePageIndex];
    }
    NSURL *url = [NSURL URLWithString:combineUrl];
    __weak ASIFormDataRequest *loginRequest = [ASIFormDataRequest requestWithURL:url];
    
    [loginRequest setTimeOutSeconds:30.0];
    [loginRequest setCompletionBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSError *error=nil;
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:loginRequest.responseData options:kNilOptions error:&error];
        [self.searchFrndArr addObjectsFromArray:arr];
        if (self.searchFrndArr.count==0) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Product Found!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            self.parsePageIndex++;
            [self setupTableView];
        }
    }];
    
    [loginRequest setFailedBlock:^{
    }];
    
    [loginRequest setRequestMethod:@"GET"];
    [loginRequest startAsynchronous];
}

- (NSURL *)urlForProductWithMid {
    NSString *combineUrl;
    if (self.mid == 21) {
        if (self.CountrayId == 0) {
            combineUrl = [NSString stringWithFormat:@"http://app.newbyteas.com/chitra/json/getItemByXXI.php?p=%d", self.parsePageIndex];
        } else {
            combineUrl = [NSString stringWithFormat:@"http://app.newbyteas.com/chitra/json/getItemByCountry_XXI.php?cid=%D&p=%d", self.CountrayId, self.parsePageIndex];
        }
    } else {
        if (self.CountrayId == 0) {
            combineUrl = [NSString stringWithFormat:@"http://app.newbyteas.com/chitra/json/getItemByMaterial.php?mid=%d&p=%d", self.mid, self.parsePageIndex];
        } else {
            combineUrl = [NSString stringWithFormat:@"http://app.newbyteas.com/chitra/json/json1.php?mid=%d&cid=%d&p=%d",self.mid,self.CountrayId,self.parsePageIndex];
        }
    }
    NSLog(combineUrl);
    return [NSURL URLWithString:combineUrl];
}

-(void)countaryProductWwithMid{
    NSURL *url = [self urlForProductWithMid];
    __weak ASIFormDataRequest *loginRequest = [ASIFormDataRequest requestWithURL:url];
    
    [loginRequest setTimeOutSeconds:30.0];
    [loginRequest setCompletionBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSError *error=nil;
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:loginRequest.responseData options:kNilOptions error:&error];
        [self.searchFrndArr addObjectsFromArray:arr];
        self.parsePageIndex++;
        [self countaryProductWithMidNext];
        [self setupTableView];
        
        
    }];
    
    [loginRequest setFailedBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    }];
    
    [loginRequest setRequestMethod:@"GET"];
    [loginRequest startAsynchronous];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)countaryProductWithMidNext{
    NSURL *url = [self urlForProductWithMid];
    __weak ASIFormDataRequest *loginRequest = [ASIFormDataRequest requestWithURL:url];
    
    [loginRequest setTimeOutSeconds:30.0];
    [loginRequest setCompletionBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSError *error=nil;
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:loginRequest.responseData options:kNilOptions error:&error];
        [self.searchFrndArr addObjectsFromArray:arr];
        if (self.searchFrndArr.count==0) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Product Found!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            self.parsePageIndex++;
            [self setupTableView];
        }
    }];
    
    [loginRequest setFailedBlock:^{
        
        
    }];
    
    [loginRequest setRequestMethod:@"GET"];
    [loginRequest startAsynchronous];
}

@end
