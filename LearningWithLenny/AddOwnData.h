//
//  AddOwnData.h
//  LearningWithLenny
//
//  Created by MingHe Jin on 13. 9. 16..
//  Copyright (c) 2013년 JinHong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddOwnData : NSObject
@property (nonatomic, retain) NSString* firstLabel;
@property (nonatomic, retain) NSString* secondLabel;
@property (nonatomic, retain) NSString* thirdLabel;
@property (nonatomic, retain) NSString* fourthLabel;
@property (nonatomic, retain) NSString* sequenceTitleOne;
//@property (nonatomic, retain) NSString* sequenceTitleTwo;
//@property (nonatomic, retain) NSString* sequenceTitleThree;
//@property (nonatomic, retain) NSString* sequenceTitleFour;

@property (assign) int addText;
@property (assign) int sequenceLabelId;
@property (assign) int saveVoiceId;

@property (assign) BOOL sequenceText;

@property (assign) BOOL firstVoice;
@property (assign) BOOL secondVoice;
@property (assign) BOOL thirdVoice;
@property (assign) BOOL fourthVoice;
@property (assign) BOOL fifthVoice;

+(AddOwnData*)sharedAddData;

@end
