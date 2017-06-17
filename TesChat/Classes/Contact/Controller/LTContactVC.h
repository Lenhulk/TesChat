//
//  LTContactVC.h
//  TesChat
//
//  Created by Lenhulk on 2016/12/14.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTContactVC : UITableViewController

//暴露该方法用于监听到tabbarItem变化时候对headerView进行实时更新
/**
 * 重新设置headerView&tabbarItem的badge
 */
- (void)setupBadge;
@end
