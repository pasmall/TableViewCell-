//
//  ItemModel.m
//  TableViewMenu
//
//  Created by lyric on 2017/4/17.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import "ItemModel.h"

@implementation ItemModel

- (instancetype)initWithID:(NSInteger) itemId andTitle:(NSString *)title
{
    
    self = [super init];
    if (self) {
        
        self.itemID = itemId;
        self.title = title;
    }
    return self;

}


@end
