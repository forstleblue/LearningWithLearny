//
//  AddOwnData.m
//  LearningWithLenny
//
//  Created by MingHe Jin on 13. 9. 16..
//  Copyright (c) 2013년 JinHong. All rights reserved.
//

#import "AddOwnData.h"
AddOwnData* sharedAddDataInstance = nil;
@implementation AddOwnData
@synthesize firstLabel,secondLabel,thirdLabel, fourthLabel;
@synthesize sequenceTitleOne;

+(AddOwnData*)sharedAddData
{
    if(sharedAddDataInstance == nil)
    {
        sharedAddDataInstance = [[AddOwnData alloc] init];
        
    }
    return sharedAddDataInstance;
}
-(id) init
{
    self = [super init];
    self.firstLabel = @"";
    
    self.secondLabel = @"";
    self.fourthLabel = @"";
    
    self.thirdLabel = @"";
    self.sequenceTitleOne  = @"";
    
    self.sequenceText = NO;
    
    
    self.firstVoice = NO;
    self.secondVoice = NO;
    self.thirdVoice = NO;
    self.fourthVoice = NO;
    self.fifthVoice = NO;
    
    self.saveVoiceId = -1;
    return self;
}
@end
