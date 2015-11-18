//
//  UIViewController+NavigationBarScroll.h
//  NavigationBarHideDemo
//
//  Created by zlmg on 11/12/15.
//  Copyright © 2015 zlmg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationBarScroll)

/**
 *  在viewController的dealloc一定要调用removeScrollViewObserver方法。
 *  如果要在页面消失时显示导航栏，可以在viewWillDisappear中调用showNavigationAndStateBar方法
 *  automaticallyAdjustsScrollViewInsets会设置为YES
 */
@property (strong, nonatomic) UIScrollView *mm_ScrollView;

/**
 *  显示导航栏和状态栏
 */
-(void)showNavigationAndStateBar;

/**
 *  移除scrollView的Observer
 */
-(void)removeScrollViewObserver;

@end
