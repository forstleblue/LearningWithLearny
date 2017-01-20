//
//  SequenceViewController.m
//  LearningWithLenny
//
//  Created by snow on 7/26/13.
//  Copyright (c) 2013 JinHong. All rights reserved.
//

#import "SequenceViewController.h"
#import "SettingsViewController.h"
#import "ListOfSequencesViewController.h"
#import "NameConstant.h"
#import "LWLSAppDelegate.h"
//136 60
#define ImageViewWidth 70
#define ImageViewHight 70

#define ImageViewXStep  100//155

#define SourceImageViewXOffset 60
#define SourceImageViewYOffset 70
#define TargetImageViewXOffset 60
#define TargetImageViewYOffset 200
#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define ImageTitleWidth 100
#define ImageTitleHight 40
#define ImageTitleXStep  96//150
#define ImageTitleXOffset 50
#define ImageTitleYOffset 145
#define TEACHVOICE      @"Put the pictures in the correct order.mp3"
@interface SequenceViewController ()
@end

@implementation SequenceViewController

@synthesize backgroundImageView,btnPlay,teachMode, phraseButton, homeButton;
@synthesize sequenceTitleArray,pointer;
@synthesize sourceImageViewArray, targetImageViewArray, sourceLabelArray;
@synthesize sequenceTitleLabel;
@synthesize dbSoundName;
@synthesize sourceTitleArray, imagePathArray, sourceMusicArray;
@synthesize slideTrueImageArray, slideFalseImageArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [sequenceTitleArray release];
    [sourceLabelArray release];
    [sourceImageViewArray release];
    [slideTrueImageArray release];
    [slideFalseImageArray release];
    [sourceTitleArray release];
    [targetImageViewArray release];  
    [sourceMusicArray release];
    [soundPlayer release];;
    [dbSoundName release];
    [pointer release];
    
    [phraseButton release];
    [sequenceTitleLabel release];
    [teachMode release];
    [btnPlay release];
    [homeButton release];

    [backgroundImageView release];
    [super dealloc];
}
- (void)viewDidDisappear:(BOOL)animated
{
   
    [appDelegate stopBackgroundMusic];
}
- (void)getSettingData
{
    appDelegate = [UIApplication sharedApplication].delegate;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    successSound = [defaults boolForKey:SuccessSoundKey];
    unsuccessSound = [defaults boolForKey:UnSuccessSoundKey];
    music = [defaults boolForKey:MusicKey];
    written = [defaults boolForKey:WrittenKey];
    threePic = [defaults boolForKey:ThreePicKey];
    fourPic = [defaults boolForKey:FourPicKey];
    spoken = [defaults boolForKey:SpokenKey];
    firSecThird = [defaults boolForKey:FirSecKey];
    teach = [defaults boolForKey:TeachKey];
    [defaults synchronize];
    isSelectData = NO;
    nCount = 0;
    currStagePlist = NO;
    secondeTeach = NO;
    isPlist = NO;
    enableTouch = YES;
    teachTouch = NO;
    sequenceTitleSound = @"";
    alreadyTeachTap = NO;
    touchDisable = NO;
    selectItems = [[NSMutableArray alloc] initWithCapacity:0];
    totalCount = [appDelegate.sequenceTitle count];
    self.btnPlay.hidden = YES;
    for (int i = 0; i < totalCount; i++) {
        cellState[i] = [defaults boolForKey:[NSString stringWithFormat:@"%@%d",CellNumber,i]];
        if(cellState[i] == YES)
        {
            isSelectData = YES;
            [selectItems  addObject:[NSNumber numberWithInt:i]];
        }
    }
    tableCount = [defaults integerForKey:SELECTED_COUNT];
    self.pointer = [[ReadData alloc] init];
    nextScreen = NO;
    soundPlayer = [[NSMutableArray alloc] init];
    self.dbSoundName = [[NSMutableArray alloc] initWithCapacity:0];
    
    numOfPictures = 0;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        scaleWidth = 1;
        scaleHeight = 1;
        
        float winHeight = [[UIScreen mainScreen] bounds].size.height;
        widescreenScale = winHeight / IPHONE_WIDTH;
    }
    else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        scaleWidth = RATE_WIDTH;
        scaleHeight = RATE_HEIGHT;
        widescreenScale = scaleWidth;
    }
    
    for(int i = 0; i < 4; i++)
        failTouch[i] = 0;
    for (int i = 0; i < 20 ; i++) {
        stageSuccess[i] = NO;
        resultMusicPlist[i] = NO;
    }
    [[DataManager sharedInstance] initWithDatabase:DATABASE_FILE_PATH];
    [[DataManager sharedInstance] loadDatabase];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getSettingData];
    
    sequenceNumber = 0;
    scoreCount = 0;
    
    if(isSelectData == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:nil
                              message:@"You must select table item in SettingView"
                              delegate: self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil,
                              nil];
        alert.delegate = self;
        [alert show];
        [alert release];
        return;
    }
    else if(threePic == NO && fourPic == NO)
    {
        UIAlertView* alert = [[UIAlertView alloc]
                              initWithTitle:nil message:@"You should select Three Picture Item" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        alert.delegate= self;
        [alert release];
        return;
    }
    
    if(teach == NO)
    {
        [self.teachMode setHidden:YES];
    }
    
    self.sequenceTitleArray = [[NSMutableArray alloc] initWithCapacity:0];
    alphabetArray = [self.pointer getFirSecThird];
        
    NSUserDefaults* defaults = [ NSUserDefaults standardUserDefaults];

    random3Array = appDelegate.globalTableSequence;
    self.sourceImageViewArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.targetImageViewArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.sourceLabelArray = [[NSMutableArray alloc] initWithCapacity:0];

    anotherTableData = [[DataManager sharedInstance] m_Data];
    
    int getSelectStage = [defaults integerForKey:RandomNumber];
    
    randArray = [random3Array objectAtIndex:getSelectStage];//question
    for(int i = 0; i < [appDelegate.sequenceTitle count] ; i++)
    {
        if(cellState[i] == YES)
        {
            
            NSString* sequenceLabel;
            if([appDelegate.sequenceTitle count] == 1)
                sequenceLabel = [appDelegate.sequenceTitle objectAtIndex:0];//question
            
            else
            {
                int idx = [[randArray objectAtIndex:i] intValue];
                sequenceLabel = [appDelegate.sequenceTitle objectAtIndex:idx];
            }
            
            [self.sequenceTitleArray addObject:sequenceLabel];
        }
    }

    NSString* title = [self.sequenceTitleArray objectAtIndex:sequenceNumber];
     searchData = NO;
    NSString* fileName = [[NSBundle mainBundle] pathForResource:@"LearningLearny" ofType:@"plist"];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:fileName];
    self.sourceTitleArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.imagePathArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.sourceMusicArray = [[NSMutableArray alloc] initWithCapacity:0];

    for(int i = 0; i < [self.pointer getDataCount]; i++)
    {
        NSDictionary* dict = [array objectAtIndex:i];
    
        NSString* stageTitle = [dict objectForKey:FIRST_KEY];
        sequenceTitleSound = [dict objectForKey:SECOND_KEY];
        if ([stageTitle isEqualToString:title]) {
            NSMutableArray* itemData = [dict objectForKey:THIRD_KEY];
            for(int j =0 ; j < [itemData count]; j++)
            {
                NSDictionary* subDict = [itemData objectAtIndex:j];
                NSString* title = [subDict objectForKey:SUB_KEY1];
                NSString* imageName = [subDict objectForKey:SUB_KEY2];
                NSString* soundPath = [subDict objectForKey:SUB_KEY3];
                [sourceTitleArray addObject:title];
                [imagePathArray addObject:imageName];
                [sourceMusicArray addObject:soundPath];
                
            }
            searchData = YES;
            break;
        }
    }
    
    if(searchData == NO)
    {
        for(int i = 0; i < [anotherTableData count]; i++)
        {
            NSMutableDictionary* dict = [anotherTableData objectAtIndex:i];
            sequenceTitleSound = [dict objectForKey:SECOND_KEY];
            NSString* stageTitle = [dict objectForKey:FIRST_KEY];
            if([title isEqualToString:stageTitle])
            {
                NSMutableArray* itemData = [dict objectForKey:THIRD_KEY];
                for(int j =0 ; j < [itemData count]; j++)
                {
                    NSDictionary* subDict = [itemData objectAtIndex:j];
                    NSString* title = [subDict objectForKey:SUB_KEY1];
                    NSString* imageName = [subDict objectForKey:SUB_KEY2];
                    NSString* soundPath = [subDict objectForKey:SUB_KEY3];
                    [sourceTitleArray addObject:title];
                    [imagePathArray addObject:imageName];
                    [sourceMusicArray addObject:soundPath];
                    //question
                }
                searchData = YES;
                break;
            }
        }
        
    }//quetion if 0
    
    if(searchData == NO)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please select item in other panel" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    if([sourceTitleArray count]== 3)
        numOfPictures = 3;
    else
        numOfPictures = 4;
    
    stageRandArray = [self.pointer getRandomTableSequence:numOfPictures];

    count = numOfPictures;
    for( int j =0; j < count; j++)
    {
        NSInteger randIdx = [[stageRandArray objectAtIndex:j] intValue];
        int topLeftX;
       
        if(count == 3)
        {
            int step;
                step = ImageTitleXStep + 50;
            
                topLeftX = (ImageTitleXOffset + step * j)*scaleWidth;
        }
        else
        {
            int step;
            if (scaleHeight == 1)
                step = ImageTitleXStep;            
            else
                step = ImageTitleXStep;
            
                topLeftX = (ImageTitleXOffset + step * j)*scaleWidth;
        }

        int topLeftY = ImageTitleYOffset * scaleHeight;
        int width = ImageTitleWidth*scaleWidth;
        int height = ImageTitleHight*scaleHeight;
        
        UILabel *sourceTitle = [[UILabel alloc] initWithFrame:CGRectMake(topLeftX,topLeftY,width,height)];
        if([sourceTitleArray count] == 0)
        {
            NSLog(@"Error###");
            return;
        }
        NSString* text = [sourceTitleArray objectAtIndex:randIdx];//////////////error
        NSString* clue = @"";
        NSString* stageText = @"";
        if(written == YES)
            stageText = text;
        if(firSecThird ==YES)
            clue = alphabetArray[randIdx];
        
        NSString* label = [NSString stringWithFormat:@"%@ %@", clue, stageText];
        NSMutableAttributedString *attributedString =
        [[NSMutableAttributedString alloc]
         initWithString: label];
        int  stringCount = [[attributedString string]length] ;
        if(firSecThird == YES)
        {
            [attributedString addAttribute: NSForegroundColorAttributeName
                                     value: [UIColor redColor]
                                     range: NSMakeRange(0,6)];
            NSRange helloRange = NSMakeRange(0, stringCount);
            
            [attributedString addAttribute: NSFontAttributeName
                                     value:  [UIFont fontWithName:@"Helvetica" size:13 * scaleWidth]
                                     range: helloRange];
            
        }
        else{
            if(written == YES)
            {
                NSRange helloRange = NSMakeRange(0, stringCount);
                [attributedString addAttribute: NSFontAttributeName
                                         value:  [UIFont fontWithName:@"Helvetica" size:15 * scaleWidth]
                                         range: helloRange];
            }
        }
        
        sourceTitle.attributedText = attributedString;
        sourceTitle.contentMode = UIViewContentModeLeft;
        sourceTitle.lineBreakMode = UILineBreakModeCharacterWrap;
        sourceTitle.numberOfLines = 2;
        sourceTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
        [self.sourceLabelArray addObject:sourceTitle];
        [self.view addSubview:sourceTitle ];
        
        sourceTitle.textAlignment = UITextAlignmentCenter;
        [sourceTitle release];
    }
    
    for (int idx = 0; idx < numOfPictures; idx++) {
        
        UIImage *targetImage = [UIImage imageNamed:[NSString
                                                    stringWithFormat:@"image%d.png", idx+1]];
        
        UIImageView *targetImageView = [[UIImageView alloc] initWithImage:targetImage];
        targetImageView.contentMode = UIViewContentModeScaleAspectFill;
        targetImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
        
        if(count == 3)
        {
            int step;
                step = ImageViewXStep + 50;
            targetImageView.frame = CGRectMake((TargetImageViewXOffset + step * idx)* scaleWidth, TargetImageViewYOffset* scaleHeight, ImageViewWidth * scaleWidth, ImageViewHight * scaleHeight);
        }
        else
        {
//            if(count == 3)
//            {
//                int step;
//                if(scaleHeight == 1)
//                    step  = ImageTitleXStep + 47;
//                else
//                    step = ImageTitleXStep;
//                
//                topLeftX = (ImageTitleXOffset + step * j)*scaleWidth;
//            }
//            else
//            {
                int step;
                if (scaleHeight == 1)
                    step = ImageTitleXStep;
                else
                    step = ImageTitleXStep;
//
//                topLeftX = (ImageTitleXOffset + step * j)*scaleWidth;
//            }

            targetImageView.frame = CGRectMake((TargetImageViewXOffset + ImageViewXStep  * idx)* scaleWidth, TargetImageViewYOffset* scaleHeight, ImageViewWidth * scaleWidth, ImageViewHight * scaleHeight);
               
        }
        
//        float y = TargetImageViewYOffset* scaleHeight;
//        float x = (TargetImageViewXOffset + ImageViewXStep * idx) * scaleWidth;
//        int width =ImageViewWidth * scaleWidth;
//        int height = ImageViewHight * scaleHeight;
//        NSLog(@"%d,%d,%d,%d",(int)x, (int)y, width, height);
        
        [self.targetImageViewArray addObject:targetImageView];
        [self.view addSubview:targetImageView];
        [targetImageView release];
    }

    for( int j = 0; j < count; j++)
    {
        NSInteger randIdx = [[stageRandArray objectAtIndex:j] intValue];
        
        NSString* path = [imagePathArray objectAtIndex:randIdx];
        UIImage* sourceImage;
        NSString* stageLabel = [self.sequenceTitleArray objectAtIndex:0];
        if([self.pointer isPlistData:stageLabel] == NO)
            sourceImage = [self loadImage:path];
        else
            sourceImage = [UIImage imageNamed:path];
            
        CGRect imageViewFrame;
        if(count == 3)
        {
            int step;
                step = ImageViewXStep + 50;
                
            imageViewFrame = CGRectMake((SourceImageViewXOffset + step  * j) * scaleWidth ,SourceImageViewYOffset * scaleHeight, ImageViewWidth * scaleWidth, ImageViewHight * scaleHeight);
           
        }
        else
        {
            int step;
            step = ImageViewXStep + 50;
                          imageViewFrame = CGRectMake((SourceImageViewXOffset + ImageViewXStep  * j) * scaleWidth ,SourceImageViewYOffset * scaleHeight, ImageViewWidth * scaleWidth, ImageViewHight * scaleHeight);
  
        }
        
        UIImageView *sourceImageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
        CGRect cropRect = CGRectMake(0, 0, sourceImage.size.width, sourceImage.size.width);
        CGImageRef imageRef = CGImageCreateWithImageInRect([sourceImage CGImage], cropRect);
        [sourceImageView setImage:[UIImage imageWithCGImage:imageRef]];
        CGImageRelease(imageRef);
        
        sourceImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
        sourceImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        sourceImageView.tag = randIdx;
        imageCenterPoint[j] = sourceImageView.center;
        centerSourceImage[j] = sourceImageView.center;
        [self.sourceImageViewArray addObject:sourceImageView];
        [self.view addSubview:sourceImageView];
        rect[j] = sourceImageView.frame;
        [sourceImageView release];
    }
    
    [self setSlideTrue];
    [self setSlideFalse];
    
    NSString* stageTitle = [self.sequenceTitleArray objectAtIndex:sequenceNumber];
    tableCount = [self.sequenceTitleArray count];
    
    
    self.sequenceTitleLabel.text = stageTitle;
    if([self.pointer isPlistData:stageTitle] == YES)
    {
        currStagePlist = YES;
        resultMusicPlist[sequenceNumber] = YES;
    }
    
    if(spoken == YES)
    {
        if(currStagePlist == YES)
            [self playEffectSound:sequenceTitleSound];
        else
            [self playOwnAddMusic:sequenceTitleSound];
    }
    [dbSoundName addObject:sequenceTitleSound];
    [appDelegate playBackgroundMusic];
    
    [self saveMyView:self.view];
}

