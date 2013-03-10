//
//  ViewController.h
//  MP3Player
//
//  Created by ziggear on 13-2-22.
//  Copyright (c) 2013年 ziggear. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "ZiggSongController.h"


@interface ViewController : UIViewController<AVAudioPlayerDelegate>{
    ZiggSongController *zigg;
    AVAudioPlayer* player;
    NSTimer* timer;
    UISlider *pro;
    UISlider* vol;
    UIButton* but;
    
    UIImageView *cover;
    UILabel *gtitle;
    UILabel *artist;
    UILabel *duration;
    UILabel *curr;
    
    UILabel *curr_second;
    UILabel *lyrics_line;
}

@property(nonatomic,retain)IBOutlet UISlider* pro;
@property(nonatomic,retain)IBOutlet UISlider* vol;
@property(nonatomic,retain)IBOutlet UIButton* but;
@property(nonatomic,retain)IBOutlet UIImageView *cover;
@property(nonatomic,retain)IBOutlet UILabel *gtitle;
@property(nonatomic,retain)IBOutlet UILabel *artist;
@property(nonatomic,retain)IBOutlet UILabel *duration;
@property(nonatomic,retain)IBOutlet UILabel *curr;
@property(nonatomic,retain)IBOutlet UILabel *curr_second;
@property(nonatomic,retain)IBOutlet UILabel *lyrics_line;

@end
