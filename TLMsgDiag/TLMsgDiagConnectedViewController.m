//
//  TLMsgDiagConnectedViewController.m
//  TLMsgDiag
//
//  Created by Chentou TONG on 5/2/14.
//  Copyright (c) 2014 Chentou TONG. All rights reserved.
//

#import "TLMsgDiagConnectedViewController.h"


@interface TLMsgDiagConnectedViewController ()

@end

@implementation TLMsgDiagConnectedViewController
{
    NSMutableArray *_showMsg;
    NSMutableArray *_messages;
    BOOL stateOfconnection;
}

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
    stateOfconnection = NO;
    
    NSLog(@"SvrIP: %@, SvrPort: %@, iam: %@",
          self.parameterUse.svrIPaddress,
          self.parameterUse.svrPortNo,
          self.parameterUse.iamName);
    
    // message queue
    _messages = [[NSMutableArray alloc] initWithCapacity:20];
    
    [self tryConnectServer];
    
    // Timer to decode message received
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(decodeMsgRx) userInfo:nil repeats:YES];
    
    _showMsg = [[NSMutableArray alloc] initWithCapacity:20];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnRetry:(id)sender
{
    [self disconnectServer];
    [self tryConnectServer];
}

- (IBAction)btnCancel:(id)sender
{
    [self disconnectServer];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_showMsg count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MsgRx";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    NSString *cellValue = [_showMsg objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;
    
    return cell;
}


#pragma mark - socket communication
- (void)presentAlertConnecting
{
    // present connecting alert windows until connection establish or time out
    self.Alert = [[UIAlertView alloc] initWithTitle:@"Connecting" message:@"Try to connect Server" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [self.Alert show];
    
}

-(void)sendMsg:(NSString *)msg
{
    NSString *response = [NSString stringWithFormat:@"%@", msg];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [self.outputStream write:[data bytes] maxLength:[data length]];
}

- (void)joinChat
{
    NSString *msg = [NSString stringWithFormat:@"%@%@", @"iam:", self.parameterUse.iamName];
    [self sendMsg:msg];
}

- (void)initNetworkCommunication
{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    // GFWDC01 IP address
    NSString *svrIP = self.parameterUse.svrIPaddress;
    NSLog(@"Server & Port: %@:%@", svrIP, self.parameterUse.svrPortNo);
    
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)svrIP, [self.parameterUse.svrPortNo intValue], &readStream, &writeStream);
    
    self.inputStream = (__bridge NSInputStream *)readStream;
    
    self.outputStream = (__bridge NSOutputStream *)writeStream;
    
    
    // delegate
    [self.inputStream setDelegate:self];
    [self.outputStream setDelegate:self];
    
    //schedule input stream to have procesing in the run loop
    [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    //open the connection
    [self.inputStream open];
    [self.outputStream open];
    
    //[self joinChat]; timer no work if enable
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(connectTimeOut) userInfo:nil repeats:NO];
    
}

- (void)aCommInitTimer
{ // one sec timer after present Alert
    [self initNetworkCommunication];
}

- (void)connectTimeOut
{
    // time out for conected
    if (stateOfconnection) {
        
    } else {
        // timeout
        [self.Alert dismissWithClickedButtonIndex:0 animated:YES];
        
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"*** Error ***" message:@"Failed to connect!" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
        [self disconnectServer];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}

- (void)tryConnectServer
{
    // show Alert popup first
    [self presentAlertConnecting];
    
    // timer to call network init
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(aCommInitTimer) userInfo:nil repeats:NO];
     
}

- (void)closeStream:(NSStream *)stream
{
    [stream close];
    [stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    stream = nil;
}

- (void)disconnectServer
{
    [self closeStream:self.inputStream];
    [self closeStream:self.outputStream];
}

- (void)messageReceived:(NSString *)message
{
    [_messages addObject:message];
    
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm:ss>>"];
    NSString *resultString = [dateFormatter stringFromDate:currentTime];
    NSString *timeStampMessage = [resultString stringByAppendingString:message];
    NSLog(@"Time Stamp msg: %@", timeStampMessage);
    
    long no_count = [_showMsg count];
    if (no_count >= 30) {
        [_showMsg removeAllObjects];
        [self.tableView reloadData];
    }
    
    // update tableview
    NSString *item;
    item = [[NSString alloc] init];
    item = timeStampMessage;
    [_showMsg addObject:item];
    [self.tableView reloadData];
    
    NSIndexPath *topIndexPath = [NSIndexPath indexPathForItem:_showMsg.count-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:topIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)decodeMsgRx
{
    while ([_messages count]) {
        id output = [_messages lastObject];
        
        NSRange end = [output rangeOfString:@":"];
        if (end.length == 0) {
            // format error
        } else {
            // format correct
            NSString *clientName = [output substringToIndex:end.location];
            NSString *tclientName = [clientName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *msgContent = [output substringFromIndex:end.location+1];
            NSString *tmsgContent = [msgContent stringByTrimmingCharactersInSet:
                                     [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if ([tclientName isEqualToString:@"MBA"]) {
                // own msg no need to proceed
                NSLog(@"Own msg, nil action");
            } else {
                NSRange endSite = [tmsgContent rangeOfString:@"@"];
                if (endSite.length !=0) {
                    NSString *siteName = [tmsgContent substringToIndex:endSite.location];
                    NSString *tsiteName = [siteName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    NSString *siteCMD = [tmsgContent substringFromIndex:endSite.location+1];
                    NSString *tsiteCMD = [siteCMD stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    NSLog(@"Client %@ say: %@@%@", tclientName, tsiteName, tsiteCMD);
                    
                    switch ([@[@"TLA", @"TLB", @"TLC", @"TLD", @"TLE", @"FH1", @"MBA"] indexOfObject:tsiteName]) {
                        case 0:
                            NSLog(@"Site A Msg");
                            break;
                        case 1:
                            NSLog(@"Site B Msg");
                            break;
                        case 2:
                            NSLog(@"Site C Msg");
                            break;
                        case 3:
                            NSLog(@"Site D Msg");
                            break;
                        case 4:
                            NSLog(@"Site E Msg");
                            break;
                        case 5:
                            NSLog(@"FH1");
                            break;
                        case 6:
                            NSLog(@"MBA Message");
                            break;
                        default:
                            NSLog(@"No such site****");
                            break;
                    }
                    
                }
            }
        }
        // remove from buffer
        [_messages removeObjectAtIndex:[_messages count] - 1];
    }
}


- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent
{
    switch (streamEvent) {
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            [self.Alert dismissWithClickedButtonIndex:0 animated:YES];
            stateOfconnection = YES;
            break;
        case NSStreamEventHasBytesAvailable:
            NSLog(@"Msg received");
            // msg received
            if (theStream == self.inputStream)
            {
                uint8_t buffer[1024];
                long len;
                
                while ([self.inputStream hasBytesAvailable]) {
                    len = [self.inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len>0){
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        if (nil != output) {
                            //save message
                            [self messageReceived:output];
                        }
                        
                    }
                }
            }
            break;
        case NSStreamEventErrorOccurred:
            NSLog(@"Cannot connect to the host");
            stateOfconnection = NO;
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [self.Alert dismissWithClickedButtonIndex:0 animated:YES];
            //back to chart mode
            break;
        case NSStreamEventEndEncountered:
            NSLog(@"Server close the connection");
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            // back to chart mode
            break;
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"Steam can accept bytes for writing");
            break;
        default:
            NSLog(@"%lu: Unknown event", streamEvent);
            NSLog(@"%lu: Unknown event", streamEvent);
            break;
    }
}

@end
