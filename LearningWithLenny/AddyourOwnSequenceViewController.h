//
//  AddyourOwnSequenceViewController.h
//  LearningWithLenny
//
//  Created by MiniMac on 9/17/13.
//  Copyright (c) 2013 JinHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "LWLSAppDelegate.h"
#import "ReadData.h"
#import "AddOwnData.h"

@interface AddyourOwnSequenceViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate,UITextFieldDelegate,UIScrollViewDelegate,AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    int addPic;
    int takePic;
    int addAudio;
    int addText;
    BOOL selectImage[4];
    int selectStage;
    int stageNumber;
    NSString* imageName[4];
    NSString* imageLabel[4];
    
    NSString* firstImageLabel;
    NSString* seconeImageLabel;
    NSString* thirdImageLabel;
    NSString* fourthImageLabel;
    NSString* sequenceTitle;
    
    NSMutableArray* imageArray;
    LWLSAppDelegate* appDelegate;
    ReadData* pointer;
    BOOL saveDataSuccess;
    BOOL isSameImage;
    
    AddOwnData* sharedInstance;
    BOOL valideData[4];
    BOOL tapTakePic;
}

- (IBAction)onSave:(id)sender;
- (IBAction)takePicture:(id)sender;
- (IBAction)addPicture:(id)sender;
- (IBAction)addAudio:(id)sender;
- (IBAction)addText:(id)sender;
- (IBAction)onBack:(id)sender;
-(UIImage*)ImageResize:(UIImage*)image;

@property (nonatomic, retain) NSString* sequenceTitle;
@property (nonatomic, retain) NSString* firstImageLabel;
@property (nonatomic, retain) NSString* secondImageLabel;
@property (nonatomic, retain) NSString* thirdImageLabel;
@property (nonatomic, retain) NSString* fourthImageLabel;
@property (nonatomic, retain) NSString* imageLabelOne;
@property (nonatomic, retain) NSString* imageLabelTwo;
@property (nonatomic, retain) NSString* imageLabelThree;
@property (nonatomic, retain) NSString* imageLabelFour;
@property (assign) int addText;

@property (retain, nonatomic) IBOutlet UIImageView *imageViewOne;
@property (retain, nonatomic) IBOutlet UIImageView *imageViewTwo;
@property (retain, nonatomic) IBOutlet UIImageView *imageViewThree;
@property (retain, nonatomic) IBOutlet UIImageView *imageViewFour;
@property (retain, nonatomic) IBOutlet UIScrollView *backgroundScrollView;
@property (retain, nonatomic) IBOutlet UIButton *addTextFirst;
@property (retain, nonatomic) IBOutlet UIButton *addTextSecond;
@property (retain, nonatomic) IBOutlet UIButton *addTextThird;
@property (retain, nonatomic) IBOutlet UIButton *addTextFourth;
@property (retain, nonatomic) IBOutlet UIButton *addSequenceTitle;
@property (retain, nonatomic) IBOutlet UIButton *addTakePicFirst;
@property (retain, nonatomic) IBOutlet UIButton *adddTakePicSec;
@property (retain, nonatomic) IBOutlet UIButton *addTakePicThird;
@property (retain, nonatomic) IBOutlet UIButton *addTakePicFourth;
@property (retain, nonatomic) IBOutlet UIButton *AddPicFileOne;
@property (retain, nonatomic) IBOutlet UIButton *addPicFileTwo;
@property (retain, nonatomic) IBOutlet UIButton *addPicFileThree;
@property (retain, nonatomic) IBOutlet UIButton *addPicFileFour;
@property (retain, nonatomic) IBOutlet UIButton *addAudioOne;
@property (retain, nonatomic) IBOutlet UIButton *addAudioTwo;
@property (retain, nonatomic) IBOutlet UIButton *addAudioThree;
@property (retain, nonatomic) IBOutlet UIButton *addAudioFour;
@property (retain, nonatomic) IBOutlet UIButton *addAudioFive;

@end
