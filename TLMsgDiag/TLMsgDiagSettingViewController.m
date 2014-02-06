//
//  TLMsgDiagSettingViewController.m
//  TLMsgDiag
//
//  Created by Chentou TONG on 5/2/14.
//  Copyright (c) 2014 Chentou TONG. All rights reserved.
//

#import "TLMsgDiagSettingViewController.h"
#import "ConfigParameter.h"
#import "HudView.h"

@interface TLMsgDiagSettingViewController ()

@end

@implementation TLMsgDiagSettingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.parameterEdit != nil) {
        self.svrIpText.text = self.parameterEdit.svrIPaddress;
        self.svrPortNoText.text = self.parameterEdit.svrPortNo;
        self.iamNameText.text = self.parameterEdit.iamName;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnDone:(id)sender
{
    if (self.parameterEdit == nil) {
        HudView *hudView = [HudView hudInView:self.navigationController.view animated:YES];
        hudView.text = @"Added";
        [self performSelector:@selector(closeScreen) withObject:nil afterDelay:1.0];
    } else {
        HudView *hudView = [HudView hudInView:self.navigationController.view animated:YES];
        hudView.text = @"Updated";
        [self performSelector:@selector(closeScreen) withObject:nil afterDelay:1.0];
    }
}

- (void)closeScreen
{
    if (self.parameterEdit == nil) {
        ConfigParameter *para = [[ConfigParameter alloc] init];
        para.svrIPaddress = self.svrIpText.text;
        para.svrPortNo = self.svrPortNoText.text;
        para.iamName = self.iamNameText.text;
        [self.delegate TLMsgDiagSettingViewController:self didFinishAddingSetting:para];
    } else {
        self.parameterEdit.svrIPaddress = self.svrIpText.text;
        self.parameterEdit.svrPortNo = self.svrPortNoText.text;
        self.parameterEdit.iamName = self.iamNameText.text;
        [self.delegate TLMsgDiagSettingViewController:self didFinishEditingSetting:self.parameterEdit];
    }
}

- (IBAction)btnCancel:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