-(void)stopCurrentPlayer
{
    if(_soundPlayer != nil)
    {
        [_soundPlayer stop];
        [_soundPlayer release];
    }
}

-(void)viewWillDisappear:(BOOL)animate
{
    [self stopCurrentPlayer];
    if(recordPlayer != nil)
    {
        [recordPlayer stop];
        [recordPlayer release];
    }
}

-(void)playEffectSound:(NSString*)effectSound
{
    if(musicOutPlay == YES)
        return;
    if (_soundPlayer!=nil) {
        [_soundPlayer stop];
        [_soundPlayer release]; _soundPlayer=nil;
    }
       
    
    NSString* _itemString = effectSound;
    NSString* _url = [[NSBundle mainBundle] pathForResource:[_itemString substringToIndex:[_itemString length]-4] ofType:@"mp3"];
    if ([_url length] == 0) {
        NSLog(@"Effect sound path is nil%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
        return;
    }
    NSURL *_fileURL = [[NSURL alloc] initFileURLWithPath:_url];
    _soundPlayer = [[CustomAudioPlayer alloc] initWithURL:_fileURL];
    [_fileURL release];
    
    if (_soundPlayer==nil)
        return;
    
    [_soundPlayer setNumberOfLoops:0];
    [_soundPlayer prepareToPlay];
    [_soundPlayer play];
    
    
    [soundPlayer addObject:_soundPlayer];
}

- (void)handleTapGesture {
    if( touchDisable == YES)
        return;
    
        // handling code
    if (selectedImageViewIdx == -1) {
        return;
    }

    UIImageView* imageView = [self.sourceImageViewArray objectAtIndex:selectedImageViewIdx];
    [self performSelector:@selector(doCoolAnimation:) withObject:imageView afterDelay:0.0];
    [self performSelector:@selector(reScaleImageView:) withObject:imageView afterDelay:2.0];
    
    if(spoken == YES)
    {
        NSLog(@"%d",imageView.tag);
        float timeInterval = 0;
        if(firSecThird == YES)
        {
            [appDelegate  playSequenceSound:imageView.tag];
            timeInterval = 1.2;
        }
        [self performSelector:@selector(playTouchVoice:) withObject:[NSNumber numberWithInt: imageView.tag ] afterDelay:timeInterval];
        
    }
    else
    {
        if (currStagePlist == YES)
            [self playEffectSound:[sourceMusicArray objectAtIndex:imageView.tag]];
        else
            [self playOwnAddMusic:[sourceMusicArray objectAtIndex:imageView.tag]];
    }
    [self performSelector:@selector(touchEnable) withObject:nil afterDelay:2.0];
}

- (UIImage *)loadImage:(NSString *)name {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:name];
    UIImage *img = [UIImage imageWithContentsOfFile:fullPath];
    
    return img;
}

