//
//  CellInsertViewController.m
//  TableViewMenu
//
//  Created by lyric on 2017/4/18.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import "CellInsertViewController.h"
#import "MainTableViewCell.h"
#import "OperateTableViewCell.h"
#import "ItemModel.h"

#define CellCount 20
#define ExpandCount 1 //目前是1行操作的cell.可加多或者删除多个。

@interface CellInsertViewController ()<UITableViewDataSource,UITableViewDelegate,OperateTableViewCellDelegate>

@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)NSMutableArray *dataArray;

@property (assign, nonatomic) BOOL isExpand; //是否展开
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;//展开的cell的下标

@end

@implementation CellInsertViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"插入cell";
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isExpand) {
        return self.dataArray.count + ExpandCount;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.isExpand && self.selectedIndexPath.row < indexPath.row && indexPath.row <= self.selectedIndexPath.row + ExpandCount) {
        
        OperateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"operate" forIndexPath:indexPath];
        ItemModel *model = self.dataArray[self.selectedIndexPath.row];
        [cell setItemModel:model];
        cell.delegate = self;
        return cell;
    } else if (self.isExpand && self.selectedIndexPath.row + ExpandCount < indexPath.row) {
        
        ItemModel *model = self.dataArray[indexPath.row - ExpandCount];
        MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"main" forIndexPath:indexPath];
        cell.textLabel.text = model.title;
        return cell;
    
    } else {
        ItemModel *model = self.dataArray[indexPath.row];
        MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"main" forIndexPath:indexPath];
        cell.textLabel.text = model.title;
        return cell;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isExpand && indexPath.row  <= self.selectedIndexPath.row + ExpandCount && indexPath.row >  self.selectedIndexPath.row ) {
        return 87;
    } else {
        return 44;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.selectedIndexPath) {
        self.isExpand = YES;
        self.selectedIndexPath = indexPath;
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:[self indexPathsForExpandRow:indexPath.row] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    } else {
        if (self.isExpand) {
            if (self.selectedIndexPath == indexPath) {
                self.isExpand = NO;
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:[self indexPathsForExpandRow:indexPath.row] withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];
                self.selectedIndexPath = nil;
            } else if (self.selectedIndexPath.row < indexPath.row && indexPath.row <= self.selectedIndexPath.row + ExpandCount) {
                
            } else if ( indexPath.row > self.selectedIndexPath.row + ExpandCount) {
                self.isExpand = NO;
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:[self indexPathsForExpandRow:self.selectedIndexPath.row] withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];
                self.selectedIndexPath = nil;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.isExpand = YES;
                    self.selectedIndexPath = [NSIndexPath indexPathForRow:indexPath.row -ExpandCount  inSection:0];
                    [self.tableView beginUpdates];
                    [self.tableView insertRowsAtIndexPaths:[self indexPathsForExpandRow:self.selectedIndexPath.row] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self.tableView endUpdates];
                });
                
            } else {
                
                self.isExpand = NO;
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:[self indexPathsForExpandRow:self.selectedIndexPath.row] withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];
                self.selectedIndexPath = nil;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.isExpand = YES;
                    self.selectedIndexPath = indexPath;
                    [self.tableView beginUpdates];
                    [self.tableView insertRowsAtIndexPaths:[self indexPathsForExpandRow:self.selectedIndexPath.row] withRowAnimation:UITableViewRowAnimationTop];
                    [self.tableView endUpdates];
                });
            
            }
        }
    }
    
    
    
    
}



#pragma mark - other

- (NSArray *)indexPathsForExpandRow:(NSInteger)row {
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int i = 1; i <= ExpandCount; i++) {
        NSIndexPath *idxPth = [NSIndexPath indexPathForRow:row + i inSection:0];
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
                    ItemModel *model = self.dataArray[self.selectedIndexPath.row];
                    model.title = userEmail.text;
                    
                    [self.tableView reloadRowsAtIndexPaths:@[self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                    
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
            
            [self.dataArray removeObjectAtIndex:self.selectedIndexPath.row];
            [self.tableView beginUpdates];
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:[self indexPathsForExpandRow:self.selectedIndexPath.row]];
            [array addObject:self.selectedIndexPath];
            [self.tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationRight];
            [self.tableView endUpdates];
            
            self.selectedIndexPath = nil;
            
        }
            
            break;
            
        default:
            break;
    }
    
}



@end
