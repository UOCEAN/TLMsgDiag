//
//  HudView.h
//  MyLocations
//
//  Created by Chentou TONG on 4/2/14.
//  Copyright (c) 2014 Chentou TONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HudView : UIView

+ (instancetype)hudInView:(UIView *)view animated:(BOOL)animated;

@property (nonatomic, strong) NSString *text;

@end
