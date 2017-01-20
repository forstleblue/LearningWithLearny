//
//  NameConstant.h
//  LearningWithLenny
//
//  Created by MingHe Jin on 13. 8. 25..
//  Copyright (c) 2013년 JinHong. All rights reserved.
//

#ifndef LearningWithLenny_NameConstant_h
#define LearningWithLenny_NameConstant_h

#define FirstCell   @"first"
#define SecondCell  @"second"
#define ThirdCell   @"third"// question
#define  RandomSwitch       @"RandomSwitch"
#define     RandomNumber    @"RandomNumber"
#define CellNumber          @"CellNo"
#define FIRST_START         @"firstStart"
#define SuccessSoundKey     @"successSound"
#define UnSuccessSoundKey   @"unsuccessSound"
#define MusicKey            @"music"
#define FirSecKey           @"firSec"
#define WrittenKey          @"written"
#define SpokenKey           @"spoken"
#define FourPicKey          @"fourPic"
#define ThreePicKey         @"threePic"
#define TeachKey            @"teach"
#define BACKGROUND_MUSIC        @"background.mp3"
#define TRUE_SLIDE1         @"Yeah.mp3"
#define TRUE_SLIDE2         @"Yeah.mp3"
#define FIRST_SOUND         @"first.mp3"
#define SECOND_SOUND        @"second.mp3"
#define THIRD_SOUND         @"third.mp3"
#define LAST_SOUND          @"last.mp3"
#define FALSE_SLIDE1        @"Try again.mp3"
#define FALSE_SLIDE2        @"Try again.mp3"
#define FIRST_KEY           @"Sequence Label"
#define SECOND_KEY          @"Sound"
#define THIRD_KEY           @"Data"
#define SUB_KEY1            @"title"
#define SUB_KEY2            @"imageName"
#define SUB_KEY3            @"titleSound"
#define DATABASE_FILE_PATH @"/DatabaseFile.DB"
#define RECORD_NUMBER       @"RecordNumber"
#define SELECTED_COUNT      @"selectedCount"
#define APPLAUSE            @"applause.mpe"

#define TABLECOUNT          3
#define IPAD_WIDTH          1024
#define IPAD_HEIGHT         768
#define IPHONE_WIDTH        480
#define IPHONE_HEIGHT       320
#define RATE_WIDTH          (float)IPAD_WIDTH/IPHONE_WIDTH
#define RATE_HEIGHT         (float)IPAD_HEIGHT/IPHONE_HEIGHT

#define R_WIDTH	({ UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 1 : RATE_WIDTH;})

#define R_HEIGHT	({ UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 1 : RATE_HEIGHT;})
#endif
