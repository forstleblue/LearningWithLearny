//
//  SettingsViewController.h
//  LearningWithLenny
//
//  Created by snow on 7/25/13.
//  Copyright (c) 2013 JinHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWLSAppDelegate.h"
#import "ReadData.h"
@interface SettingsViewController : UIViewController
{
    float scaleWidth;
    float scaleHeight;
    ReadData* pointer;
    LWLSAppDelegate* appDelegate;
}
@property (retain, nonatomic) ReadData* pointer;
@property (retain, nonatomic) IBOutlet UIScrollView *backgroundScrollView;
@property (retain, nonatomic) IBOutlet UISwitch *onSuccessSound;
@property (retain, nonatomic) IBOutlet UISwitch *onUnsuccessSound;
@property (retain, nonatomic) IBOutlet UISwitch *onMusic;
@property (retain, nonatomic) IBOutlet UISwitch *onTeach;
@property (retain, nonatomic) IBOutlet UISwitch *onWritten;
@property (retain, nonatomic) IBOutlet UISwitch *onSpoken;
@property (retain, nonatomic) IBOutlet UISwitch *onFirSecThird;
@property (retain, nonatomic) IBOutlet UISwitch *onThreePic;
@property (retain, nonatomic) IBOutlet UISwitch *onFourPic;

- (IBAction)clickHomeButton:(id)sender;
- (IBAction)clickMusic:(id)sender;
- (IBAction)onListOfSequence:(id)sender;
- (IBAction)onGo:(id)sender;
- (IBAction)switchFourPic:(id)sender;

@end
