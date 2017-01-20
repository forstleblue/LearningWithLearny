//
//  SettingsViewController.m
//  LearningWithLenny
//
//  Created by snow on 7/25/13.
//  Copyright (c) 2013 JinHong. All rights reserved.
//

#import "SettingsViewController.h"
#import "ListOfSequencesViewController.h"
#import "HowToUseViewController.h"
#import "SequenceViewController.h"
#import "NameConstant.h"
@interface SettingsViewController ()

@end

@interface UIScrollView(Custom)
@end
@implementation UIScrollView(Custom)

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}
@end
@implementation SettingsViewController
@synthesize pointer;
@synthesize backgroundScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        appDelegate  = [UIApplication sharedApplication].delegate;
        self.pointer = [[ReadData alloc] init];
        
    }
    return self;
}

- (void)dealloc
{
    [backgroundScrollView release];
    
    [_onSuccessSound release];
    [_onUnsuccessSound release];
    [_onMusic release];
    [_onTeach release];
    [_onWritten release];
    [_onSpoken release];
    [_onFirSecThird release];
    [_onThreePic release];
    [_onFourPic release];
    [super dealloc];
}
- (void)setSwitch
{
    BOOL state;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    state = [defaults boolForKey:SuccessSoundKey];
    [self.onSuccessSound setOn:state];
    
    state = [defaults boolForKey:UnSuccessSoundKey];
    [self.onUnsuccessSound setOn:state];
    
    state = [defaults boolForKey:MusicKey];
    [self.onMusic setOn:state];
    
    state = [defaults boolForKey:WrittenKey];
    [self.onWritten setOn:state];
    
    state = [defaults boolForKey:SpokenKey];
    [self.onSpoken setOn:state];
    
    state = [defaults boolForKey:FirSecKey];
    [self.onFirSecThird setOn:state];
    
    state = [defaults boolForKey:FourPicKey];
    [self.onFourPic setOn:state];
    state = [defaults boolForKey:ThreePicKey];
    [self.onThreePic setOn:state];
    
    state = [defaults boolForKey:TeachKey];
    [self.onTeach setOn:state];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.backgroundScrollView.scrollEnabled = YES;
//     self.backgroundScrollView.delegate = self;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        scaleWidth = 1;
        scaleHeight = 1;
        self.backgroundScrollView.contentSize = CGSizeMake(320 , 650);

    }
    else
        
    {
        scaleHeight = RATE_HEIGHT;
        scaleWidth = RATE_WIDTH;
        self.backgroundScrollView.contentSize = CGSizeMake(320 * scaleWidth, 700 * (scaleHeight - .5));

    }
            [self setSwitch];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void) saveData
{
    BOOL state ;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    state = [self.onSuccessSound isOn] ? YES :NO;
    [defaults setBool:state forKey:SuccessSoundKey];
        
    state = [self.onUnsuccessSound isOn] ? YES :NO;
    [defaults setBool:state forKey:UnSuccessSoundKey];
    
    state = [self.onMusic isOn] ? YES :NO;
    [defaults setBool:state forKey:MusicKey];
        
    
    state = [self.onTeach isOn] ? YES :NO;
    [defaults setBool:state forKey:TeachKey];
        
    state = [self.onWritten isOn] ? YES :NO;
    [defaults setBool:state forKey:WrittenKey];
        
    state = [self.onFirSecThird isOn] ? YES :NO;
    [defaults setBool:state forKey:FirSecKey];
   
    
    state = [self.onSpoken isOn] ? YES :NO;
    [defaults setBool:state forKey:SpokenKey];
        
    state = [self.onFourPic isOn] ? YES :NO;
    [defaults setBool:state forKey:FourPicKey];
        
    state = [self.onThreePic isOn] ? YES :NO;
    [defaults setBool:state forKey:ThreePicKey];
        
    [defaults synchronize];
    
    appDelegate.sequenceTitle = [[NSMutableArray alloc] init];
    BOOL threePic = [defaults boolForKey:ThreePicKey];
    BOOL fourPic = [defaults boolForKey:FourPicKey];
    int dataCount = [self.pointer getDataCount];
    if(threePic == YES)
    {
        for(int i = 0 ; i < dataCount ; i++)
        {
            
            NSString* sequenceLabel = [self.pointer getSequenceLabelName:i];
            
            [appDelegate.sequenceTitle addObject:sequenceLabel];
        }
    }
        
    NSMutableArray* anotherData =[[DataManager sharedInstance] m_Data];
    for(int i = 0; i < [anotherData count]; i++)
    {
        NSMutableDictionary* dict = [anotherData objectAtIndex:i];
        NSMutableArray* item = [dict objectForKey:THIRD_KEY];
        NSString* sequenceLabel = [dict objectForKey:FIRST_KEY];
        int imageCount = [item count];
        if(imageCount == 3)
        {
            if(threePic == YES)
                [appDelegate.sequenceTitle  addObject:sequenceLabel];
        }
        if(imageCount == 4)
        {
            if(fourPic == YES)
                [appDelegate.sequenceTitle  addObject:sequenceLabel];
        }
    }
    
    int totalCount = [appDelegate.sequenceTitle count];
    if(totalCount != appDelegate.totalCount)
    {
        appDelegate.totalCount = totalCount;
        appDelegate.globalTableSequence = [self.pointer entireTableSequence:totalCount];
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
    [self saveData];
    if ([self selectThreeFour] == YES) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Message" message: @"You must select Three picture or Four picture Item" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickMusic:(id)sender {
    BOOL musicState = [self.onMusic isOn];

    NSUserDefaults* defaults = [ NSUserDefaults standardUserDefaults];
    [defaults setBool:musicState forKey:MusicKey];
//    [appdelegate playBackgroundMusic];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

- (IBAction)switchFourPic:(id)sender {
    UISwitch* swtichePic = (UISwitch*)sender;
    
    if(swtichePic.isOn == NO)
    {
        [self.onThreePic setOn: YES];
    }
}

- (IBAction)onListOfSequence:(id)sender {
    [self saveData];
    if ([self selectThreeFour] == YES) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Message" message: @"You must select Three picture or Four picture Item" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    UINavigationController* nav = self.navigationController;
    ListOfSequencesViewController* viewController;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        viewController = [[ListOfSequencesViewController alloc] initWithNibName:@"ListOfSequencesViewController_iPhone" bundle:nil];
    else
        viewController = [[ListOfSequencesViewController alloc] initWithNibName:@"ListOfSequencesViewController_iPad" bundle:nil];
    [nav popToRootViewControllerAnimated:NO];
    [nav pushViewController:viewController animated:YES];
}

- (IBAction)onGo:(id)sender {
    [self saveData];
    if ([self selectThreeFour] == YES) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Message" message: @"You must select Three picture or Four picture Item" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    UINavigationController* nav = self.navigationController;
    SequenceViewController* viewController;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        viewController = [[SequenceViewController alloc] initWithNibName:@"SequenceViewController_iPhone" bundle:nil];
    else
        viewController = [[SequenceViewController alloc] initWithNibName:@"SequenceViewController_iPad" bundle:nil];
    [nav popToRootViewControllerAnimated:NO];
    [nav pushViewController:viewController animated:YES];
}

- (BOOL) selectThreeFour
{
    BOOL selThree = [self.onThreePic isOn];
    BOOL selFour = [self.onFourPic isOn];
    if(selThree == NO && selFour == NO)
    {
        return YES;
    }
    return NO;
}

- (void)viewDidUnload {
    [self setOnSuccessSound:nil];
    [self setOnUnsuccessSound:nil];
    [self setOnMusic:nil];
    [self setOnTeach:nil];
    [self setOnWritten:nil];
    [self setOnSpoken:nil];
    [self setOnFirSecThird:nil];
    [self setOnThreePic:nil];
    [self setOnFourPic:nil];
    [super viewDidUnload];
}

@end
