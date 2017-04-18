//
//  OperateTableViewCell.h
//  TableViewMenu
//
//  Created by lyric on 2017/4/17.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, TapType) {
    TapTypeOne, //重命名
    TapTypeTwo, //删除
};


@class ItemModel;

@protocol OperateTableViewCellDelegate <NSObject>

- (void)didSelectItem:(NSInteger)index andModel:(ItemModel *)model;

@end

@interface OperateTableViewCell : UITableViewCell


@property(nonatomic,weak)id<OperateTableViewCellDelegate> delegate;
@property(nonatomic, strong)ItemModel *itemModel;

@end
