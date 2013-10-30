#import "Box.h"

@implementation Box


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initMakeMeABox:(NSString *)fileName
{
    
    CGRect frame = CGRectMake(0, 0, 40, 40);
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _deltaX = 0.2;
        _deltaY = 0.5;
        
        UIImageView *photoView;
        photoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:fileName]];
        photoView.frame = CGRectMake(0, 0, frame.size.width * 0.8, frame.size.height * 0.8);
        // setting content mode will keep the aspect ratio of you image
        photoView.hidden = NO;
        
        [self addSubview:photoView];
    }
    return self;
}

@end
