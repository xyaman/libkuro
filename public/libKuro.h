#import "UIKit/UIKit.h"

@interface Kuro : NSObject
+ (UIColor *) getPrimaryColor:(UIImage*) image;
+ (BOOL) isDarkImage:(UIImage*) image;
+ (BOOL) isDarkColor:(UIColor *) color; 
+ (UIColor *)lighterColorForColor:(UIColor *)c;
+ (UIColor *)darkerColorForColor:(UIColor *)c;
@end