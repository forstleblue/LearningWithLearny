//
//  ListOfSequencesViewController.h
//  LearningWithLenny
//
//  Created by snow on 7/25/13.
//  Copyright (c) 2013 JinHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadData.h"
#import "NameConstant.h"
#import "DataManager.h"
@interface ListOfSequencesViewController : UIViewController<UITableViewDelegate,
UITableViewDataSource>
{
    NSMutableArray *sequenceListArray;
    NSMutableArray *selectStatusArray;
    NSMutableArray* anotherData;

    ReadData* pointer;
    int totalCount;
    int preTableCount;
    int selectCount;
    int randomNumber;
    int beforeRandonNumber;
    BOOL deselectAllData;
}

@property (nonatomic, retain) IBOutlet UITableView *sequencesTableView;
@property (nonatomic, retain) IBOutlet UIScrollView *backgroundScrollView;
@property (nonatomic, retain) IBOutlet UISwitch *randomSwitch;
@property (nonatomic, retain) IBOutlet UIButton *homeButton;
@property (nonatomic, retain) IBOutlet UIButton *addOwnButton;
@property (nonatomic, retain) IBOutlet UIButton *onSettingButton;

@property (nonatomic, retain) NSMutableArray* tableSequece;
@property (nonatomic, retain) NSMutableArray* tableRandomArray;
@property (nonatomic, retain) ReadData* pointer;
@property (nonatomic, retain) NSMutableArray *sequenceListArray;
@property (nonatomic, retain) NSMutableArray *selectStatusArray;

- (IBAction)randomSwitch:(id)sender;
- (IBAction)clickHomeButton:(id)sender;
- (IBAction)selectAllSequences:(id)sender;
- (IBAction)deselectAllSequences:(id)sender;
- (IBAction)onSetting:(id)sender;
- (IBAction)addOwnSequence:(id)sender;


@end
