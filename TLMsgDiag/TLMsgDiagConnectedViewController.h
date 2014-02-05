//
//  TLMsgDiagConnectedViewController.h
//  TLMsgDiag
//
//  Created by Chentou TONG on 5/2/14.
//  Copyright (c) 2014 Chentou TONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigParameter.h"

@interface TLMsgDiagConnectedViewController : UITableViewController <NSStreamDelegate>

- (IBAction)btnRetry:(id)sender;
- (IBAction)btnCancel:(id)sender;

@property (nonatomic, strong) ConfigParameter *parameterUse;
@property (nonatomic, strong) UIAlertView *Alert;

@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, strong) NSOutputStream *outputStream;


@end
