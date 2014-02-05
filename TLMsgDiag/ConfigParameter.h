//
//  ConfigParameter.h
//  TLMsgDiag
//
//  Created by Chentou TONG on 5/2/14.
//  Copyright (c) 2014 Chentou TONG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigParameter : NSObject <NSCoding>

@property (nonatomic, copy) NSString *svrIPaddress;
@property (nonatomic, copy) NSString *svrPortNo;
@property (nonatomic, copy) NSString *iamName;

@end
