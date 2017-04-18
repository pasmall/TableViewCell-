//
//  ViewController.m
//  TableViewMenu
//
//  Created by lyric on 2017/4/17.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import "CellExpansionViewController.h"
#import "MainTableViewCell.h"
#import "OperateTableViewCell.h"
#import "ItemModel.h"

#define CellCount 20
#define ExpandCount 1 //目前是1行操作的cell.可加多或者删除多个。


@interface CellExpansionViewController  ()<UITableViewDataSource,UITableViewDelegate,OperateTableViewCellDelegate>

@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)NSMutableArray *dataArray;

@property (assign, nonatomic) BOOL isExpand; //是否展开
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;//展开的cell的下标


@end

@implementation CellExpansionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"tableView分组展开";
    [self.view addSubview:self.tableView];
    
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource =self;
        [_tableView registerClass:[MainTableViewCell class] forCellReuseIdentifier:@"main"];
        [_tableView registerClass:[OperateTableViewCell class] forCellReuseIdentifier:@"operate"];
        
    }
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:CellCount];
        for (int i = 0; i < CellCount ; i ++ ) {
            
            [_dataArray addObject:[[ItemModel alloc]initWithID:i andTitle:[NSString stringWithFormat:@"文件 %d",i]]];
        }
    }
    return _dataArray;
    
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isExpand && self.selectedIndexPath.section == section) {
        return 1 + ExpandCount; 
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.isExpand && self.selectedIndexPath.section  == indexPath.section && indexPath.row != 0) {
       OperateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"operate" forIndexPath:indexPath];
        ItemModel *model = self.dataArray[self.selectedIndexPath.section];
        [cell setItemModel:model];
        cell.delegate = self;
        return cell;
    } else {
        ItemModel *model = self.dataArray[indexPath.section];
       MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"main" forIndexPath:indexPath];
        cell.textLabel.text = model.title;
        return cell;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isExpand && self.selectedIndexPath.section == indexPath.section && indexPath.row != 0) {
        return 87;
    } else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.selectedIndexPath) {
        self.isExpand = YES;
        self.selectedIndexPath = indexPath;
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:[self indexPathsForExpandSection:indexPath.section] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    } else {
        if (self.isExpand) {
            if (self.selectedIndexPath == indexPath) {
                self.isExpand = NO;
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:[self indexPathsForExpandSection:indexPath.section] withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];
                self.selectedIndexPath = nil;
            } else if (self.selectedIndexPath.row != indexPath.row && indexPath.section <= self.selectedIndexPath.section) {
                
            } else {
                self.isExpand = NO;
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:[self indexPathsForExpandSection:self.selectedIndexPath.section] withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];
                self.selectedIndexPath = nil;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.isExpand = YES;
                    self.selectedIndexPath = indexPath;
                    [self.tableView beginUpdates];
                    [self.tableView insertRowsAtIndexPaths:[self indexPathsForExpandSection:indexPath.section] withRowAnimation:UITableViewRowAnimationTop];
                    [self.tableView endUpdates];
                });
                
            }
        }
    }
}



- (NSArray *)indexPathsForExpandSection:(NSInteger)section
{
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int i = 1; i <= ExpandCount; i++) {
        NSIndexPath *idxPth = [NSIndexPath indexPathForRow:i inSection:section];
        [indexPaths addObject:idxPth];
    }
    return [indexPaths copy];
}

- (void)didSelectItem:(NSInteger)index andModel:(ItemModel *)model
{
    
    switch (index) {
        case TapTypeOne:{
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *tipAlertController = [UIAlertController alertControllerWithTitle:@"重命名"  message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *OkAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    UITextField *userEmail = tipAlertController.textFields.firstObject;
                    ItemModel *model = self.dataArray[self.selectedIndexPath.section];
                    model.title = userEmail.text;
                    NSIndexSet *set = [[NSIndexSet alloc]initWithIndex:self.selectedIndexPath.section ];
                    NSLog(@"%ld" , (long)self.selectedIndexPath.section );
                    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                    
                }];
                UIAlertAction *cancelAlertAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [tipAlertController addAction:OkAction];
                [tipAlertController addAction:cancelAlertAction];
                [tipAlertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    
                }];
                
                [self presentViewController:tipAlertController animated:YES completion:nil];
            });
            
            
        }
            
            break;
        case TapTypeTwo:{
            self.isExpand = NO;
            
            NSIndexPath *idxPth = [NSIndexPath indexPathForRow:1 inSection:self.selectedIndexPath.section];
            
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[idxPth] withRowAnimation:UITableViewRowAnimationRight];
            NSIndexSet *set = [[NSIndexSet alloc]initWithIndex:self.selectedIndexPath.section];
            
            [self.tableView deleteSections:set withRowAnimation:UITableViewRowAnimationRight];
            [self.dataArray removeObjectAtIndex:self.selectedIndexPath.section];
            [self.tableView endUpdates];
            
            self.selectedIndexPath = nil;
            
        }
            
            break;
            
        default:
            break;
    }
    
}








@end
