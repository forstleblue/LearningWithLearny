//
//  CustomAudioPlayer.h
//  LearningWithLenny
//
//  Created by snow on 10/9/13.
//  Copyright (c) 2013 JinHong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface CustomAudioPlayer : AVAudioPlayer

- (id)initWithURL:(NSURL *)url;

@end
