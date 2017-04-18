//
//  ChangeHeihtTableViewCell.m
//  TableViewMenu
//
//  Created by lyric on 2017/4/18.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import "ChangeHeihtTableViewCell.h"
#import "EditCollectionViewCell.h"
#import "ItemModel.h"

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

#define EDIT_IDTIFER @"editcollection"

@interface ChangeHeihtTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    NSArray *imageNames;
    NSArray *titleStrings;
    UILabel *titleLabel;
    
}

@property (weak,nonatomic)UICollectionView *editCollectionView;

@end

@implementation ChangeHeihtTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_SIZE.width, 24)];
        [self addSubview:titleLabel];
        
        
    }
    return self;
}

- (void)createCellViewsWithItem:(ItemModel *)itemModel andIsOpen:(BOOL)isOpe
{
    _itemModel = itemModel;
    titleLabel.text = itemModel.title;
    if (isOpe) {
        
        
        
        imageNames = @[@"修改昵称",@"删除"];
        titleStrings = @[@"重命名",@"删除"];
 
        self.editCollectionView.hidden = NO;

    }else{
    
        _editCollectionView.hidden = YES;
    }
}


- (UICollectionView *)editCollectionView
{
    
    if (!_editCollectionView) {
        
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
        flowlayout.minimumLineSpacing = 0;
        flowlayout.minimumInteritemSpacing = 0;
        flowlayout.itemSize = CGSizeMake(87, 87);
        flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, 87) collectionViewLayout:flowlayout];
        [collectionView registerClass:[EditCollectionViewCell class] forCellWithReuseIdentifier:EDIT_IDTIFER];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor clearColor];
        _editCollectionView = collectionView;
        _editCollectionView.backgroundColor = [UIColor colorWithRed:230.0/250.0 green:230.0/250.0 blue:230.0/250.0 alpha:1];
        [self addSubview:_editCollectionView];
    }
    
    
    return _editCollectionView;
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
    if ([self.delegate respondsToSelector:@selector(didTapActionWithIndex:andModel:)]) {
        [self.delegate didTapActionWithIndex:indexPath.row andModel:_itemModel];
    }
    
    
}



@end
