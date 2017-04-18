//
//  EditDeviceCollectionViewCell.m
//  HotWindPro
//
//  Created by lyric on 2017/3/28.
//  Copyright © 2017年 lyice. All rights reserved.
//

#import "EditCollectionViewCell.h"

@interface EditCollectionViewCell ()

@property(nonatomic , strong)UIImageView *iconImageView;//左侧图标
@property(nonatomic , strong)UILabel *titleLabel;//左侧标题

@end

@implementation EditCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_iconImageView];
        
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_titleLabel];
        self.backgroundColor = [UIColor clearColor];
          
    }
    return self;
}

//给cell设置title和图片
- (void)setTitile:(NSString *)title andImageName:(NSString *)imageName
{
    
     _titleLabel.text = title;
    _iconImageView.image = [UIImage imageNamed:imageName];
    
    [self setSubViewFrame];
}

//设置cell子控件frame
- (void)setSubViewFrame
{
    
    _titleLabel.frame = CGRectMake(0, self.bounds.size.height - 20 - 10, self.bounds.size.width, 20);
    
    _iconImageView.frame = CGRectMake(self.bounds.size.width/2 - 15, 11,  30, 30);

}



@end
