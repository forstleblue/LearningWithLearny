//
//  DataManager.h
//  LearningWithLenny
//
//  Created by MingHe Jin on 13. 9. 13..
//  Copyright (c) 2013년 JinHong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NameConstant.h"
@interface DataManager : NSObject
{
    BOOL m_IsAlloc;
    NSString* m_DataFilePath;
    NSMutableArray* m_Data;
}

@property(nonatomic, assign) BOOL m_IsAlloc;
@property(nonatomic, retain) NSString* m_DataFilePath;
@property(nonatomic, retain) NSMutableArray* m_Data;

+ (DataManager *)sharedInstance;
- (id)  initWithDatabase:(NSString*)filePath;
- (void) loadDatabase;
- (void) updateDatabase;
- (void) unloadDatabase;
-(void) addNewProjects:(NSString*)SequenceName  sound:(NSString*)sound  data:(NSArray*)data;
-(void) addNewItem;

@end
