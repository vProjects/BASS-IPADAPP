//
//  FontUtility.m
//  Product
//
//  Created by Shimul Bhowmik on 8/18/14.
//

#import "FontUtility.h"

@implementation FontUtility

+ (void)updateFontsForView:(UIView *)view {
    [self updateFontsForView:view fontName:kFontSemiBold];
}

+ (void)updateFontsForView:(UIView *)view fontName:(NSString *)fontName {
    NSMutableArray *uiElements = [NSMutableArray arrayWithArray:[view subviews]];
    [uiElements addObject:view];
    while (true) {
        if (uiElements.count <= 0) {
            break;
        }
        if ([uiElements.lastObject isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)uiElements.lastObject;
            UIFont *existingFont = label.font;
            label.font = [UIFont fontWithName:fontName size:existingFont.pointSize];
        }
        UIView *element = uiElements.lastObject;
        [uiElements removeObject:element];
        if (element.subviews.count > 0) {
            [uiElements addObjectsFromArray:element.subviews];
        }
    }
}

@end
