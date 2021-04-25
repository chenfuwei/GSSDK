//
//  UIColor+HexString.h
//  Webcast
//
//  Created by Gaojin Hsu on 11/18/15.
//  Copyright © 2015 Geensee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexString)
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (UIColor *) colorWithHexNSString: (NSString *) hexString;
- (NSString*)RGBAString;
@end
