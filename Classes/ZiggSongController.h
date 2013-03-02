//
//  ZiggSongController.h
//  MP3Player
//
//  Created by ziggear on 2/24/13.
//  Copyright (c) 2013 ziggear. All rights reserved.
//  ziggear@gmail.com

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface ZiggSongController : NSObject <AVAudioPlayerDelegate>{
    //System Class
    AVAudioPlayer* ZSC_audioPlayer;
    AVURLAsset*    ZSC_fileAsset;
    
    //Meta Data
    NSString*      ZSC_fileName;
    NSString*      ZSC_fileType;
    NSURL*         ZSC_filePath;
    NSString*      ZSC_songName;
    NSString*      ZSC_artistName;
    UIImage*       ZSC_albumCover;
    NSData*        ZSC_lyricsFile;
    
    //Others
    BOOL           ZSC_isSongNameFound;
    BOOL           ZSC_isArtistNameFound;
    BOOL           ZSC_isCoverFound;
    BOOL           ZSC_isLyricsFound;
    BOOL           ZSC_isPlaying;
}

@property (nonatomic, retain) AVAudioPlayer* ZSC_audioPlayer;
@property (nonatomic, retain) AVURLAsset*    ZSC_fileAsset;
@property (nonatomic, retain) NSString*      ZSC_fileName;
@property (nonatomic, retain) NSString*      ZSC_fileType;
@property (nonatomic, retain) NSURL*         ZSC_filePath;
@property (nonatomic, retain) NSString*      ZSC_songName;
@property (nonatomic, retain) NSString*      ZSC_artistName;
@property (nonatomic, retain) UIImage*       ZSC_albumCover;
@end