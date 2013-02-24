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

#pragma mark zsc_class_definition -

- (id) initInBundlePathWithSongName:(NSString *)name andType:(NSString *)type{
    if (self = ([super init])) {
        self.ZSC_filePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:name ofType:type]];
        self.ZSC_audioPlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:ZSC_filePath] error:nil];
        self.ZSC_fileName = name;
        self.ZSC_fileType = type;
    }
    [self loadMetaData];
    [self preparePlayer];
    return self;
}

- (id) initInDocumentPathWithSongName:(NSString *)name andType:(NSString *)type{
    if (self = ([super init])) {
        
    }
    return self;
}

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

- (void) preparePlayer {
    ZSC_audioPlayer.enableRate = YES;
    ZSC_audioPlayer.meteringEnabled = YES;
    ZSC_audioPlayer.delegate = self;
    ZSC_audioPlayer.volume = 1.0;
    [ZSC_audioPlayer prepareToPlay];
    
    ZSC_isPlaying = NO;
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



@end