- (void)setSlideFalse
{
    self.slideFalseImageArray = [[NSMutableArray alloc] initWithCapacity:0];
    enableTouch = YES;
    for(int i = 0 ;i < count; i++)
    {
        UIImage *popImage = [UIImage imageNamed:@"first.png"];
        UIImageView *targetImageView = [[UIImageView alloc] initWithImage:popImage];
        targetImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
        
        if(count == 3)
        {
            if(nextScreen == NO)
            {
                int step;
                if (scaleHeight == 1)
                    step = ImageViewXStep + 50;
                else
                    step = ImageViewXStep + 60;
                targetImageView.frame = CGRectMake((TargetImageViewXOffset + step * i)* scaleWidth, TargetImageViewYOffset* scaleHeight, ImageViewWidth * scaleWidth, ImageViewHight * scaleHeight);
            }
            
            else
            {
                int step;
                if (scaleHeight == 1)
                    step = ImageViewXStep + 50;
                else
                    step = ImageViewXStep + 60;
                targetImageView.frame = CGRectMake((TargetImageViewXOffset + step * i)* widescreenScale, TargetImageViewYOffset* scaleHeight, ImageViewWidth * widescreenScale, ImageViewHight * scaleHeight);
            }
        }
        else
        {
            if(nextScreen == NO)
            {
                int step;
                    step = ImageViewXStep ;
               
                targetImageView.frame = CGRectMake((TargetImageViewXOffset + step * i)* scaleWidth, TargetImageViewYOffset* scaleHeight, ImageViewWidth * scaleWidth, ImageViewHight * scaleHeight);
            }
            else
            {
                int step;
//                if (scaleHeight == 1)
                    step = ImageViewXStep ;
//                else
//                    step = ImageViewXStep + 60;
                targetImageView.frame = CGRectMake((TargetImageViewXOffset + step * i)* widescreenScale, TargetImageViewYOffset* scaleHeight, ImageViewWidth * widescreenScale, ImageViewHight * scaleHeight);
            }
        }
        
        targetImageView.contentMode = UIViewContentModeScaleAspectFit;
        targetImageView.hidden = YES;
        [self.view addSubview:targetImageView];
        [slideFalseImageArray  addObject:targetImageView];
    }
}

-(void)resetSlideFalse
{
    enableTouch = YES;
    for(int i = 0 ;i < count; i++)
    {
        UIImage *popImage = [UIImage imageNamed:@"first.png"];
        UIImageView *targetImageView = [slideFalseImageArray objectAtIndex:i];
        targetImageView.image  = popImage;
        targetImageView.hidden = YES;
               
    }
}

