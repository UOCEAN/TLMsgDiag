//
//  HudView.m
//  MyLocations
//
//  Created by Chentou TONG on 4/2/14.
//  Copyright (c) 2014 Chentou TONG. All rights reserved.
//

#import "HudView.h"

@implementation HudView

+ (instancetype)hudInView:(UIView *)view animated:(BOOL)animated
{
    HudView *hudView = [[HudView alloc] initWithFrame:view.bounds];
    hudView.opaque = NO;
    
    [view addSubview:hudView];
    view.userInteractionEnabled = NO;
    // hudView.backgroundColor = [UIColor colorWithRed:1.0f green:0 blue:0 alpha:0.5f];
    
    [hudView showAnimate:animated];
    return hudView;
}

// invoked whenever UIKit wants your view to redraw itself.
- (void)drawRect:(CGRect)rect
{
    const CGFloat boxWidth = 96.0f;
    const CGFloat boxHeight = 96.0f;
    
    CGRect boxRect = CGRectMake(
                                roundf(self.bounds.size.width - boxWidth)/2.0f,
                                roundf(self.bounds.size.height - boxHeight)/2.0f,
                                boxWidth, boxHeight);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:boxRect cornerRadius:10.0f];
    [[UIColor colorWithWhite:0.3f alpha:0.8f] setFill];
    [roundedRect fill];
    
    UIImage *image = [UIImage imageNamed:@"Checkmark"];
    CGPoint imagePoint = CGPointMake(self.center.x - roundf(image.size.width / 2.0f),
                                     self.center.y - roundf(image.size.height / 2.0f)
                                     - boxHeight / 8.0f);
    
    [image drawAtPoint:imagePoint];
    
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    CGSize textSize = [self.text sizeWithAttributes:attributes];
    
    CGPoint textPoint = CGPointMake(
                                    self.center.x - roundf(textSize.width / 2.0f),
                                    self.center.y - roundf(textSize.height / 2.0f) + boxHeight / 4.0f);
    [self.text drawAtPoint:textPoint withAttributes:attributes];
    
}

- (void)showAnimate:(BOOL)animated;
{
    if (animated) {
        //1
        self.alpha = 0.0f;
        self.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
        
        // 2
        [UIView animateWithDuration:.3 animations:^{
            
            //3
            self.alpha = 1.0f;
            self.transform = CGAffineTransformIdentity;
        }];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



@end
