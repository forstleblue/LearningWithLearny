//
//  LWLSViewController.m
//  LearningWithLenny
//
//  Created by snow on 7/25/13.
//  Copyright (c) 2013 JinHong. All rights reserved.
//

#import "LWLSViewController.h"
#import "HowToUseViewController.h"
#import "SettingsViewController.h"
#import "ListOfSequencesViewController.h"
#import "SequenceViewController.h"
@interface LWLSViewController ()

@end

@implementation LWLSViewController

- (void)dealloc
{
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button actions
- (IBAction)clickHowToUseButton:(id)sender
{
    HowToUseViewController *howToUseViewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        howToUseViewController = [[[HowToUseViewController alloc]
                                   initWithNibName:@"HowToUseViewController_iPad" bundle:nil] autorelease];
    else
        howToUseViewController = [[[HowToUseViewController alloc]
                                   initWithNibName:@"HowToUseViewController_iPhone" bundle:nil] autorelease];
    [self.navigationController pushViewController:howToUseViewController animated:YES];
}

- (IBAction)clickSettingsButton:(id)sender
{
    SettingsViewController *settingsViewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        settingsViewController = [[[SettingsViewController alloc]
                                   initWithNibName:@"SettingsViewController_iPad" bundle:nil] autorelease];
    else
        settingsViewController = [[[SettingsViewController alloc]
                                   initWithNibName:@"SettingsViewController_iPhone" bundle:nil] autorelease];
    [self.navigationController pushViewController:settingsViewController animated:YES];
}

- (IBAction)clickListOfSequencesButton:(id)sender
{
    ListOfSequencesViewController *listOfSequecesViewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        listOfSequecesViewController = [[[ListOfSequencesViewController alloc]
                                   initWithNibName:@"ListOfSequencesViewController_iPad" bundle:nil] autorelease];
    else
        listOfSequecesViewController = [[[ListOfSequencesViewController alloc]
                                   initWithNibName:@"ListOfSequencesViewController_iPhone" bundle:nil] autorelease];
    [self.navigationController pushViewController:listOfSequecesViewController animated:YES];
}

- (IBAction)clickGoButton:(id)sender
{
    SequenceViewController *sequeceViewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        sequeceViewController = [[[SequenceViewController alloc]
                                         initWithNibName:@"SequenceViewController_iPad" bundle:nil] autorelease];
    else
        sequeceViewController = [[[SequenceViewController alloc]
                                         initWithNibName:@"SequenceViewController_iPhone" bundle:nil] autorelease];
    [self.navigationController pushViewController:sequeceViewController animated:YES];
}

//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
//
//-(NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscapeRight;
//}

//-(BOOL)shouldAutorotate
//{
//    return YES;
//}
//
//-(NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscapeLeft;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationLandscapeRight;
//}

//- (NSUInteger)supportedInterfaceOrientations {
//    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft |
//            UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortraitUpsideDown);
//}

@end