- (void)resetSlideTrue
{
    enableTouch = YES;
    for(int i = 0 ;i < count; i++)
    {
        UIImage *popImage = [UIImage imageNamed:@"second.png"];
        UIImageView *targetImageView = [slideTrueImageArray objectAtIndex:i];
        targetImageView.image  = popImage;
        targetImageView.hidden = YES;
    }

}

- (void)setSlideTrue
{
    self.slideTrueImageArray = [[NSMutableArray alloc] initWithCapacity:0];
    enableTouch = YES;
    for(int i = 0 ;i < count; i++)
    {
        UIImage *popImage = [UIImage imageNamed:@"second.png"];
        UIImageView *targetImageView = [[UIImageView alloc] initWithImage:popImage];
        targetImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
        if(count == 3)
        {
            if(nextScreen == NO)
            {
                int step;
                if (scaleHeight == 1)
                    step = ImageViewXStep + 50;
                else
                    step = ImageViewXStep + 60;
                targetImageView.frame = CGRectMake((TargetImageViewXOffset + step * i)* scaleWidth, TargetImageViewYOffset* scaleHeight, ImageViewWidth * scaleWidth, ImageViewHight * scaleHeight);            }
            else
            {
                int step;
                if (scaleHeight == 1)
                    step = ImageViewXStep + 50;
                else
                    step = ImageViewXStep + 60;
                targetImageView.frame = CGRectMake((TargetImageViewXOffset + step * i)* widescreenScale, TargetImageViewYOffset* scaleHeight, ImageViewWidth * widescreenScale, ImageViewHight * scaleHeight);
            }

        }
        else
        {
            if(nextScreen == NO)
            {
                int step;
                    step = ImageViewXStep;
                targetImageView.frame = CGRectMake((TargetImageViewXOffset + step * i)* scaleWidth, TargetImageViewYOffset* scaleHeight, ImageViewWidth * scaleWidth, ImageViewHight * scaleHeight);
            }
            else
            {
                int step;
//                if (scaleHeight == 1)
                    step = ImageViewXStep ;
//                else
//                    step = ImageViewXStep + 60;
                targetImageView.frame = CGRectMake((TargetImageViewXOffset + step * i)* widescreenScale, TargetImageViewYOffset* scaleHeight, ImageViewWidth * widescreenScale, ImageViewHight * scaleHeight);
            }
//            targetImageView.frame = CGRectMake((TargetImageViewXOffset + ImageViewXStep  * i) *widescreenScale, TargetImageViewYOffset *scaleHeight, ImageViewWidth *widescreenScale, ImageViewHight *scaleHeight);

        }
            
//        targetImageView.frame = CGRectMake((TargetImageViewXOffset + ImageViewXStep  * i) *scaleWidth, TargetImageViewYOffset *scaleHeight, ImageViewWidth *scaleWidth, ImageViewHight *scaleHeight);
        targetImageView.contentMode = UIViewContentModeScaleAspectFit;
        targetImageView.hidden = YES;
        [self.view addSubview:targetImageView];
        [slideTrueImageArray  addObject:targetImageView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button actions
- (IBAction)clickHomeButton:(id)sender
{
    int playercount= [soundPlayer count];
    for( int i = 0; i < playercount ;i++)
    {
        CustomAudioPlayer* player = [soundPlayer objectAtIndex:i];
        [player stop];
        player  = nil;
        [player release];
        
    }
    musicOutPlay = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];

    if([touch tapCount] == 2) {
        [self handleTapGesture];
        touchDisable = YES;
        return;
    }

    if(touchDisable == YES)
        return;

       selectedImageViewIdx = -1;
        
    CGPoint point  = [touch locationInView:self.view];
    saveBeginPoint = point;
    
    for (int idx = 0; idx < count; idx++) {
        UIImageView *imageView = [self.sourceImageViewArray objectAtIndex:idx];
        if( CGRectContainsPoint([imageView frame], point))
        {
            NSLog(@"%d",imageView.hidden);
        }
//        NSLog("%d",ImageVIew.hidden);
        NSLog(@"");
        if (imageView.hidden == NO && CGRectContainsPoint([imageView frame], point) && enableTouch == YES)
        {
            selectedImageViewIdx = idx;
            selectedImageViewOrigPos = imageView.center;
            [self.view addSubview: imageView];
            break;
        }
    }
    
}

- (void)playTouchVoice:(NSNumber*) idx
{
    int index = [idx intValue];
    if (currStagePlist == YES)
        [self playEffectSound:[sourceMusicArray objectAtIndex:index]];
    else
        [self playOwnAddMusic:[sourceMusicArray objectAtIndex:index]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(touchDisable == YES)
        return;
    if (selectedImageViewIdx >= 0) {
        UITouch *touch = [touches anyObject];
        UIImageView *selectedImageView = [self.sourceImageViewArray objectAtIndex:selectedImageViewIdx];
        selectedImageView.center = [touch locationInView:self.view];
    }
}

- (void)moveImage:(UIImageView*)image duration:(NSTimeInterval)duration curve:(int)curve x:(CGFloat)x y:(CGFloat)y
{
    image.hidden = NO;
    enableTouch = NO;
    [UIView animateWithDuration:duration animations:^{
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:duration];
        [UIView setAnimationCurve:curve];

        [UIView setAnimationBeginsFromCurrentState:YES];
        CGAffineTransform transform = CGAffineTransformMakeTranslation(x,y);
        image.transform = transform;
                [UIView commitAnimations];
                //animation code here
    } completion:^(BOOL finished)
    {
        if(finished == NO)
        {
            
        }
    }];
    
}

-(void) writeData
{
    // create dictionary with values in UITextFields
    NSString* sequenceLabel = @"Sequence";
    NSString* sound = @"sound";
  
    NSMutableDictionary *addItem =[[NSMutableDictionary alloc] init];
    [addItem setValue:sequenceLabel forKey:FIRST_KEY];
    [addItem setValue:sound forKey:SECOND_KEY];
        
    NSString* plistPath = nil;
    NSFileManager* manager = [NSFileManager defaultManager];
    plistPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"LearningLearny.plist"];
    if (plistPath != nil)
    {
        if ([manager isWritableFileAtPath:plistPath])
        {
            NSMutableArray* infoDict = [[NSMutableArray alloc  ] initWithContentsOfFile:plistPath];
                       [infoDict addObject:addItem];
        }
    }
}

- (CGFloat) distanceBetweenTwoPoints:(CGPoint)firstPoint Second:(CGPoint)secondPoint
{
    CGFloat dist2 = powf((firstPoint.x - secondPoint.x), 2) + powf((secondPoint.y - secondPoint.y), 2);
    
    return sqrtf(dist2);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(touchDisable == YES)
        return;
    noSlideArea = YES;

    falseSlideTag = -1;
    if (selectedImageViewIdx >= 0) {
        tempNumber = selectedImageViewIdx;
        UITouch *touch = [touches anyObject];
        CGPoint point  = [touch locationInView:self.view];
        UIImageView *selectedImageView = [self.sourceImageViewArray objectAtIndex:selectedImageViewIdx];
        if(CGPointEqualToPoint(point, saveBeginPoint) == YES)
            return;
        
        if(CGRectContainsPoint(rect[selectedImageViewIdx], point))
        {
            selectedImageView.center = selectedImageViewOrigPos;
            return;
        }
        
        NSInteger correctIdx = selectedImageView.tag;
        trueSlideIndex = correctIdx;
        UIImageView *targetImageView = [self.targetImageViewArray objectAtIndex:correctIdx];
        //if (CGRectContainsPoint([targetImageView frame], point)) {
        if ([self distanceBetweenTwoPoints:targetImageView.center Second:point] < targetImageView.frame.size.width) {
            
            if(alreadyTeachTap == YES && scoreCount != correctIdx)
            {
                selectedImageView.center = selectedImageViewOrigPos;
                return;
            }

            [targetImageView setImage:selectedImageView.image];
            selectedImageView.hidden = YES;
            selectedImageView.center = selectedImageViewOrigPos;
            UILabel *selectedTitle = [self.sourceLabelArray objectAtIndex:selectedImageViewIdx];
            selectedTitle.hidden = YES;
            scoreCount++;
            UIImageView* targetImageView = [slideTrueImageArray objectAtIndex: correctIdx];
            if(successSound == YES)
            {
                [self moveImage:targetImageView duration:0.5 curve:UIViewAnimationOptionCurveLinear x:0 y:-50];
                int musicId = arc4random() % 2;
                [appDelegate playSuccessSound:musicId];
                [self performSelector:@selector(onTrueTick:) withObject:nil afterDelay:0.5];

            }
            if(successSound == NO && alreadyTeachTap == YES)
            {
                [self continueTouchMode];
            } 
            if (scoreCount == count) {
                    [self performSelector:@selector(nextPlay) withObject:nil afterDelay:0.5];
                               
            }
        }
        else{
            failTouch[selectedImageViewIdx]++;
            if(failTouch[selectedImageViewIdx] >= 2 && alreadyTeachTap == YES)
            {
                if (correctIdx > scoreCount) {
                    selectedImageView.center = selectedImageViewOrigPos;
                    return;
                }
                
                [targetImageView setImage:selectedImageView.image];
                selectedImageView.hidden = YES;
                selectedImageView.center = selectedImageViewOrigPos;
                UILabel *selectedTitle = [self.sourceLabelArray objectAtIndex:selectedImageViewIdx];
                selectedTitle.hidden = YES;
                scoreCount++;
                UIImageView* targetImageView = [slideTrueImageArray objectAtIndex: correctIdx];
                
                if(successSound == YES)
                {
                    [self moveImage:targetImageView duration:0.5 curve:UIViewAnimationOptionCurveLinear x:0 y:-50];
                    int musicId = arc4random() % 2;
                    [appDelegate playSuccessSound:musicId];
                    [self performSelector:@selector(onTrueTick:) withObject:nil afterDelay:0.5];

                }
                if (scoreCount == count)
                {
                    [self performSelector:@selector(nextPlay) withObject:nil afterDelay:0.5];
                }
            }
            else
            {
                for(int i = 0; i < [self.targetImageViewArray count]; i++)
                {
                    UIImageView* imageView = [self.targetImageViewArray objectAtIndex:i];
                    if(CGRectContainsPoint([imageView frame], point))
                    {
                        saveEndPoint = point;
                        falseSlideTag = i;
                        noSlideArea = NO;
                        break;
                    }
                }
                
                if(unsuccessSound ==YES && noSlideArea == NO)
                {
                    if(falseSlideTag > 3)
                        return;
                    
                    targetImageView = [slideFalseImageArray objectAtIndex:falseSlideTag];
                    [self.view addSubview:targetImageView];
                    int musicId =  arc4random() % 2;
                    [appDelegate playUnsuccessSound:musicId];
                    
                    [self moveImage:targetImageView duration:0.5 curve:UIViewAnimationOptionCurveLinear x:0 y:-50];
                    
                    [self performSelector:@selector(onFalseTick:) withObject:nil afterDelay:0.5];
                    
                }
                else
                {
                    
                    if (selectedImageViewOrigPos.x == 0 && selectedImageViewOrigPos.y == 0) {
                        
                    }
                    else
                        selectedImageView.center = selectedImageViewOrigPos;
                }
                if(teachTouch == YES)
                {
                    if (currStagePlist == YES) {
                        [self performSelector:@selector(playEffectSound:) withObject:[sourceMusicArray objectAtIndex:scoreCount] afterDelay:0.7];
                    }
                    else
                        [self performSelector:@selector(playOwnAddMusic:) withObject:[sourceMusicArray objectAtIndex:scoreCount] afterDelay:0.7];
                }
            }
        }
    }
}

-(void) nextPlay
{
    for(int i = 0; i < count; i++)
    {
        UIImageView* imageView = [self.targetImageViewArray objectAtIndex:i];
        imageView.image = nil;
        imageView = [self.sourceImageViewArray objectAtIndex:i];
        [imageView release];
    }

    BOOL stageResult = YES;
    for (int i = 0; i < 4; i++) {
        if (failTouch[i] != 0) {
            stageResult = NO;
            break;
        }
    }
    stageSuccess[sequenceNumber] = stageResult;

    UIAlertView *successAlertView = [[UIAlertView alloc]
                                     initWithTitle:nil
                                     message:@"Congratulations!"
                                     delegate: self
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil,
                                     nil];
    successAlertView.delegate = self;
    [successAlertView show];
    [successAlertView release];
    
    scoreCount = 0;
    sequenceNumber++;

}

-(void) onFalseTick:(NSTimer*) timer
{
    if(selectedImageViewIdx == -1)
    {
        for (int idx = 0; idx < numOfPictures; idx++) {
            UIImageView *imageView = [self.sourceImageViewArray objectAtIndex:idx];
            if (CGRectContainsPoint([imageView frame], saveBeginPoint))
            {
                selectedImageViewIdx = idx;
//                selectedImageViewOrigPos = imageView.center;
                break;
            }
        }
        for(int i = 0; i < [self.targetImageViewArray count]; i++)
        {
            UIImageView* imageView = [self.targetImageViewArray objectAtIndex:i];
            //                CGRect pt= [imageView frame];
            if(CGRectContainsPoint([imageView frame], saveEndPoint))
            {
                        falseSlideTag = i;
                        break;
            }
        }

    }
    
    if (selectedImageViewIdx == -1) {
        NSLog(@"%d temp",tempNumber);
    }
    UIImageView *selectedImageView = [self.sourceImageViewArray objectAtIndex:tempNumber];
    selectedImageView.center = selectedImageViewOrigPos;
    UIImageView* imageView = [slideFalseImageArray objectAtIndex:falseSlideTag];
    imageView.hidden =  YES;
//    NSLog(@"%d.l",selectedImageViewIdx);
    selectedImageView.center = selectedImageViewOrigPos;
    if(falseSlideTag == -1 || falseSlideTag > 3)
        return;
    enableTouch = YES;

    
}
-(void) onTrueTick:(NSTimer*) timer
{
    UIImageView* imageView = [slideTrueImageArray objectAtIndex:trueSlideIndex];
    imageView.hidden = YES;
    
    enableTouch = YES;
    if(teachTouch == YES)
        [self continueTouchMode];

}

- (void) nextScreen
{
    if (sequenceNumber == tableCount) {
        return;
    }

    teachTouch = NO;
    touchDisable = NO;
    alreadyTeachTap = NO;
    [sourceLabelArray removeAllObjects];
    for(int i = 0; i < count ; i++)
    {
        UIImageView* imageView = [targetImageViewArray objectAtIndex:i];
        imageView.image = nil;
        imageView = [sourceImageViewArray objectAtIndex:i];
        imageView.image = nil;
        failTouch[i] = 0;
    }
    
    self.sequenceTitleLabel.text = [self.sequenceTitleArray objectAtIndex:sequenceNumber];
    NSString* title = self.sequenceTitleLabel.text;
    currStagePlist = [self.pointer isPlistData:title];
    resultMusicPlist[sequenceNumber] = currStagePlist;
    searchData = NO;
    
    [sourceTitleArray removeAllObjects];
    [imagePathArray removeAllObjects];
    [sourceMusicArray removeAllObjects];
    //[sourceImageViewArray removeAllObjects];

    self.sourceImageViewArray = [[NSMutableArray alloc] init];
    self.targetImageViewArray = [[NSMutableArray alloc] init];
    
    NSString* fileName = [[NSBundle mainBundle] pathForResource:@"LearningLearny" ofType:@"plist"];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:fileName];
    for(int i = 0; i < [self.pointer getDataCount]; i++)
    {
        NSDictionary* dict = [array objectAtIndex:i];
        
        NSString* stageTitle = [dict objectForKey:FIRST_KEY];
        sequenceTitleSound = [dict objectForKey:SECOND_KEY];
        if ([stageTitle isEqualToString:title]) {
            NSMutableArray* itemData = [dict objectForKey:THIRD_KEY];
            for(int j =0 ; j < [itemData count]; j++)
            {
                NSDictionary* subDict = [itemData objectAtIndex:j];
                NSString* title = [subDict objectForKey:SUB_KEY1];
                NSString* imageName = [subDict objectForKey:SUB_KEY2];
                NSString* soundName = [subDict objectForKey:SUB_KEY3];
                [sourceTitleArray addObject:title];
                [imagePathArray addObject:imageName];
                if ([soundName length] == 0)
                    NSLog(@"Sound is nil");
                
                else
                    [sourceMusicArray addObject:soundName];
            }
            searchData = YES;
            break;
            
        }
    }
    
    if(searchData == NO)
    {
        for(int i = 0; i < [anotherTableData count]; i++)
        {
            NSMutableDictionary* dict = [anotherTableData objectAtIndex:i];
            
            NSString* stageTitle = [dict objectForKey:FIRST_KEY];
            sequenceTitleSound = [dict objectForKey:SECOND_KEY];
            if([title isEqualToString:stageTitle])
            {
                NSMutableArray* itemData = [dict objectForKey:THIRD_KEY];
                for(int j =0 ; j < [itemData count]; j++)
                {
                    NSDictionary* subDict = [itemData objectAtIndex:j];
                    NSString* title = [subDict objectForKey:SUB_KEY1];
                    NSString* imageName = [subDict objectForKey:SUB_KEY2];
                    NSString* sound = [subDict objectForKey:SUB_KEY3];
                    [sourceTitleArray addObject:title];
                    [imagePathArray addObject:imageName];
                    if ([sound length] == 0)
                        NSLog(@"Sound is nil**********************************");
                    
                    else
                        [sourceMusicArray addObject:sound];
                }
                searchData = YES;
                break;
            }
            
        }
        
    }
    
    if([sourceTitleArray count]== 3)
        numOfPictures = 3;
    else
        numOfPictures = 4;
        
    stageRandArray = [self.pointer getRandomTableSequence:numOfPictures];
    count = numOfPictures;    
    for( int j =0; j < count; j++)
    {
        NSInteger randIdx = [[stageRandArray objectAtIndex:j] intValue];
        int topLeftX;
        if(count == 3)
        {
            int step;
                step = ImageViewXStep + 50;
            
            topLeftX = (ImageTitleXOffset + step * j)*widescreenScale;
        }
        
        else
        {
            int step;
                step  = ImageTitleXStep;
                       
            topLeftX = (ImageTitleXOffset + step * j)*widescreenScale;

//            if (scaleHeight == 1) {
//                topLeftX = ImageTitleXOffset + ImageTitleXStep * j * widescreenScale;
//            }
//            else
//                topLeftX = (ImageTitleXOffset + (ImageTitleXStep - 50) * j)*widescreenScale;
            
        }
        
        int topLeftY = ImageTitleYOffset *scaleHeight;
        int width = ImageTitleWidth*widescreenScale;
        int height = ImageTitleHight*scaleHeight;
        
        UILabel *sourceTitle = [[UILabel alloc] initWithFrame:CGRectMake(topLeftX,topLeftY,width,height)];
        NSString* text = [sourceTitleArray objectAtIndex:randIdx];
        NSString* clue = @"";
        NSString* stageText = @"";
        if(written == YES)
            stageText = text;
        if(firSecThird ==YES)
            clue = alphabetArray[randIdx];
        
        NSString* label = [NSString stringWithFormat:@"%@ %@", clue, stageText];
        NSMutableAttributedString *attributedString =
        [[NSMutableAttributedString alloc]
         initWithString: label];
        int  stringCount = [[attributedString string]length] ;
        if(firSecThird == YES)
        {
            
            
            [attributedString addAttribute: NSForegroundColorAttributeName
                                     value: [UIColor redColor]
                                     range: NSMakeRange(0,6)];
            NSRange helloRange = NSMakeRange(0, stringCount);
            
            [attributedString addAttribute: NSFontAttributeName
                                     value:  [UIFont fontWithName:@"Helvetica" size:13 * scaleWidth]
                                     range: helloRange];
            
            
        }
        else{
            if(written == YES)
            {
                NSRange helloRange = NSMakeRange(0, stringCount);
                [attributedString addAttribute: NSFontAttributeName
                                         value:  [UIFont fontWithName:@"Helvetica" size:15 * scaleWidth]
                                         range: helloRange];
            }
        }
        
        sourceTitle.attributedText = attributedString;
        sourceTitle.contentMode = UIViewContentModeLeft;
        
        sourceTitle.lineBreakMode = UILineBreakModeCharacterWrap;
        sourceTitle.numberOfLines = 2;
        sourceTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
        [self.sourceLabelArray addObject:sourceTitle];
        [self.view addSubview:sourceTitle ];
        
        sourceTitle.textAlignment = UITextAlignmentCenter;
        [sourceTitle release];
    }
    
    for( int j = 0; j < count; j++)
    {
        NSInteger randIdx = [[stageRandArray objectAtIndex:j] intValue];
        
        NSString* path = [imagePathArray objectAtIndex:randIdx];
        UIImage* sourceImage;
        //        NSString* stageLabel = [self.sequenceTitleArray objectAtIndex:0];
        if([self.pointer isPlistData:title] == NO)
            sourceImage = [self loadImage:path];
        else
            sourceImage = [UIImage imageNamed:path];
        
        CGRect imageViewFrame;
        if(count == 3)
        {
            int step;
                step = ImageViewXStep + 50;
            
            imageViewFrame = CGRectMake((SourceImageViewXOffset + step  * j) * widescreenScale,SourceImageViewYOffset * scaleHeight, ImageViewWidth * widescreenScale, ImageViewHight * scaleHeight);

        }
        else
        {
            int step;
            step = ImageViewXStep ;
            imageViewFrame = CGRectMake((SourceImageViewXOffset + step * j) * widescreenScale ,SourceImageViewYOffset * scaleHeight,ImageViewWidth * widescreenScale, ImageViewHight* scaleHeight);
                
          
        }
        
        UIImageView *sourceImageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
        CGRect cropRect = CGRectMake(0, 0, sourceImage.size.width, sourceImage.size.width);
        CGImageRef imageRef = CGImageCreateWithImageInRect([sourceImage CGImage], cropRect);
        [sourceImageView setImage:[UIImage imageWithCGImage:imageRef]];
        CGImageRelease(imageRef);
        
        
        //        CGRect frame = sourceImageView.frame;
        sourceImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
        sourceImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        sourceImageView.tag = randIdx;
        rect[j] = sourceImageView.frame;
        
        centerSourceImage[j] = sourceImageView.center;
        [self.sourceImageViewArray addObject:sourceImageView];
        [self.view addSubview:sourceImageView];
        [sourceImageView release];
    }
    
    for (int idx = 0; idx < numOfPictures; idx++) {
        
        UIImage *targetImage = [UIImage imageNamed:[NSString
                                                    stringWithFormat:@"image%d.png", idx+1]];
        
        UIImageView *targetImageView = [[UIImageView alloc] initWithImage:targetImage];
        targetImageView.contentMode = UIViewContentModeScaleAspectFill;
        targetImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
        
        if(numOfPictures == 3)
        {
            int step;
                    step = ImageViewXStep + 50;
            targetImageView.frame = CGRectMake((TargetImageViewXOffset + step * idx)* widescreenScale, TargetImageViewYOffset* scaleHeight, ImageViewWidth * widescreenScale, ImageViewHight * scaleHeight);
        }
        else
        {
            int step;
            step = ImageViewXStep ;
            targetImageView.frame = CGRectMake((TargetImageViewXOffset + step * idx)* widescreenScale, TargetImageViewYOffset* scaleHeight, ImageViewWidth * widescreenScale, ImageViewHight * scaleHeight);
                        
        }
        float y = TargetImageViewYOffset* scaleHeight;
        float x = (TargetImageViewXOffset + ImageViewXStep * idx) * widescreenScale;
        int width =ImageViewWidth * widescreenScale;
        int height = ImageViewHight * scaleHeight;
        NSLog(@"%d,%d,%d,%d",(int)x,(int)y,width    ,height);
        
        
        
        [self.targetImageViewArray addObject:targetImageView];
        [self.view addSubview:targetImageView];
        [targetImageView release];
    }
    
    nextScreen = YES;
    [self setSlideFalse];
    
    [self setSlideTrue];
    [self saveMyView:self.view];
    
    if (spoken == YES) {
        if(currStagePlist == YES)
            [self playEffectSound:sequenceTitleSound];
        else
            [self playOwnAddMusic:sequenceTitleSound];
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if(isSelectData == NO)
        {
            UINavigationController* nav = self.navigationController;
            ListOfSequencesViewController* viewController;
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                viewController = [[ListOfSequencesViewController alloc] initWithNibName:@"ListOfSequencesViewController_iPhone" bundle:nil];
            else
                viewController = [[ListOfSequencesViewController alloc] initWithNibName:@"ListOfSequencesViewController_iPad" bundle:nil];
            [nav popToRootViewControllerAnimated:NO];
            [nav pushViewController:viewController animated:YES];

            return;
        }
        else if(threePic == NO && fourPic == NO){
            UINavigationController* nav = self.navigationController;
            SettingsViewController* viewController;
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                    viewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController_iPhone" bundle:nil];
            else
                viewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController_iPad" bundle:nil];
            [nav popToRootViewControllerAnimated:NO];
            [nav pushViewController:viewController animated:YES];
            return;

        }
        if (sequenceNumber >= tableCount) {
            BOOL gameResult = YES;
            for (int i = 0; i < sequenceNumber; i++) {
                if (stageSuccess[i] == NO) {
                    gameResult = NO;
                    break;
                }
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
            return;
            
//            [self playEffectSound:APPLAUSE];
//
//            self.btnPlay.hidden = NO;
//            [self.teachMode setHidden:YES];
//
//            self.sequenceTitleLabel.text = @"";
//            self.homeButton.hidden = YES;
//            self.phraseButton.hidden = YES;
//            
//            
//            return;
        }
        if (secondeTeach == YES) {
            secondeTeach = NO;
            return;
            
        }
        if(searchData == NO)
            [self.navigationController popToRootViewControllerAnimated:YES];
        if (alreadyTeachTap == YES && scoreCount > 0) {
            return;
        }
        [self nextScreen];
    }
}

- (void) doCoolAnimation:(UIImageView*)imageView 
{
    [UIView beginAnimations:@"glowingAnimation" context:nil];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:2];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:NO];
    [UIView setAnimationsEnabled:YES];
    imageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView commitAnimations];
}

