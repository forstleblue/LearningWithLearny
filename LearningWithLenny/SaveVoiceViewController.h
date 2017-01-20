//
//  SaveVoiceViewController.h
//  LearningWithLenny
//
//  Created by Lion User on 16/09/2013.
//  Copyright (c) 2013 JinHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioServices.h>
#import "AddOwnData.h"
@interface SaveVoiceViewController : UIViewController<AVAudioRecorderDelegate, UIAlertViewDelegate>
{	
	NSMutableDictionary *recordSetting;
	NSMutableDictionary *editedObject;
	NSString *recorderFilePath;
	AVAudioRecorder *recorder;
	
	SystemSoundID soundID;
    BOOL touchRecorder;
    BOOL bIsRecording;
    AddOwnData* sharedInstance;
    NSString* musicPath;
    int recordId;

}

@property (retain, nonatomic) IBOutlet UIView  *backView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIButton *startRecordButton;
@property (retain, nonatomic) IBOutlet UIButton *saveButton;
@property (retain, nonatomic) IBOutlet UIButton *cancelButton;

- (IBAction) startRecording;
- (IBAction) saveAudio:(id)sender;
- (IBAction) onBack:(id)sender;
@end
