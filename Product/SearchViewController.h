//
//  SearchViewController.h
//  Product
//
//  Created by Sumit Kumar Garu on 22/06/14.
//  Copyright (c) 2014 Sumit Kumar Garu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ViewController.h"

@interface SearchViewController : ViewController
@property (weak, nonatomic) IBOutlet UITextField *searchTxt;
- (IBAction)back:(id)sender;
- (IBAction)home:(id)sender;

@end