- (void)viewDidUnload {
    [self setTeachMode:nil];
    [self setBtnPlay:nil];
    [self setHomeButton:nil];
    [self setPhraseButton:nil];
    [self setBackgroundImageView:nil];
        [super viewDidUnload];
    
}

- (void)continueTouchMode
{
    if(scoreCount == 0)
        [self playEffectSound:TEACHVOICE];////teachquestion
        UIImageView* sourceImageView,*targetImageView ;
    if(scoreCount == count)
    {
        return;
    }
    int highlightNumber = -1;
    for(int i = 0; i <[self.sourceImageViewArray count]; i++)
    {
        sourceImageView = [self.sourceImageViewArray objectAtIndex:i];
        if (sourceImageView.hidden == NO && sourceImageView.tag == scoreCount)
        {
            highlightNumber = i;
            break;
        }
    }

    sourceImageView =[self.sourceImageViewArray objectAtIndex:highlightNumber];
    targetImageView = [self.targetImageViewArray objectAtIndex:sourceImageView.tag];
    if(scoreCount == 0)
    {
        [self performSelector:@selector(doCoolAnimation:) withObject:sourceImageView afterDelay:2.0];
        [self performSelector:@selector(doCoolAnimation:) withObject:targetImageView afterDelay:2.7];
        if (currStagePlist == YES) {
            [self performSelector:@selector(playEffectSound:) withObject:[sourceMusicArray objectAtIndex:scoreCount] afterDelay:3.2];
        }
        else
        {
            [self performSelector:@selector(playOwnAddMusic:) withObject:[sourceMusicArray objectAtIndex:scoreCount] afterDelay:3.2];
        }
    }
    else{
        touchDisable = YES;
        [self doCoolAnimation:sourceImageView];
        [self performSelector:@selector(reScaleImageView:) withObject:sourceImageView afterDelay:2.0];
        [self performSelector:@selector(doCoolAnimation:) withObject:targetImageView afterDelay:2.0];
        [self performSelector:@selector(reScaleImageView:) withObject:targetImageView afterDelay:4.0];
        [self performSelector:@selector(touchEnable) withObject:nil afterDelay:4.0];
        if(spoken == YES)
        {
            float timeInterval = 0;
            if(firSecThird == YES)
            {
                [appDelegate  playSequenceSound:scoreCount];
                timeInterval = 1.2;
            }
            [self performSelector:@selector(playTouchVoice:) withObject:[NSNumber numberWithInt: scoreCount ] afterDelay:timeInterval];
            
        }
    }
}

