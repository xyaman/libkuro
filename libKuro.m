#import "public/libKuro.h"

@implementation Kuro : NSObject
+ (UIColor *) getPrimaryColor:(UIImage*) image{

    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    CIVector *extentVector = [CIVector vectorWithX:inputImage.extent.origin.x Y:inputImage.extent.origin.y Z:inputImage.extent.size.width W:inputImage.extent.size.height];

    CIFilter *filter = [CIFilter filterWithName:@"CIAreaAverage" withInputParameters:@{@"inputImage": inputImage, @"inputExtent": extentVector}];
    CIImage *outputImage = filter.outputImage;

     // A bitmap consisting of (r, g, b, a) value
    UInt8 bitmap[4] = {0};
    CIContext *context = [[CIContext alloc] initWithOptions:@{kCIContextWorkingColorSpace: [NSNull null]}];

    [context render:outputImage
      toBitmap:&bitmap
      rowBytes:4 
      bounds:CGRectMake(0, 0, 1, 1) 
      format:kCIFormatRGBA8
      colorSpace:nil];

    return [UIColor colorWithRed:bitmap[0]/ 255.0 green:bitmap[1] / 255.0 blue:bitmap[2]/255.0 alpha:bitmap[3]/255.0];

}

// https://gist.github.com/justinHowlett/4611988

// It generally won't work as expected, probably I'll be using this function just for now
+ (BOOL) isDarkImage:(UIImage*) inputImage {
    
    BOOL isDark = FALSE;
    
    CFDataRef imageData = CGDataProviderCopyData(CGImageGetDataProvider(inputImage.CGImage));
    const UInt8 *pixels = CFDataGetBytePtr(imageData);
    
    int darkPixels = 0;
    
    int length = CFDataGetLength(imageData);
    int const darkPixelThreshold = (inputImage.size.width*inputImage.size.height)*.45;
    
    for(int i=0; i<length; i+=4)
    {
        int r = pixels[i];
        int g = pixels[i+1];
        int b = pixels[i+2];
        
        //luminance calculation gives more weight to r and b for human eyes
        float luminance = (0.299*r + 0.587*g + 0.114*b);
        if (luminance<150) darkPixels ++;
    }
    
    if (darkPixels >= darkPixelThreshold)
        isDark = YES;

    CFRelease(imageData);
    
    return isDark;
}

// https://www.w3.org/WAI/ER/WD-AERT/#color-contrast
+ (BOOL) isDarkColor:(UIColor *) color {

    const CGFloat *componentColors = CGColorGetComponents(color.CGColor);
    CGFloat colorBrightness = ((componentColors[0] * 299) + (componentColors[1] * 587) + (componentColors[2] * 114)) / 1000;

    return colorBrightness < 0.5;
}

// https://stackoverflow.com/questions/11598043/get-slightly-lighter-and-darker-color-from-uicolor
+ (UIColor *)lighterColorForColor:(UIColor *)c {
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a]) {
        return [UIColor colorWithRed:MIN(r + 0.2, 1.0) green:MIN(g + 0.2, 1.0) blue:MIN(b + 0.2, 1.0) alpha:a];
    }

    return nil;
}

+ (UIColor *)darkerColorForColor:(UIColor *)c {
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a]) {
        return [UIColor colorWithRed:MAX(r - 0.2, 0.0) green:MAX(g - 0.2, 0.0) blue:MAX(b - 0.2, 0.0) alpha:a];
    }

    return nil;
}
@end
