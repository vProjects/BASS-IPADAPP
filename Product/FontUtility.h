//
//  FontUtility.h
//  Product
//
//  Created by Shimul Bhowmik on 8/18/14.
//

#define kFontSemiBold @"WOXYKI+Bembo-Semibold"
#define kFontRegular @"WOXYKI+Bembo"

@interface FontUtility : NSObject

+ (void)updateFontsForView:(UIView *)view;
+ (void)updateFontsForView:(UIView *)view
                  fontName:(NSString *)fontName;

@end
