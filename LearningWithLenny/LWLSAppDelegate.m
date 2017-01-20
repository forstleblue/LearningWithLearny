//
//  LWLSAppDelegate.m
//  LearningWithLenny
//
//  Created by snow on 7/25/13.
//  Copyright (c) 2013 JinHong. All rights reserved.
//

#import "LWLSAppDelegate.h"
#import "LWLSViewController.h"
#import "NameConstant.h"
#import "ReadData.h"
#import "DataManager.h"
#import "CustomNavigationController.h"
@implementation LWLSAppDelegate
@synthesize globalTableSequence;
@synthesize sequenceNumber;
@synthesize window;

- (void)dealloc
{
    [window release];
    [super dealloc];
}
- (void)setingSwitchData
{
    self.pointer = [[ReadData alloc] init];
    int nTableItemCount = [self.pointer getDataCount];

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    BOOL firstStart = [defaults boolForKey:FIRST_START];
    if(firstStart == NO)
    {
        [defaults setBool:YES forKey:SuccessSoundKey];
        [defaults setBool:YES forKey:UnSuccessSoundKey];
        [defaults setBool:YES forKey:MusicKey];
        [defaults setBool:YES forKey:WrittenKey];
        [defaults setBool:YES forKey:ThreePicKey];
        [defaults setBool:YES forKey:FourPicKey];
        [defaults setBool:YES forKey:SpokenKey];
        [defaults setBool:YES forKey:SpokenKey];
        [defaults setBool:YES forKey:ThreePicKey];
        [defaults setBool:YES forKey:FirSecKey];
        for(int i = 0; i < nTableItemCount; i++)
        {
           [defaults setBool:YES forKey:[NSString stringWithFormat:@"%@%d",CellNumber,i]];

        }
        [defaults setBool:YES forKey:FIRST_START];
    }
    [[DataManager sharedInstance] initWithDatabase:DATABASE_FILE_PATH];
    [[DataManager sharedInstance] loadDatabase];
    
    self.sequenceTitle = [[NSMutableArray alloc] init];
    self.tableArray = [[NSMutableArray alloc] initWithCapacity:0];
    int dataCount = [self.pointer getDataCount];
    
    
    BOOL threePic = [defaults boolForKey:ThreePicKey];
    BOOL fourPic = [defaults boolForKey:FourPicKey];
    if(threePic == YES)
    {
        for(int i = 0 ; i < dataCount ; i++)
        {
            
            NSString* sequenceLabel = [self.pointer getSequenceLabelName:i];
            
            [self.sequenceTitle addObject:sequenceLabel];
        }
        
    }
    NSMutableArray* anotherData = [[NSMutableArray alloc] init];
    anotherData =[[DataManager sharedInstance] m_Data];
    for(int i = 0; i < [anotherData count]; i++)
    {
        NSMutableDictionary* dict = [anotherData objectAtIndex:i];
        NSMutableArray* item = [dict objectForKey:THIRD_KEY];
        NSString* sequenceLabel = [dict objectForKey:FIRST_KEY];
        int imageCount = [item count];
        if(imageCount == 3)
        {
            if(threePic == YES)
                [self.sequenceTitle  addObject:sequenceLabel];
            
        }
        if(imageCount == 4)
        {
            if(fourPic == YES)
            {
                [self.sequenceTitle  addObject:sequenceLabel];
                
            }
        }
    }

    self.totalCount = [self.sequenceTitle count];

    BOOL cellState[self.totalCount];
    int selecteItemCount = 0;;
    for (int i = 0; i < self.totalCount; i++) {
        cellState[i] = [defaults boolForKey:[NSString stringWithFormat:@"%@%d",CellNumber,i]];
        if(cellState[i] == YES)
        {
            selecteItemCount++;
        }
    }
    [defaults setInteger:selecteItemCount forKey:SELECTED_COUNT];


    self.musicOn = [defaults boolForKey:MusicKey];
    self.globalTableSequence = [[NSMutableArray alloc] init];
    
    self.globalTableSequence = [self.pointer entireTableSequence:self.totalCount];
    [self loadBackgroundMusic];
    self.sequenceNumber = [[NSMutableArray alloc] initWithCapacity:0];
    [self loadEffectSound];
    self.sequenceNumber = [[NSMutableArray alloc] init];
    
    self.sequenceNumber = [self.pointer entireTableSequence:3];
    
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *documentsDirectoryPath = [paths objectAtIndex:0];
//	NSString *databaseFile = [documentsDirectoryPath stringByAppendingPathComponent:@"/DatabaseFile.DB"];	
//	NSFileManager *fileManager = [NSFileManager defaultManager];
//	[fileManager removeItemAtPath:databaseFile error:NULL];

    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Initialize LWLSViewController
    LWLSViewController *lwlsViewController;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        lwlsViewController = [[[LWLSViewController alloc]
                               initWithNibName:@"LWLSViewController_iPad" bundle:nil] autorelease];
    else
        lwlsViewController = [[[LWLSViewController alloc]
                               initWithNibName:@"LWLSViewController_iPhone" bundle:nil] autorelease];
    

    UINavigationController *navigationController = [[[CustomNavigationController alloc]
                                                     initWithRootViewController:lwlsViewController] autorelease];
    [self.window setRootViewController:navigationController];
    [self.window makeKeyAndVisible];
    
    [self setingSwitchData];

    return YES;
}
-(void)loadBackgroundMusic
{
    NSString* _backgroundMusic = @"background.mp3";
    NSString* _url = [[NSBundle mainBundle] pathForResource:[_backgroundMusic substringToIndex:[_backgroundMusic length]-4] ofType:@"mp3"];
    NSURL *_fileURL = [[NSURL alloc] initFileURLWithPath:_url];
    
    _musicPlayer = [[CustomAudioPlayer alloc] initWithURL:_fileURL];
    
    [_fileURL release];
    
}
-(void)playSequenceSound:(int)index
{
    if (sequenceSound[index] != nil) {
        [sequenceSound[index] stop];
    }
    if (sequenceSound[index] == nil) {
        return;
    }
    [sequenceSound[index] setNumberOfLoops:0];
    [sequenceSound[index] prepareToPlay];
    [sequenceSound[index] play];
}
-(void)playSequenceWord:(int)index
{
    if (sequencePlayer[index]!=nil) {
        [sequencePlayer[index] stop];
    }
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    self.playSequence = [defaults boolForKey:SpokenKey];
    if (self.playSequence ==NO)
        return;
    
    // parse background music filename
    if (sequencePlayer[index]==nil)
        return;
    
    [sequencePlayer[index] setNumberOfLoops:0];
    [sequencePlayer[index] prepareToPlay];
    [sequencePlayer[index] play];
}
-(void)playSuccessSound:(int)index
{
    if (successSound[index]!=nil) {
        [successSound[index] stop];
        //        [effectPlayer release]; effectPlayer=nil;
    }
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    self.playSuccess = [defaults boolForKey:SuccessSoundKey];
    if (self.playSuccess==NO)
        return;
    
    // parse background music filename
    
    if (successSound[index]==nil)
        return;
    
    [successSound[index] setNumberOfLoops:0];
    [successSound[index] prepareToPlay];
    [successSound[index] play];
    
}
-(void)playUnsuccessSound:(int)index
{
    if (unsuccessSound[index]!=nil) {
        [unsuccessSound[index] stop];
        
    }
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    self.playUnsuccess = [defaults boolForKey:UnSuccessSoundKey];
    if (self.playUnsuccess==NO)
        return;
    
    if (unsuccessSound[index]==nil)
        return;
    
    [unsuccessSound[index] setNumberOfLoops:0];
    [unsuccessSound[index] prepareToPlay];
    [unsuccessSound[index] play];
    
}

