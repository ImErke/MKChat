//
//  MKChatViewController.m
//  MKChat
//
//  Created by tusm on 2018/9/27.
//  Copyright © 2018年 tusm. All rights reserved.
//

#import "MKChatViewController.h"
#import "MK_BaseMessageTableViewCell.h"

@interface MKChatViewController ()<EaseMessageViewControllerDelegate,EaseMessageViewControllerDataSource>

@end

@implementation MKChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我是小K";
    self.showRefreshHeader = YES;
    self.showRefreshFooter = YES;
    self.delegate = self;
    self.dataSource = self;
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_CALL object:@{@"chatter":self.conversation.conversationId, @"type":[NSNumber numberWithInt:0]}];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VideoClick:) name:KNOTIFICATION_CALL object:nil];
}
- (void)VideoClick:(NSNotification *)not
{
    EMCallOptions *options = [[EMClient sharedClient].callManager getCallOptions];
    //当对方不在线时，是否给对方发送离线消息和推送，并等待对方回应
    options.isSendPushIfOffline = NO;
    //设置视频分辨率：自适应分辨率、352 * 288、640 * 480、1280 * 720
    options.videoResolution = EMCallVideoResolutionAdaptive;
    //最大视频码率，范围 50 < videoKbps < 5000, 默认0, 0为自适应，建议设置为0
    options.maxVideoKbps = 0;
    //最小视频码率
    options.minVideoKbps = 0;
    //是否固定视频分辨率，默认为NO
    options.isFixedVideoResolution = NO;
    NSString *chatter = not.object[@"chatter"];
    __weak typeof(self) weakSelf = self;
    void (^completionBlock)(EMCallSession *, EMError *) = ^(EMCallSession *aCallSession, EMError *aError){
        //创建通话实例是否成功
        //TODO: code
        if (weakSelf)
        {
            if (aError || aCallSession == nil)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"呼叫失敗" message:aError.errorDescription delegate:nil cancelButtonTitle:@"確定" otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }
            //前提：EMCallSession *callSession 存在
            CGFloat width = 80;
            CGFloat height = self.view.frame.size.height / self.view.frame.size.width * width;
            aCallSession.localVideoView = [[EMCallLocalView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 90, 10, width, height)];
            [self.view addSubview:aCallSession.localVideoView];
            
            //同意接听视频通话之后
            aCallSession.remoteVideoView = [[EMCallRemoteView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            //设置视频页面缩放方式
            aCallSession.remoteVideoView.scaleMode = EMCallViewScaleModeAspectFill;
            [self.view addSubview:aCallSession.remoteVideoView];
            
        }else {
            [[EMClient sharedClient].callManager endCall:aCallSession.callId reason:EMCallEndReasonNoResponse];
        }
    };
    
    
    [[EMClient sharedClient].callManager startCall:EMCallTypeVideo remoteName:chatter ext:nil completion:^(EMCallSession *aCallSession, EMError *aError) {
        NSLog(@"aError=====>%@",aError.errorDescription);
        completionBlock(aCallSession, aError);
    }];
}
- (UITableViewCell *)messageViewController:(UITableView *)tableView cellForMessageModel:(id<IMessageModel>)messageModel
{
    if (messageModel.bodyType == EMMessageBodyTypeText)
    {
        NSString *CellIdentifier = [MK_BaseMessageTableViewCell cellIdentifierWithModel:messageModel];
        MK_BaseMessageTableViewCell *recallCell = (MK_BaseMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (recallCell == nil) {
            recallCell = [[MK_BaseMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier model:messageModel];
            recallCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        recallCell.model = messageModel;

        [[MK_BaseMessageTableViewCell appearance] setMessageNameFont:[UIFont systemFontOfSize:15]];
        [[MK_BaseMessageTableViewCell appearance] setMessageTextColor:[UIColor blackColor]];
        return recallCell;

    }
    return nil;
}
- (CGFloat)messageViewController:(EaseMessageViewController *)viewController
           heightForMessageModel:(id<IMessageModel>)messageModel
                   withCellWidth:(CGFloat)cellWidth
{
    if (messageModel.bodyType == EMMessageBodyTypeText) {
        return [MK_BaseMessageTableViewCell cellHeightWithModel:messageModel];
    }
    return 0.f;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
