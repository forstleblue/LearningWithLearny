//
//  LWLSAppDelegate.h
//  LearningWithLenny
//
//  Created by snow on 7/25/13.
//  Copyright (c) 2013 JinHong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LWLSViewController;
#import "ReadData.h"
#import <AVFoundation/AVAudioPlayer.h>
#import <Foundation/Foundation.h>
#import "CustomAudioPlayer.h"

@interface LWLSAppDelegate : UIResponder <UIApplicationDelegate>
{
    UIWindow *window;
    CustomAudioPlayer *_musicPlayer;
    CustomAudioPlayer *effectPlayer;
    CustomAudioPlayer *sequencePlayer[3];
    CustomAudioPlayer *successSound[2];
    CustomAudioPlayer *unsuccessSound[2];
    CustomAudioPlayer* sequenceSound[4];
    NSMutableArray* globalTableSequence;
    NSMutableArray* musicName;
    NSMutableArray* sequenceNumber;

}
@property (assign) int totalCount;
@property (nonatomic, retain) NSMutableArray* sequenceNumber;
@property (assign) BOOL musicOn;
@property (assign) BOOL playSequence;
@property (assign) BOOL playSuccess;
@property (assign) BOOL playUnsuccess;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) ReadData * pointer;
@property (nonatomic, retain) NSMutableArray* globalTableSequence;
@property (nonatomic, retain) NSMutableArray* sequenceTitle;
@property (nonatomic, retain) NSMutableArray* tableArray;

-(void)stopBackgroundMusic;
-(void)playBackgroundMusic;
-(void)playUnsuccessSound:(int)index;
-(void)playSuccessSound:(int)index;
-(void)playSequenceWord:(int)index;
-(void)playSequenceSound:(int)index;


@end