//- (void)playOwnAddMusic:(NSString*)musicPath
//{
//    NSString* recorderFilePath = nil;
//    if(!recorderFilePath)
//		recorderFilePath = [[NSString stringWithFormat:@"%@/%@.caf", DOCUMENTS_FOLDER, musicPath] retain];
//	
//	//NSLog(@"Playing sound from Path: %@",recorderFilePath);
//	
//	if(soundID)
//	{
//		AudioServicesDisposeSystemSoundID(soundID);
//	}
//	
//	//Get a URL for the sound file
//	NSURL *filePath = [NSURL fileURLWithPath:recorderFilePath isDirectory:NO];
//	
//	//Use audio sevices to create the sound
//	AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
//	
//	//Use audio services to play the sound
//    
//	AudioServicesPlaySystemSound(soundID);
//    
//}

- (void)playOwnAddMusic:(NSString*)musicPath
{
    NSString* recorderFilePath = nil;
    if(!recorderFilePath)
		recorderFilePath = [[NSString stringWithFormat:@"%@/%@.caf", DOCUMENTS_FOLDER, musicPath] retain];
		
	//Get a URL for the sound file
	NSURL *filePath = [NSURL fileURLWithPath:recorderFilePath isDirectory:NO];
	
    if (recordPlayer != nil)
        [recordPlayer release];

    recordPlayer = [[CustomAudioPlayer alloc] initWithURL:filePath];
    
    if (recordPlayer==nil)
        return;
    
    [recordPlayer setNumberOfLoops:0];
    [recordPlayer prepareToPlay];
    [recordPlayer play];
    
}

