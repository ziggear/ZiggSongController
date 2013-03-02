//
//  ZiggSongController.m
//  MP3Player
//
//  Created by ziggear on 2/24/13.
//  Copyright (c) 2013 ziggear. All rights reserved.
//

#import "ZiggSongController.h"

@implementation ZiggSongController

@synthesize ZSC_audioPlayer;
@synthesize ZSC_fileAsset;
@synthesize ZSC_fileName;
@synthesize ZSC_fileType;
@synthesize ZSC_filePath;
@synthesize ZSC_songName;
@synthesize ZSC_artistName;
@synthesize ZSC_albumCover;
@synthesize ZSC_duration;

#pragma mark zsc_class_definition -

//从Bundle目录初始化文件
- (id) initInBundlePathWithSongName:(NSString *)name andType:(NSString *)type{
    if (self = ([super init])) {
        self.ZSC_filePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:name ofType:type]];
        self.ZSC_audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:ZSC_filePath error:nil];
        self.ZSC_fileName = name;
        self.ZSC_fileType = type;
    }
    [self loadMetaData];
    [self preparePlayer];
    return self;
}

//从Document目录初始化文件
- (id) initInDocumentPathWithSongName:(NSString *)name andType:(NSString *)type{
    if (self = ([super init])) {
        
    }
    return self;
}

//加载MP3的元数据（歌名、艺术家、封面）
- (void) loadMetaData {
    ZSC_fileAsset = [AVURLAsset URLAssetWithURL:ZSC_filePath options:nil];
    
    for (NSString *format in [ZSC_fileAsset availableMetadataFormats]) {
        NSLog(@"format type = %@",format);
        for (AVMetadataItem *metadataItem in [ZSC_fileAsset metadataForFormat:format]) {
            NSLog(@"commonKey = %@",metadataItem.commonKey);
            
            if ([metadataItem.commonKey isEqualToString:@"title"]) {
                self.ZSC_songName = (NSString*)metadataItem.value;
            }
            
            if ([metadataItem.commonKey isEqualToString:@"artist"]) {
                self.ZSC_artistName = (NSString*)metadataItem.value;
            }
            
            if ([metadataItem.commonKey isEqualToString:@"artwork"]) {
                NSData *data = [(NSDictionary*)metadataItem.value objectForKey:@"data"];
                //NSString *mime = [(NSDictionary*)metadataItem.value objectForKey:@"MIME"];
                self.ZSC_albumCover = [UIImage imageWithData:data];
            }
        }
    }

}

//初始化播放器
- (void) preparePlayer {
    ZSC_audioPlayer.enableRate = YES;
    ZSC_audioPlayer.meteringEnabled = YES;
    ZSC_audioPlayer.delegate = self;
    ZSC_audioPlayer.volume = 1.0;
    [ZSC_audioPlayer prepareToPlay];          //准备播放器参数
    
    ZSC_duration = ZSC_audioPlayer.duration;  // 获取播放时长
    ZSC_interval = 10.0f;                     // 设置快进、快退时长
    ZSC_isPlaying = NO;                       // 播放标志
    
    [self lyrics_LoadLyricsWithName];
}


#pragma mark zsc_player_control -

- (void) player_Play {
    [ZSC_audioPlayer play];
    ZSC_isPlaying = YES;
}

- (void) player_Pause {
    [ZSC_audioPlayer pause];
    ZSC_isPlaying = NO;
}

- (void) player_PlayOrPause {
    if (ZSC_isPlaying == NO) {
        [self player_Play];
    } else {
        [self player_Pause];
    }
}

- (void) player_Stop {
    [ZSC_audioPlayer stop];
}

//播放控制：快进
- (void) player_Foward {
    [ZSC_audioPlayer pause];
    float time = ZSC_audioPlayer.currentTime + ZSC_interval;
    
    if (time >= ZSC_interval) {
        time = ZSC_interval;
    }
    
    [ZSC_audioPlayer setCurrentTime:time];
    [self player_PlayOrPause];
}

//播放控制：快退
- (void) player_Backward {
    [ZSC_audioPlayer pause];
    float time = ZSC_audioPlayer.currentTime - ZSC_interval;
    
    if (time <= 0) {
        time = 0;
    }
    
    [ZSC_audioPlayer setCurrentTime:time];
    [self player_PlayOrPause];
}

//播放控制：按进度播放
- (void) player_PlayAtPercent:(float)percent{
    [self player_PlayOrPause];
    float time = ZSC_duration * percent;
    
    if (time <= 0) {
        time = 0;
    } else {
        if (time >= ZSC_duration) {
            time = ZSC_duration;
        }
    }
    
    [ZSC_audioPlayer setCurrentTime:time];
    [self player_PlayOrPause];
}

#pragma mark zsc_player_delegate -

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player successfully:(BOOL)flag{
    //播放结束时执行的动作
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer*)player error:(NSError *)error{
    //解码错误执行的动作
}
- (void)audioPlayerBeginInteruption:(AVAudioPlayer*)player{
    //处理中断的代码
}
- (void)audioPlayerEndInteruption:(AVAudioPlayer*)player{
    //处理中断结束的代码
}


#pragma mark zsc_lyrics -


- (void) lyrics_LoadLyricsWithName {
    NSFileManager *fm;
    
    fm = [NSFileManager defaultManager];
    NSString *documentsDirectory= NSHomeDirectory();
    NSString *filePath= [documentsDirectory
                         stringByAppendingPathComponent:[NSString stringWithFormat:@"MP3Player.app/%@.lrc",ZSC_fileName]];
    NSLog(@"%@",filePath);
    
    if([fm fileExistsAtPath:filePath]){
        NSLog(@"Lyrics exist");
        
        
        
    } else {
        NSLog(@"Lyrics not exist");
    }
}


@end
