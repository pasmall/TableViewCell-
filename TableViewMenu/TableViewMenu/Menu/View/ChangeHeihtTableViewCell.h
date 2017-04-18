//
//  ChangeHeihtTableViewCell.h
//  TableViewMenu
//
//  Created by lyric on 2017/4/18.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemModel;

@protocol ChangeHeihtTableViewCellDelegate <NSObject>

- (void)didTapActionWithIndex:(NSInteger)index andModel:(ItemModel *)model;

@end

@interface ChangeHeihtTableViewCell : UITableViewCell

@property(nonatomic, strong)ItemModel *itemModel;
@property(nonatomic, weak)id<ChangeHeihtTableViewCellDelegate> delegate;

- (void)createCellViewsWithItem:(ItemModel *)itemModel andIsOpen:(BOOL)isOpe;

@end
