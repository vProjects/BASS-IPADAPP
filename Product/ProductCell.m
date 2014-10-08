//
//  ProductCell.m
//  Product
//
//  Created by Sumit Kumar Garu on 22/06/14.
//  Copyright (c) 2014 Sumit Kumar Garu. All rights reserved.
//

#import "ProductCell.h"

#import "FontUtility.h"
@implementation ProductCell

+(id)productCell{
    ProductCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] objectAtIndex:0];
    [FontUtility updateFontsForView:cell];
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapButton:(id)sender {
    NSInteger actualPosition = (self.columnNumber * 3) + [sender tag];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"itemTappedNotification"
                                                        object:@(actualPosition)
                                                      userInfo:nil];
}

@end
