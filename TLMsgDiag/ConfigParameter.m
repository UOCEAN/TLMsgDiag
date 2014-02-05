//
//  ConfigParameter.m
//  TLMsgDiag
//
//  Created by Chentou TONG on 5/2/14.
//  Copyright (c) 2014 Chentou TONG. All rights reserved.
//

#import "ConfigParameter.h"

@implementation ConfigParameter

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self.svrIPaddress = [aDecoder decodeObjectForKey:@"svrIPaddress"];
        self.svrPortNo = [aDecoder decodeObjectForKey:@"svrPortNo"];
        self.iamName = [aDecoder decodeObjectForKey:@"iamName"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.svrIPaddress forKey:@"svrIPaddress"];
    [aCoder encodeObject:self.svrPortNo forKey:@"svrPortNo"];
    [aCoder encodeObject:self.iamName forKey:@"iamName"];
}


@end
