//
//  ReadData.h
//  LearningWithLenny
//
//  Created by MingHe Jin on 13. 8. 25..
//  Copyright (c) 2013년 JinHong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadData : NSObject
{
    NSMutableArray* data;
}



+(ReadData*) getInstance;
-(NSString*) getSequenceLabelName:(int)index;
-(NSString*) getLabelName:(int)stageIndex getLabelIndex:(int)index;
-(int) getDataCount;
-(NSString*) getImageName:(int) stageIndex getImageName:(int)index;
-(int) getStringCount:(NSString*)str index:(int)i;
-(NSMutableArray*)getSequenceNumber;

-(NSMutableArray*)getFirSecThird;
-(NSString*) getMusicName:(int)index;
-(NSMutableArray*) getRandomTableSequence:(int)nTableItemNumber;
-(int)getFactorial:(int)number;
-(NSMutableArray*) entireTableSequence:(int)nTableItemNumber;
-(int) getMatchCount:(int)index;
-(BOOL) isPlistData:(NSString*)sequenceLabel;
-(id) init;
@end
