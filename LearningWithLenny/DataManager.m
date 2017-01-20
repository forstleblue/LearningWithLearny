
//
//  DataManager.m
//  LearningWithLenny
//
//  Created by MingHe Jin on 13. 9. 13..
//  Copyright (c) 2013년 JinHong. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager
@synthesize m_IsAlloc;
@synthesize m_DataFilePath;
@synthesize m_Data;

static DataManager *sharedInstance = nil;

#pragma mark methods for database instance
// Get the shared instance and create it if necessary.
+ (DataManager *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

- (id)initWithDatabase:(NSString*)filePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    self.m_Data = [[NSMutableArray alloc] init];
    self.m_DataFilePath = [documentsDirectory stringByAppendingString:filePath];
    
    NSLog(@"%@", m_DataFilePath);
    m_IsAlloc = NO;
    return self;
}

- (void)dealloc
{
    [m_DataFilePath release];
    [super dealloc];
}

-(void) loadDatabase
{
    NSLog(@"%@", m_DataFilePath);
//    self.m_Data = [[NSMutableArray alloc] init];
    self.m_Data = [NSMutableArray arrayWithContentsOfFile:m_DataFilePath];
    
    if (m_Data == nil) {
        m_Data = [[NSMutableArray alloc] initWithCapacity:0];
        m_IsAlloc = YES;
    }
    
}
-(void) addNewProjects:(NSString*)SequenceName  sound:(NSString*)sound  data:(NSArray*)data
{
    NSMutableDictionary *PropertyDict = [NSMutableDictionary dictionary];
    [PropertyDict setObject:SequenceName forKey:FIRST_KEY];
    [PropertyDict setObject:sound forKey:SECOND_KEY];
    [PropertyDict setObject:data forKey:THIRD_KEY];
    
    [self.m_Data addObject:PropertyDict];
    
}
-(void) addNewItem
{
    [[DataManager sharedInstance] updateDatabase];
}
-(void) updateDatabase
{
    NSLog(@"update = %@", m_DataFilePath);
    
   BOOL write = [self.m_Data writeToFile:m_DataFilePath atomically:YES];
    NSLog(@"%d",write);
}

-(void) unloadDatabase
{
    [m_Data removeAllObjects];
    if (m_IsAlloc) {
        [m_Data release];
        m_IsAlloc = NO;
    }
}


@end
