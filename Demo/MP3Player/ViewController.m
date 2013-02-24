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
@synthesize title;
@synthesize artist;
@synthesize duration;
@synthesize curr;
@synthesize pro;

- (IBAction)buttonPressed:(id)sender {
    if (but.tag == 100)
    {
        [but setTitle:@"播放" forState:UIControlStateNormal];
        [player pause];
        but.tag = 101;
    }
    else
    {
        [but setTitle:@"暂停" forState:UIControlStateNormal];
        [player play];
        [timer fire];
        but.tag = 100;
    }
}

- (IBAction)volumeChanged:(id)sender{
    [player setVolume:vol.value / 100];
}

- (IBAction)valueChanged:(id)sender{
    int seconds = (int)player.duration;
    float persents = pro.value;
    
    //double process_seconds = seconds * persents;
    NSTimeInterval current_seconds = (float) (seconds * persents);
    
    NSLog(@"Persents: %f ; Current: %f ", persents,current_seconds);
    [player pause];
    [player setCurrentTime:current_seconds];
    [player play];
    
}


- (void)handleTimer:(id)sender{
    curr.text = [NSString stringWithFormat: @"%d:%d",
                     (int) player.currentTime /60,
                     (int) player.currentTime%60];
    pro.value = player.currentTime / player.duration;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp3"]] error:nil];
    
    [player prepareToPlay];
    
    player.enableRate = YES;
    
    player.meteringEnabled = YES;
    
    player.delegate = self;
    
    player.volume = 1.0;
    
    duration.text = [NSString stringWithFormat: @"%d:%d",
                          (int) player.duration/60,
                          (int) player.duration%60];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0                                                     target: self
        selector: @selector(handleTimer:)
        userInfo: nil
        repeats: YES];
    
    [but setTag:101];
    
    //读取MP3文件的metadata
    NSURL *fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp3"]];
    AVURLAsset *mp3Asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
    for (NSString *format in [mp3Asset availableMetadataFormats]) {
        NSLog(@"format type = %@",format);
        for (AVMetadataItem *metadataItem in [mp3Asset metadataForFormat:format]) {
            NSLog(@"commonKey = %@",metadataItem.commonKey);
            
            if ([metadataItem.commonKey isEqualToString:@"title"]) {
                NSString *titleStr = (NSString*)metadataItem.value;
                [title setText:titleStr];
            }
            
            if ([metadataItem.commonKey isEqualToString:@"artist"]) {
                NSString *artistStr = (NSString*)metadataItem.value;
                [artist setText:artistStr];
            }
            
            if ([metadataItem.commonKey isEqualToString:@"artwork"]) {
                NSData *data = [(NSDictionary*)metadataItem.value objectForKey:@"data"];
                NSString *mime = [(NSDictionary*)metadataItem.value objectForKey:@"MIME"];
                UIImage *coverImg = [UIImage imageWithData:data];
                [cover setImage:coverImg];
            }
        }
    }
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
