//
//  CustomNavigationController.m
//  LearningWithLenny
//
//  Created by snow on 10/9/13.
//  Copyright (c) 2013 JinHong. All rights reserved.
//

#import "CustomNavigationController.h"

@implementation CustomNavigationController

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationLandscapeRight;
//}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationPortraitUpsideDown;
}

@end
