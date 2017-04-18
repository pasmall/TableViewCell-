//
//  OperateTableViewCell.m
//  TableViewMenu
//
//  Created by lyric on 2017/4/17.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import "OperateTableViewCell.h"
#import "EditCollectionViewCell.h"

#define EDIT_IDTIFER @"editcollection"

@interface OperateTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate>{
    NSArray *imageNames;
    NSArray *titleStrings;
    
}


@property (weak,nonatomic)UICollectionView *editCollectionView;

@end


@implementation OperateTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
        flowlayout.minimumLineSpacing = 0;
        flowlayout.minimumInteritemSpacing = 0;
        flowlayout.itemSize = CGSizeMake(87, 87);
        flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 87 ) collectionViewLayout:flowlayout];
        [collectionView registerClass:[EditCollectionViewCell class] forCellWithReuseIdentifier:EDIT_IDTIFER];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor clearColor];
        [self addSubview:collectionView];
        self.editCollectionView = collectionView;
        
        //self
        self.backgroundColor = [UIColor colorWithRed:230.0/250.0 green:230.0/250.0 blue:230.0/250.0 alpha:1];
        
        
    }
    return self;
}


-(void)setItemModel:(ItemModel *)itemModel
{
    _itemModel = itemModel;
    
    imageNames = @[@"修改昵称",@"删除"];
    titleStrings = @[@"重命名",@"删除"];

    [self.editCollectionView reloadData];
    
    
}

#pragma mark  UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imageNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EditCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:EDIT_IDTIFER forIndexPath:indexPath];
    [cell setTitile:titleStrings[indexPath.row] andImageName:imageNames[indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didSelectItem:andModel:)]) {
        [self.delegate didSelectItem:indexPath.row andModel:self.itemModel];
    }


}



@end
