//
//  ChangeCellHeightViewController.m
//  TableViewMenu
//
//  Created by lyric on 2017/4/18.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import "ChangeCellHeightViewController.h"
#import "ChangeHeihtTableViewCell.h"
#import "ItemModel.h"

#define CellCount 20
#define ExpandCount 0 //改变cell高，展开的内容写在Cell里面。

@interface ChangeCellHeightViewController ()<UITableViewDataSource,UITableViewDelegate , ChangeHeihtTableViewCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *dataArray;
@property (assign, nonatomic) NSInteger indexRow;
@property (assign, nonatomic)CGFloat cellHeight;


@end

@implementation ChangeCellHeightViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"改变Cell高";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    _indexRow = -1;
    _cellHeight = 87 + 44;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource =self;
        [_tableView registerClass:[ChangeHeihtTableViewCell class] forCellReuseIdentifier:@"cell"];

        
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

#pragma mark TableViewDelegate || TableViewDateSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChangeHeihtTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    [cell createCellViewsWithItem:self.dataArray[indexPath.row] andIsOpen:indexPath.row ==_indexRow ? YES : NO];
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == _indexRow) {
        
        _indexRow = -1;
        [self.tableView beginUpdates];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        
        return;
    } else if (indexPath.row < _indexRow) {
    
        NSIndexPath *idxPth = [NSIndexPath indexPathForRow:_indexRow inSection:0];
        [self.tableView beginUpdates];
        [tableView reloadRowsAtIndexPaths:@[idxPth] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        
    } else {
        
       [self.tableView reloadData];
    }
    
    
    _indexRow = indexPath.row;
    [self.tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ceilf(indexPath.row ==_indexRow ? _cellHeight:44);
}

- (void)didTapActionWithIndex:(NSInteger)index andModel:(ItemModel *)model
{
    switch (index) {
        case 0:{
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *tipAlertController = [UIAlertController alertControllerWithTitle:@"重命名"  message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *OkAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    UITextField *userEmail = tipAlertController.textFields.firstObject;
                    ItemModel *model = self.dataArray[_indexRow];
                    model.title = userEmail.text;
                    
                    NSIndexPath *idxPth = [NSIndexPath indexPathForRow:_indexRow inSection:0];
                    [self.tableView beginUpdates];
                    [self.tableView reloadRowsAtIndexPaths:@[idxPth] withRowAnimation:UITableViewRowAnimationAutomatic];
                     [self.tableView endUpdates];
                    
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
        case 1:{
            
            [self.dataArray removeObjectAtIndex:_indexRow];
            NSIndexPath *idxPth = [NSIndexPath indexPathForRow:_indexRow inSection:0];
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[idxPth] withRowAnimation:UITableViewRowAnimationRight];
            [self.tableView endUpdates];
            _indexRow = -1;
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView beginUpdates];
                [self.tableView reloadRowsAtIndexPaths:@[idxPth] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView endUpdates];
            });

            
        }
            
            break;
            
        default:
            break;
    }

}




@end
