//
//  ZiggLyrics.h
//  MP3Player
//
//  Created by ziggear on 3/9/13.
//  Copyright (c) 2013 ziggear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZiggLyrics : NSObject {
    NSString *time;
    NSString *lyrics;
}

@property (nonatomic, retain) NSString *time;
@property (nonatomic, retain) NSString *lyrics;

@end
