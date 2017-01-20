//
//  CustomAudioPlayer.m
//  LearningWithLenny
//
//  Created by snow on 10/9/13.
//  Copyright (c) 2013 JinHong. All rights reserved.
//


#import "CustomAudioPlayer.h"

@implementation CustomAudioPlayer

- (id)initWithURL:(NSURL *)url
{
    CustomAudioPlayer *audioPlayer =  (CustomAudioPlayer *)[[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    audioPlayer.volume = 0.8;
    
    return audioPlayer;
}

@end
