//
//  ReadData.m
//  LearningWithLenny
//
//  Created by MingHe Jin on 13. 8. 25..
//  Copyright (c) 2013년 JinHong. All rights reserved.
//

#import "ReadData.h"
#define RANDON_TABLECOUNT   10
static ReadData* g_list = nil;



@implementation ReadData

+(ReadData*) getInstance
{
    if(g_list == nil)
    {
        g_list = [[ReadData alloc] init];
        
    }
    return g_list;
}
-(id) init
{
    if(self = [super init])
    {
        NSString* fileName = [[NSBundle mainBundle] pathForResource:@"LearningLearny" ofType:@"plist"];
        
        data = [[NSMutableArray alloc ] initWithContentsOfFile:fileName];
        
        
        NSMutableDictionary* data1 = [[NSMutableDictionary alloc] init];
        data1 = [[NSMutableDictionary alloc ] initWithContentsOfFile:fileName];
        NSLog(@"");

        
    }
    return self;
}

-(NSString*) getSequenceLabelName:(int)index
{
    NSDictionary* itemData= [data objectAtIndex:index];
    NSString* sequenceLabel = [itemData objectForKey:@"Sequence Label"];
    return sequenceLabel;
}
-(NSString*) getMusicName:(int)index
{
    NSDictionary* itemData= [data objectAtIndex:index];
    NSString* sequenceLabel = [itemData objectForKey:@"Sound"];
    return sequenceLabel;
}

-(NSString*) getLabelName:(int)stageIndex getLabelIndex:(int)index
{
    NSDictionary* itemData = [data objectAtIndex:stageIndex];
    NSMutableArray* titleImageData = [[NSMutableArray alloc]initWithCapacity:0];
    titleImageData = [itemData objectForKey:@"Data"];
    NSDictionary* dict = [[NSDictionary alloc]init];
    dict = [titleImageData objectAtIndex:index];
    NSString* imagetitleName = [dict objectForKey:@"title"];
    return imagetitleName;
}
-(NSString*) getImageName:(int) stageIndex getImageName:(int)index
{
    NSDictionary* itemData = [data objectAtIndex:stageIndex];
    NSMutableArray* titleImageData = [[NSMutableArray alloc]initWithCapacity:0];
    titleImageData = [itemData objectForKey:@"Data"];
    NSDictionary* dict = [[NSDictionary alloc]init];
    dict = [titleImageData objectAtIndex:index];
    NSString* imageName = [dict objectForKey:@"imageName"];
    return imageName;
}
-(int) getStringCount:(NSString*)str index:(int)i
{
    NSDictionary* itemData = [data objectAtIndex:i];
    NSMutableArray* item = [itemData objectForKey:str];
    return [item count];

}
-(NSMutableArray*)getFirSecThird
{
    NSMutableArray* returnData = [[NSMutableArray alloc] init];
    NSString* first = @"First";
    NSString* second = @"Second";
    NSString* third = @"Third";
    NSString* fourth =@" Last";
    [returnData addObject:first];
    [returnData addObject:second];
    [returnData addObject:third];
    [returnData addObject:fourth];
    
        return  returnData;
}
-(int)getFactorial:(int)number
{
    if(number <= 0)
    {
        return 1;
    }
    if(number == 1)
        return 1;
    int returnFactorial = 1;
    for(int i = 2; i<= number; i++)
    {
        returnFactorial = returnFactorial * i;
    }
    return returnFactorial;
}

-(int) getMatchCount:(int)index
{
    NSDictionary* itemData = [data objectAtIndex:index];
    NSMutableArray* titleImageData = [[NSMutableArray alloc]initWithCapacity:0];
    titleImageData = [itemData objectForKey:@"Data"];

    return [titleImageData count];

}

-(NSMutableArray*) entireTableSequence:(int)nTableItemNumber
{
    NSMutableArray* returnArray = [[NSMutableArray alloc] initWithCapacity:0];
    int tableSequenceCount = [self getFactorial:nTableItemNumber];
    if(tableSequenceCount > RANDON_TABLECOUNT )
        tableSequenceCount = RANDON_TABLECOUNT;
    for(int i = 0; i < tableSequenceCount; i++)
    {
        NSMutableArray* itemTableSequence = [[NSMutableArray alloc] initWithCapacity:0];
        if(nTableItemNumber == 1)
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:[NSNumber numberWithInt:1]];
            return array;
        }
        itemTableSequence = [self getRandomTableSequence:nTableItemNumber];
        
        [returnArray addObject:itemTableSequence];
    }
    return returnArray;
}
-(NSMutableArray*) getRandomTableSequence:(int)nTableItemNumber
{
    NSMutableArray* returnNumbers = [[NSMutableArray alloc] initWithCapacity:0];
    int nCount = 0;
    BOOL isNumber ;
    while (nCount < nTableItemNumber -1 ) {
        isNumber = NO;
        int itemNumber = arc4random() % nTableItemNumber;
        if([returnNumbers count] == 0)
        {
            [returnNumbers addObject:[NSNumber numberWithInt:itemNumber]];
        }
        else
        {
            
            for(int i = 0; i  < [returnNumbers count]; i++)
            {
                int compareNumber = [[returnNumbers objectAtIndex:i] intValue
                                     ];
                if(itemNumber == compareNumber)
                {
                    isNumber = YES;
                    
                }
                
            }
            if(isNumber == NO)
            {
                [returnNumbers addObject:[NSNumber numberWithInt:itemNumber]];
                nCount++;
            }
            isNumber = NO;
        }
    }
    return returnNumbers;
}
-(BOOL) isPlistData:(NSString*)sequenceLabel
{
    for(int i = 0; i <[data count]; i++)
    {
        NSString* string = [self getSequenceLabelName:i];
        if([sequenceLabel isEqualToString:string])
            return YES;
    }
    return NO;
}
-(int) getDataCount
{
    return [data count];//last item is table randomstring
       
}
- (void)dealloc
{
    [data release];
    [g_list release];
    [super dealloc];
}
@end
