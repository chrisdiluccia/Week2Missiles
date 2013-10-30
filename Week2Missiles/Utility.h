#import <Foundation/Foundation.h>

@interface Utility : NSObject

+(UIColor *)randomColor;
+(int)randomNumberBetweenZeroAnd:(int)maxNumber;
+(UILabel * )makeLabel:(NSString *)title :(int)size;

double randomFloat();

@end
