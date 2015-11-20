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
 *  在viewDidAppear中调用StartNavigationScroll方法
 *  在viewWillDisappear中调用endNavigationScroll方法
 *  automaticallyAdjustsScrollViewInsets会设置为NO，自己调整Scrollview的contentInset
 */
@property (strong, nonatomic) UIScrollView *mm_ScrollView;

/**
 *  开始导航栏的滚动，显示/隐藏导航栏
 */
-(void)startNavigationScroll;

/**
 *  结束导航栏的滚动,显示导航栏和状态栏
 */
-(void)endNavigationScroll;

/**
 *  移除scrollView的Observer
 */
-(void)removeScrollViewObserver;

@end
