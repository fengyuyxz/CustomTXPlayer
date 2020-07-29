//
//  YxzPlayerModel.h
//  suspensionPay
//
//  Created by 颜学宙 on 2020/7/29.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SuperPlayer/SuperPlayerUrl.h>
NS_ASSUME_NONNULL_BEGIN

@interface YxzPlayerModel : NSObject
/**
 * 直接使用URL播放
 *
 * 支持 RTMP、FLV、MP4、HLS 封装格式
 * 使用腾讯云直播时移功能则需要填写appId
 */
@property (nonatomic, strong) NSString *videoURL;
/**
 * 多码率视频 URL
 *
 * 用于拥有多个播放地址的多清晰度视频播放
 */
@property (nonatomic, strong) NSArray<SuperPlayerUrl *> *multiVideoURLs;

/// 指定多码率情况下，默认播放的连接Index
@property (nonatomic, assign) NSUInteger defaultPlayIndex;

@property(nonatomic,copy)NSString *playingDefinition;//当前播放的url 清晰度
- (NSString *)playingDefinitionUrl;
@end

NS_ASSUME_NONNULL_END
