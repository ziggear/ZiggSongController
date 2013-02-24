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


@interface ViewController : UIViewController<AVAudioPlayerDelegate>{
    AVAudioPlayer* player;
    NSTimer* timer;
    UISlider *pro;
    UISlider* vol;
    UIButton* but;
    
    UIImageView *cover;
    UILabel *title;
    UILabel *artist;
    UILabel *duration;
    UILabel *curr;
}

@property(nonatomic,retain)IBOutlet UISlider* pro;
@property(nonatomic,retain)IBOutlet UISlider* vol;
@property(nonatomic,retain)IBOutlet UIButton* but;
@property(nonatomic,retain)IBOutlet UIImageView *cover;
@property(nonatomic,retain)IBOutlet UILabel *title;
@property(nonatomic,retain)IBOutlet UILabel *artist;
@property(nonatomic,retain)IBOutlet UILabel *duration;
@property(nonatomic,retain)IBOutlet UILabel *curr;
@end
