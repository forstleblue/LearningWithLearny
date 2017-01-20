//
//  SequenceViewController.h
//  LearningWithLenny
//
//  Created by snow on 7/26/13.
//  Copyright (c) 2013 JinHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NameConstant.h"
#import "LWLSAppDelegate.h"
#import "ReadData.h"
#import "DataManager.h"
#import "CustomAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
@interface SequenceViewController : UIViewController<UIAlertViewDelegate>
{
    LWLSAppDelegate* appDelegate;
    NSMutableArray *sequenceTitleArray;
    
    NSMutableArray *sourceLabelArray;//item data
    NSMutableArray *sourceImageViewArray;
    
    
    NSMutableArray* stageRandArray;
    NSMutableArray *sourceTitleArray;
    NSMutableArray *imagePathArray;
    
    NSMutableArray *targetImageViewArray;
    
    NSMutableArray* itemSoundPathArray;
    
    NSMutableArray* anotherTableData;
    NSArray *random3Array;
    
    NSMutableArray* sourceMusicArray;
    NSMutableArray* soundPlayer;
    NSMutableArray* dbSoundName;
    NSArray* randArray;
    CGPoint centerPoint[4];
    NSMutableArray* slideTrueImageArray;
    NSMutableArray* slideFalseImageArray;

    BOOL enableTouch;
    
    CGPoint saveBeginPoint;
    CGPoint saveEndPoint;
    NSArray *alphabetArray;
    NSString* sequenceTitleSound;
    
    
    CGPoint centerSourceImage[4];
    NSInteger selectedImageViewIdx;
    int numOfPictures;
    
    BOOL isPlist;
    int totalCount;
    int count;
    NSInteger sequenceNumber;
    CGPoint selectedImageViewOrigPos;
        int trueSlideIndex;
    BOOL cellState[20];
    BOOL successSound;
    BOOL unsuccessSound;
    BOOL music;
    BOOL teach;
    BOOL written;
    BOOL spoken;
    BOOL threePic;
    BOOL fourPic;
    BOOL firSecThird;
    int falseSlideTag;
    BOOL noSlideArea;
    SystemSoundID soundID;
    
    
    
    BOOL currStagePlist;
    NSMutableArray* selectItems;
    BOOL isSelectData;
    int nCount;
    
    BOOL alreadyTeachTap;
    BOOL secondeTeach;
    NSInteger scoreCount;
    int tableCount;
    int tempNumber;
    
    CGPoint imageCenterPoint[4];
    CGRect rect[4];
    float scaleWidth;
    float scaleHeight;
    float widescreenScale;
    CustomAudioPlayer* _soundPlayer;
    CustomAudioPlayer* recordPlayer;

    BOOL teachTouch;
    BOOL searchData;
    int failTouch[4];
    BOOL stageSuccess[20];
    BOOL touchDisable;
    BOOL nextScreen;
    
    BOOL resultMusicPlist[20];
    
    
    int imageNumber;
    UIImage* backgroundImage;
    
    BOOL musicOutPlay;
}

@property (retain, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (retain, nonatomic) IBOutlet UIButton *btnPlay;
@property (retain, nonatomic) IBOutlet UIButton *teachMode;
@property (retain, nonatomic) IBOutlet UIButton *phraseButton;
@property (retain, nonatomic) IBOutlet UIButton *homeButton;
@property (nonatomic, retain) IBOutlet UILabel *sequenceTitleLabel;

@property (nonatomic, retain) ReadData* pointer;

@property (nonatomic, retain) NSMutableArray *sequenceTitleArray;
@property (nonatomic, retain) NSMutableArray *sourceLabelArray;
@property (nonatomic, retain) NSMutableArray *targetImageViewArray;
@property (nonatomic, retain) NSMutableArray *sourceImageViewArray;
@property (nonatomic, retain) NSMutableArray* dbSoundName;
@property (nonatomic, retain) NSMutableArray *sourceTitleArray;
@property (nonatomic, retain) NSMutableArray *imagePathArray;
@property (nonatomic, retain) NSMutableArray *sourceMusicArray;
@property (nonatomic, retain) NSMutableArray* slideTrueImageArray;
@property (nonatomic, retain) NSMutableArray* slideFalseImageArray;

- (IBAction)onTeach:(id)sender;
- (IBAction)onPlay:(id)sender;
- (IBAction)clickHomeButton:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (void) writeData;
- (void)getSettingData;
- (void)stopCurrentPlayer;
- (void)playEffectSound:(NSString*)effectSound;
- (void)handleTapGesture ;
- (UIImage *)loadImage:(NSString *)name;
- (void) onTrueTick:(NSTimer*) timer;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void) doCoolAnimation:(UIImageView*)imageView;
- (void)setSlideFalse;
- (void)setSlideTrue;
- (void)resetSlideTrue;
- (void)resetSlideFalse;
- (void)playTouchVoice:(NSNumber*) idx;
- (void)moveImage:(UIImageView*)image duration:(NSTimeInterval)duration curve:(int)curve x:(CGFloat)x y:(CGFloat)y;
- (void)nextPlay;
- (void)onFalseTick:(NSTimer* )timer;
- (void)nextScreen;

- (void)continueTouchMode;
- (void)PlayOwnAddMusic:(NSString*)musicPath;
- (void)reScaleImageView:(UIImageView*)imageView;
- (void)resultImageSerial:(NSNumber*)index;
- (void)nextStage;
- (void)saveMyView:(UIView*)theView;
- (NSString*)imageFilePath:(int)index;
- (void)viewDidDisappear:(BOOL)animated;
-(void)viewWillDisappear:(BOOL)animate;
@end