- (IBAction)onTeach:(id)sender {

    if(scoreCount > 0 && alreadyTeachTap == NO)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please Touch Teach Button At First" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        secondeTeach = YES;
        return;
    }
    if(alreadyTeachTap == YES && scoreCount > 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"You already Tap Teach Button" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
        
        
    if(scoreCount == 0 && alreadyTeachTap == NO)
        alreadyTeachTap = YES;
        [self playEffectSound:TEACHVOICE];
        teachTouch = YES;
        UIImageView* sourceImageView,*targetImageView ;
    
        int highlightNumber = -1;
        for(int i = 0; i <[self.sourceImageViewArray count]; i++)
        {
            sourceImageView = [self.sourceImageViewArray objectAtIndex:i];
            if (sourceImageView.hidden == NO && sourceImageView.tag == scoreCount)
            {
                highlightNumber = i;
                break;
            }
        }
    
        
    sourceImageView =[self.sourceImageViewArray objectAtIndex:highlightNumber];
    targetImageView = [self.targetImageViewArray objectAtIndex:sourceImageView.tag];
    if(scoreCount == 0)
    {
        touchDisable = YES;
        [self performSelector:@selector(doCoolAnimation:) withObject:sourceImageView afterDelay:2.0];
        [self performSelector:@selector(reScaleImageView:) withObject:sourceImageView afterDelay:4.0];
        [self performSelector:@selector(doCoolAnimation:) withObject:targetImageView afterDelay:2.7];
        [self performSelector:@selector(reScaleImageView:) withObject:targetImageView afterDelay:4.7];
        [self performSelector:@selector(touchEnable) withObject:nil afterDelay:4.7];
        float timeInterval = 0;
        
        if(firSecThird == YES)
        {
//            [appDelegate  playSequenceSound:scoreCount];
            [self performSelector:@selector(playEffectSound:) withObject:FIRST_SOUND afterDelay:4.7];
            timeInterval = 4.7;
        }

        if (currStagePlist == YES) {
            
            [self performSelector:@selector(playEffectSound:) withObject:[sourceMusicArray objectAtIndex:scoreCount] afterDelay:2.0 + timeInterval];
        }
        else
        {
            [self performSelector:@selector(playOwnAddMusic:) withObject:[sourceMusicArray objectAtIndex:scoreCount] afterDelay:2.0 + timeInterval];
        }

    }
    else{
        
        [self doCoolAnimation:sourceImageView];
       
        [self performSelector:@selector(doCoolAnimation:) withObject:targetImageView afterDelay:2.0];
        float timeInterval = 0;
        if(firSecThird == YES)
        {
            [appDelegate  playSequenceSound:scoreCount];
            timeInterval = 1.2;
        }

        if (currStagePlist == YES) 
            [self performSelector:@selector(playEffectSound:) withObject:[sourceMusicArray objectAtIndex:scoreCount] afterDelay:2.0 + timeInterval];
        
        else
            [self performSelector:@selector(playOwnAddMusic:) withObject:[sourceMusicArray objectAtIndex:scoreCount] afterDelay:2.0 + timeInterval];
    }
}