-(void)stopBackgroundMusic
{
    if (_musicPlayer!=nil) {
        [_musicPlayer stop];

//        [_musicPlayer release]; _musicPlayer=nil;
    }
}
-(void) loadEffectSound
{
    for (int i = 0; i < [self.pointer getDataCount]; i++) {
        NSString* _backgroundMusic = [self.pointer getMusicName:i];
        NSString* _url = [[NSBundle mainBundle] pathForResource:[_backgroundMusic substringToIndex:[_backgroundMusic length]-4] ofType:@"mp3"];
        NSURL *_fileURL = [[NSURL alloc] initFileURLWithPath:_url];
        
        sequencePlayer[i] = [[CustomAudioPlayer alloc] initWithURL:_fileURL];
        [_fileURL release];
        
    }
    NSString* _url = [[NSBundle mainBundle] pathForResource:[TRUE_SLIDE1 substringToIndex:[TRUE_SLIDE1 length]-4] ofType:@"mp3"];
    NSURL *_fileURL = [[NSURL alloc] initFileURLWithPath:_url];
    
    successSound[0] = [[CustomAudioPlayer alloc] initWithURL:_fileURL];
    [_fileURL release];
    
    
    _url = [[NSBundle mainBundle] pathForResource:[TRUE_SLIDE2 substringToIndex:[TRUE_SLIDE2 length]-4] ofType:@"mp3"];
    _fileURL = [[NSURL alloc] initFileURLWithPath:_url];
    
    successSound[1] = [[CustomAudioPlayer alloc] initWithURL:_fileURL];
    [_fileURL release];
    
    
    
    _url = [[NSBundle mainBundle] pathForResource:[FALSE_SLIDE1 substringToIndex:[FALSE_SLIDE1 length]-4] ofType:@"mp3"];
    _fileURL = [[NSURL alloc] initFileURLWithPath:_url];
    
    unsuccessSound[0] = [[CustomAudioPlayer alloc] initWithURL:_fileURL];
    [_fileURL release];
    
    
    _url = [[NSBundle mainBundle] pathForResource:[FALSE_SLIDE2 substringToIndex:[FALSE_SLIDE2 length]-4] ofType:@"mp3"];
    _fileURL = [[NSURL alloc] initFileURLWithPath:_url];
    
    unsuccessSound[1] = [[CustomAudioPlayer alloc] initWithURL:_fileURL];
    [_fileURL release];
    
    
    
    _url = [[NSBundle mainBundle] pathForResource:[SECOND_SOUND substringToIndex:[SECOND_SOUND length]-4] ofType:@"mp3"];
    _fileURL = [[NSURL alloc] initFileURLWithPath:_url];
   
    sequenceSound[1] = [[CustomAudioPlayer alloc] initWithURL:_fileURL];
    [_fileURL release];
    
        [_fileURL release];
    _url = [[NSBundle mainBundle] pathForResource:[THIRD_SOUND substringToIndex:[THIRD_SOUND length]-4] ofType:@"mp3"];
    _fileURL = [[NSURL alloc] initFileURLWithPath:_url];
    sequenceSound[2] = [[CustomAudioPlayer alloc] initWithURL:_fileURL];

        [_fileURL release];
    _url = [[NSBundle mainBundle] pathForResource:[LAST_SOUND substringToIndex:[LAST_SOUND length]-4] ofType:@"mp3"];
    _fileURL = [[NSURL alloc] initFileURLWithPath:_url];
    sequenceSound[3] = [[CustomAudioPlayer alloc] initWithURL:_fileURL];

    
    [_fileURL release];
 
    _url = [[NSBundle mainBundle] pathForResource:[FIRST_SOUND substringToIndex:[FIRST_SOUND length]-4] ofType:@"mp3"];
    _fileURL = [[NSURL alloc] initFileURLWithPath:_url];
       sequenceSound[0] = [[CustomAudioPlayer alloc] initWithURL:_fileURL];
    
       [_fileURL release];


    
    
}

-(void)playBackgroundMusic
{
    if (_musicPlayer!=nil) {
        [_musicPlayer stop];
    }
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    self.musicOn = [defaults boolForKey:MusicKey];
    if (self.musicOn==NO)
        return;
    
      
    if (_musicPlayer==nil)
        return;
    
    [_musicPlayer setNumberOfLoops:-1];
    [_musicPlayer prepareToPlay];
    
    [_musicPlayer play];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

//- (NSUInteger)supportedInterfaceOrientations {
//    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft |
//            UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortraitUpsideDown);
//}
//
//
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    if (interfaceOrientation==UIInterfaceOrientationPortrait)
//    {
//        return YES;
//    }
//    return NO;
//}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
