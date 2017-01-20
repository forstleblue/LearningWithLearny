//
//  SaveVoiceViewController.m
//  LearningWithLenny
//
//  Created by Lion User on 16/09/2013.
//  Copyright (c) 2013 JinHong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SaveVoiceViewController.h"
#import "NameConstant.h"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@implementation SaveVoiceViewController

@synthesize backView;
@synthesize titleLabel;
@synthesize startRecordButton;
@synthesize saveButton, cancelButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    backView.layer.cornerRadius = 10.0;
    
    saveButton.layer.cornerRadius = 5.0;
    cancelButton.layer.cornerRadius = 5.0;
    saveButton.alpha = 0.5;
    [self.saveButton setEnabled:NO];
    
    touchRecorder = NO;
    bIsRecording = NO;
    sharedInstance = [AddOwnData sharedAddData];
    musicPath = nil;
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    recordId = [defaults integerForKey:RECORD_NUMBER];

    if(sharedInstance.saveVoiceId == 0)
        musicPath = @"First";
    else if(sharedInstance.saveVoiceId == 1)
        musicPath = @"Second";
    else if(sharedInstance.saveVoiceId == 2)
        musicPath = @"Third";
    else if (sharedInstance.saveVoiceId == 3)
        musicPath = @"Fourth";
    else if (sharedInstance.saveVoiceId == 4)
        musicPath = @"Title";
    
//    [self.saveButton setEnabled: NO];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button actions
- (IBAction)onBack:(id)sender
{
    [self.view removeFromSuperview];
}

- (IBAction) startRecording
{
    if (!bIsRecording) {
        bIsRecording = YES;
        touchRecorder = YES;
        saveButton.alpha = 0.5;
        cancelButton.alpha = 0.5;
        [self.cancelButton setEnabled:NO];
        [self.saveButton setEnabled:NO];

        [startRecordButton setImage:[UIImage imageNamed:@"record_on.png"] forState:UIControlStateNormal];
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError *err = nil;
        [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
        if(err){
            NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
            return;
        }
        [audioSession setActive:YES error:&err];
        err = nil;
        if(err){
            NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
            return;
        }
        
        recordSetting = [[NSMutableDictionary alloc] init];
        
        // We can use kAudioFormatAppleIMA4 (4:1 compression) or kAudioFormatLinearPCM for nocompression
        [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
        
        // We can use 44100, 32000, 24000, 16000 or 12000 depending on sound quality
        [recordSetting setValue:[NSNumber numberWithFloat:16000.0] forKey:AVSampleRateKey];
        
        // We can use 2(if using additional h/w) or 1 (iPhone only has one microphone)
        [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
        
        // These settings are used if we are using kAudioFormatLinearPCM format
        //[recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        //[recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        //[recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
        
        
        
        // Create a new dated file
        //NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
        //	NSString *caldate = [now description];
        //	recorderFilePath = [[NSString stringWithFormat:@"%@/%@.caf", DOCUMENTS_FOLDER, caldate] retain];
        NSLog(@"%@",musicPath);
        recorderFilePath = [[NSString stringWithFormat:@"%@/%@%d.caf", DOCUMENTS_FOLDER, musicPath,recordId
                             ] retain];
        NSLog(@"recorderFilePath: %@",recorderFilePath);
        
        NSURL *url = [NSURL fileURLWithPath:recorderFilePath];
        
        err = nil;
        
        NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
        if(audioData)
        {
            NSFileManager *fm = [NSFileManager defaultManager];
            [fm removeItemAtPath:[url path] error:&err];
        }
        
        err = nil;
        recorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
        if(!recorder){
            NSLog(@"recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Warning"
                                       message: [err localizedDescription]
                                      delegate: nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
        
        //prepare to record
        [recorder setDelegate:self];
        [recorder prepareToRecord];
        recorder.meteringEnabled = YES;
        
        BOOL audioHWAvailable = audioSession.inputIsAvailable;
        if (! audioHWAvailable) {
            UIAlertView *cantRecordAlert =
            [[UIAlertView alloc] initWithTitle: @"Warning"
                                       message: @"Microphone isn't available"
                                      delegate: nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
            [cantRecordAlert show];
            [cantRecordAlert release];
            return;
        }
        
        // start recording
        [recorder recordForDuration:(NSTimeInterval) 2];
        //	timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
    }
    else {
        bIsRecording = NO;
        [self.saveButton setEnabled:YES];
        [self.cancelButton setEnabled:YES];
        [recorder stop];
        saveButton.alpha = 1.0;
        cancelButton.alpha = 1.0;
        [startRecordButton setImage:[UIImage imageNamed:@"record_off.png"] forState:UIControlStateNormal];
    }
}

- (IBAction) saveAudio:(id)sender;
{
    if(touchRecorder == YES)
    {
        if (sharedInstance.saveVoiceId == 0) 
            sharedInstance.firstVoice = YES;
        else if (sharedInstance.saveVoiceId == 1)
            sharedInstance.secondVoice = YES;
        else if (sharedInstance.saveVoiceId ==2)
            sharedInstance.thirdVoice = YES;
        else if (sharedInstance.saveVoiceId == 3)
            sharedInstance.fourthVoice = YES;
        else if (sharedInstance.saveVoiceId == 4)
            sharedInstance.fifthVoice = YES;
        
        [self.view removeFromSuperview];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please record your voice." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)dealloc {
    
    [backView release];
    [saveButton release];
    [cancelButton release];
    [startRecordButton release];
    [titleLabel release];
    
    [super dealloc];
}

- (void)viewDidUnload {
    
    [self setCancelButton:nil];
    [super viewDidUnload];
}

@end
