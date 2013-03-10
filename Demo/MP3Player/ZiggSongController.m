//
//  ZiggSongController.m
//  MP3Player
//
//  Created by ziggear on 2/24/13.
//  Copyright (c) 2013 ziggear. All rights reserved.
//

#import "ZiggSongController.h"
#import "ZiggLyrics.h"

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
@synthesize ZSC_dirName;
@synthesize ZSC_lyricsData;
@synthesize ZSC_lyricsLines;
@synthesize ZSC_currentLyricsLine;

struct Line {
    NSString *time;
    NSString *lyrics;
}oneLine;

#pragma mark zsc_class_definition -

//从Bundle目录初始化文件
- (id) initInBundlePathWithSongName:(NSString *)name andType:(NSString *)type{
    if (self = ([super init])) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *bdlName = [infoDictionary objectForKey:@"CFBundleDisplayName"];                                              //获取bundle name
        self.ZSC_dirName = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.app/",bdlName]]; //保存bundle路径
        
        self.ZSC_filePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:name ofType:type]];
        self.ZSC_audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:ZSC_filePath error:nil];
        self.ZSC_fileName = name;
        self.ZSC_fileType = type;
        
        self.ZSC_lyricsData = [[NSMutableArray alloc] initWithCapacity:1];
    }
    [self loadMetaData];
    [self preparePlayer];
    return self;
}

//从Document目录初始化文件
- (id) initInDocumentPathWithSongName:(NSString *)name andType:(NSString *)type{
    if (self = ([super init])) {
        
    }
    [self loadMetaData];
    [self preparePlayer];
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
    ZSC_isPlaying = NO;
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

//加载歌词文件
- (void) lyrics_LoadLyricsWithName {
    NSFileManager *fm;
    
    fm = [NSFileManager defaultManager];
    NSString *filePath= [ZSC_dirName stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.lrc",ZSC_fileName]];
    NSLog(@"%@",filePath);
    
    if([fm fileExistsAtPath:filePath]){
        NSLog(@"Lyrics exist");
        
        NSError *error;
        NSString *textFileContents = [NSString stringWithContentsOfFile:filePath
                                      encoding:NSUTF8StringEncoding
                                      error: &error];
        // If there are no results, something went wrong
        if (textFileContents == nil) {
            // an error occurred
            NSLog(@"Error reading text file. %@", [error localizedFailureReason]);
        }
        NSArray *lines = [textFileContents componentsSeparatedByString:@"\n"];
        NSLog(@"Number of lines in the lyrics:%d", [lines count] );
        
        [self setZSC_lyricsLines:[lines count]];
        [self setZSC_currentLyricsLine:0];
        
        //转存歌词数据到ZSC_lyricsData
        for (NSString *singleLine in lines){
            //arr = [self regexArrayFromString:[lines objectAtIndex:3] pattern:@"(.)+(\\d{2})+:+(\\d{2})+.+(\\d{2})+(.)"];
            NSString *arr = nil;
            arr = [self regexStringFromString:singleLine pattern:@"(\\d{2})+:+(\\d{2})+.+(\\d{2})"];
            NSMutableString *str = [NSMutableString stringWithFormat:@"%@",singleLine];
            NSString *x = [str stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"[%@]",arr] withString:@""] ;
            ZiggLyrics *tempLyrics = [self divideString:x andTime:arr];
            [ZSC_lyricsData addObject:tempLyrics];
        }
    
    /*
        for (ZiggLyrics *zigg in ZSC_lyricsData) {
            NSLog(@"%@",zigg.lyrics);
        }
    */
    
    } else {
        NSLog(@"Lyrics not exist");
    }
}

//单行歌词文件的处理
- (ZiggLyrics *) divideString:(NSString *)str andTime:(NSString *)time{
    ZiggLyrics *ln = [[ZiggLyrics alloc] init];
    [ln setLyrics:str];
    
    NSString *minute = [time substringWithRange:NSMakeRange(0, 2)];
    NSString *second = [time substringWithRange:NSMakeRange(3, 2)];
    NSString *msecond = [time substringWithRange:NSMakeRange(6, 2)];
    
    int t_minute = [minute intValue];
    int t_second = [second intValue];
    int t_msecond = [msecond intValue];
    
    float t_time = t_minute * 60 + t_second + t_msecond / 100;
    
    [ln setTime:t_time];
    //NSLog(@"%f : %@",ln.time,ln.lyrics);
    return ln;
}

//辅助：正则表达式分析一个字符串，结果存为array
- (NSMutableArray *) regexArrayFromString:(NSString *)regexString pattern:(NSString *)regexPattern {
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSMutableString *sch = [NSMutableString stringWithFormat:@"%@",regexString];
    NSError *err;
    //NSString *pattern = @"(.)+(\\d{2})+:+(\\d{2})+.+(\\d{2})+(.)";
    NSString *pattern = regexPattern;
    
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:&err];
    
    NSArray *matches =     [reg matchesInString:sch options:NSMatchingCompleted range:NSMakeRange(0, [sch length])];
    
    for (NSTextCheckingResult *match in matches) {
        
        NSRange range = [match range];
        //NSLog(@"%d,%d,%@",range.location,range.length,[sch substringWithRange:range]);
        
        [result addObject:[sch substringWithRange:range]];
        
        //capture groups
        for (int i = 0; i< [match numberOfRanges]; i++) {
            NSRange range1 = [match rangeAtIndex:i];
            //NSLog(@"%d :%@",i,[sch substringWithRange:range1]);
            [result addObject:[sch substringWithRange:range1]];
        }
        
    }

    NSLog(@"%@",result);
    return result;
}

//辅助：正则表达式分析一个字符串，唯一结果存为NSString
- (NSString *) regexStringFromString:(NSString *)regexString pattern:(NSString *)regexPattern {
    NSString *result = nil;
    
    NSMutableString *sch = [NSMutableString stringWithFormat:@"%@",regexString];
    NSError *err;
    //NSString *pattern = @"(.)+(\\d{2})+:+(\\d{2})+.+(\\d{2})+(.)";
    NSString *pattern = regexPattern;
    
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:&err];
    
    NSArray *matches =     [reg matchesInString:sch options:NSMatchingCompleted range:NSMakeRange(0, [sch length])];
    
    for (NSTextCheckingResult *match in matches) {
        
        NSRange range = [match range];
        //NSLog(@"%d,%d,%@",range.location,range.length,[sch substringWithRange:range]);
        
        result = [NSString stringWithFormat:@"%@",[sch substringWithRange:range]];
        
        //capture groups
        /*
        for (int i = 0; i< [match numberOfRanges]; i++) {
            NSRange range1 = [match rangeAtIndex:i];
            //NSLog(@"%d :%@",i,[sch substringWithRange:range1]);
            [result addObject:[sch substringWithRange:range1]];
        }
         */
        
    }
    
    //NSLog(@"%@",result);
    return result;
}


- (NSString *) loadALineIn:(float) second {
    
    //ZiggLyrics *temp = [ZSC_lyricsData objectAtIndex:ZSC_currentLyricsLine];
    for (ZiggLyrics *temp in ZSC_lyricsData) {
        if (temp.time == (int)second) {
            return temp.lyrics;
        }
    }
    
    return nil;
}

@end
