//
//  LTContactHeaderView.h
//  TesChat
//
//  Created by Lenhulk on 2016/12/14.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTContactHeaderView : UIView

+ (instancetype)headerView;

@property (nonatomic, strong) UIView *badgeView;

/**
 * 记录选中的headerView的按钮
 */
@property (nonatomic, copy) void (^selectedBlock) (NSInteger index);

@end
