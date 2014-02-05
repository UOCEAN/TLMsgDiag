//
//  TLMsgDiagViewController.m
//  TLMsgDiag
//
//  Created by Chentou TONG on 5/2/14.
//  Copyright (c) 2014 Chentou TONG. All rights reserved.
//

#import "TLMsgDiagViewController.h"
#import "TLMsgDiagConnectedViewController.h"
#import "ConfigParameter.h"

@interface TLMsgDiagViewController ()

@property (nonatomic, strong) ConfigParameter *currentParameter;

@end

@implementation TLMsgDiagViewController
{
    NSMutableArray *_parameter;
}

- (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    return documentsDirectory;
}

- (NSString *)dataFilePath
{
    return [[self documentsDirectory] stringByAppendingPathComponent:@"TLMsgDiag.plist"];
            
}

- (void)loadConfigParemeter
{
    NSString *path = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        _parameter = [unarchiver decodeObjectForKey:@"ConfigParameter"];
        [unarchiver finishDecoding];
    } else {
        _parameter = [[NSMutableArray alloc] initWithCapacity:10];
        ConfigParameter *para;
        para = [[ConfigParameter alloc] init];
        para.svrIPaddress = @"192.168.102.10";
        para.svrPortNo = @"5000";
        para.iamName = @"MSG";
        [_parameter addObject:para];
    }
    self.currentParameter = _parameter[0];
}

- (void)saveConfigParemeter
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:_parameter forKey:@"ConfigParameter"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.currentParameter = [[ConfigParameter alloc] init];
        [self loadConfigParemeter];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Doc folder is %@", [self documentsDirectory]);
    NSLog(@"Svr IP: %@, Svr Port: %@, iam: %@", self.currentParameter.svrIPaddress,
          self.currentParameter.svrPortNo,
          self.currentParameter.iamName);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ServerConnected"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        TLMsgDiagConnectedViewController *controller = (TLMsgDiagConnectedViewController *)navigationController.topViewController;
        controller.parameterUse = self.currentParameter;
    } else if ([segue.identifier isEqualToString:@"ParameterEdit"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        TLMsgDiagSettingViewController *controller = (TLMsgDiagSettingViewController *)navigationController.topViewController;
        controller.delegate = self;
        controller.parameterEdit = self.currentParameter;
    }
}

#pragma mark - TLMsgDiagSettingViewController Delegate
- (void)TLMsgDiagSettingViewControllerDidCancel:(TLMsgDiagSettingViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)TLMsgDiagSettingViewController:(TLMsgDiagSettingViewController *)controller didFinishAddingSetting:(ConfigParameter *)parameter
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)TLMsgDiagSettingViewController:(TLMsgDiagSettingViewController *)controller didFinishEditingSetting:(ConfigParameter *)parameter
{
    NSLog(@"Svr IP: %@, Svr Port: %@, iam: %@", self.currentParameter.svrIPaddress,
          self.currentParameter.svrPortNo,
          self.currentParameter.iamName);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
