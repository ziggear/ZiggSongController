//
//  ViewController.m
//  MP3Player
//
//  Created by ziggear on 13-2-22.
//  Copyright (c) 2013年 ziggear. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize but;
@synthesize vol;
@synthesize cover;
@synthesize gtitle;
@synthesize artist;
@synthesize duration;
@synthesize curr;
@synthesize pro;

//播放、暂停
- (IBAction)buttonPressed:(id)sender {
    [zigg player_PlayOrPause];
}

//音量调节
- (IBAction)volumeChanged:(id)sender{
    [zigg.ZSC_audioPlayer setVolume:vol.value];
}

//进度控制
- (IBAction)valueChanged:(id)sender{
    float val = pro.value;
    [zigg player_PlayAtPercent:val];
    
}


- (void)handleTimer:(id)sender{
    float currentTime = zigg.ZSC_audioPlayer.currentTime;
    curr.text = [NSString stringWithFormat: @"%d:%d",
                     (int) currentTime /60,
                     (int) currentTime %60];
    pro.value =  currentTime / zigg.ZSC_duration;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    zigg = [[ZiggSongController alloc] initInBundlePathWithSongName:@"onion" andType:@"mp3"];
    [zigg player_PlayOrPause];
    
    
    duration.text = [NSString stringWithFormat: @"%d:%d",
                     (int) zigg.ZSC_duration /60,
                     (int) zigg.ZSC_duration %60];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0                                                     target: self
        selector: @selector(handleTimer:)
        userInfo: nil
        repeats: YES];
    
    gtitle.text = zigg.ZSC_songName;
    artist.text = zigg.ZSC_artistName;
    [cover setImage:zigg.ZSC_albumCover];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//播放，暂停-------------------------------------------------------------------------------------------------------------------------

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
}


@end
