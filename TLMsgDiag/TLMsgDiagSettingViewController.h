//
//  TLMsgDiagSettingViewController.h
//  TLMsgDiag
//
//  Created by Chentou TONG on 5/2/14.
//  Copyright (c) 2014 Chentou TONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TLMsgDiagSettingViewController;
@class ConfigParameter;

@protocol TLMsgDiagSettingViewControllerDelegate <NSObject>

- (void)TLMsgDiagSettingViewControllerDidCancel:(TLMsgDiagSettingViewController *)controller;

- (void)TLMsgDiagSettingViewController:(TLMsgDiagSettingViewController *)controller didFinishEditingSetting:(ConfigParameter *)parameter;

- (void)TLMsgDiagSettingViewController:(TLMsgDiagSettingViewController *)controller didFinishAddingSetting:(ConfigParameter *)parameter;

@end

@interface TLMsgDiagSettingViewController : UITableViewController
- (IBAction)btnDone:(id)sender;
- (IBAction)btnCancel:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *svrIpText;

@property (weak, nonatomic) IBOutlet UITextField *svrPortNoText;
@property (weak, nonatomic) IBOutlet UITextField *iamNameText;

@property (nonatomic, weak) id <TLMsgDiagSettingViewControllerDelegate> delegate;
@property (nonatomic, strong) ConfigParameter *parameterEdit;

@end