-(void)touchEnable
{
    touchDisable = NO;
}

-(void) reScaleImageView:(UIImageView*)imageView
{
    imageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
}

- (void) endFirstAnimation:(UIImageView*) imageView
{
    [imageView stopAnimating];
}

- (IBAction)onPlay:(id)sender {
    
    self.btnPlay.hidden = YES;
    [self stopCurrentPlayer];
    [self performSelector:@selector(nextStage) withObject:nil afterDelay:8.0];
    for (int i = 0; i < sequenceNumber; i++) {
        imageNumber = i;
        NSNumber* index = [NSNumber numberWithInt:i];
        
        [self performSelector:@selector(resultImageSerial:) withObject:index afterDelay:2.0 * i];
        if(resultMusicPlist[i] == YES)
        {
            NSString* fileName = [NSString stringWithFormat:@"%@.mp3",[self.sequenceTitleArray objectAtIndex:i]];
            [self performSelector:@selector(playEffectSound:) withObject:fileName afterDelay:2.0 * i];

        }
        else
            [self performSelector:@selector(playOwnAddMusic:) withObject:[dbSoundName objectAtIndex:i] afterDelay:2.0 * i];
        
    }
}

-(void)resultImageSerial:(NSNumber*)index
{
    
    NSString* path = [self imageFilePath:[index integerValue]];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    if (scaleHeight != 1) {
        
        UIImage *newImage = [self imageWithImage:image scaledToSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
        self.backgroundImageView.image = newImage;
    }
    else
    {
        self.backgroundImageView.image = image;

    }
        
    
}
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);

    [image drawInRect:CGRectMake(0, 0, newSize.width * 5 / 6, newSize.height * 5 / 6)];
    if(scaleHeight != 1)
        [image drawInRect:CGRectMake(0, 0, newSize.width * 5 / 6, newSize.height * 5 / 6)];
     else
         [image drawInRect:CGRectMake(0, 0, newSize.width , newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(void)nextStage
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) saveMyView:(UIView*)theView {
    //The image where the view content is going to be saved.
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(theView.frame.size, YES, 1.0);
    [theView.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData* imgData = UIImagePNGRepresentation(image);
    NSString* targetPath = [NSString stringWithFormat:@"%@/%d%@", [self writablePath],sequenceNumber, @".png" ];
    [imgData writeToFile:targetPath atomically:YES];
}

-(NSString*)imageFilePath:(int) index
{
    NSString* path = [NSString stringWithFormat:@"%@/%d%@",[self writablePath],index,@".png" ];
    return path;
}

-(NSString*) writablePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}
@end
