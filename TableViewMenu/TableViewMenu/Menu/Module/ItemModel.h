//
//  ItemModel.h
//  TableViewMenu
//
//  Created by lyric on 2017/4/17.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemModel : NSObject

@property (nonatomic, assign) NSInteger itemID;
@property (nonatomic, strong) NSString *title;


- (instancetype)initWithID:(NSInteger) id andTitle:(NSString *)title;

@end
