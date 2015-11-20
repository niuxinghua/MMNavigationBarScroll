//
//  UIViewController+NavigationBarScroll.m
//  NavigationBarHideDemo
//
//  Created by zlmg on 11/12/15.
//  Copyright © 2015 zlmg. All rights reserved.
//

#import "UIViewController+NavigationBarScroll.h"
#import <objc/runtime.h>

static NSString * const kMMScrollViewKey = @"kMMScrollViewKey";
static NSString * const kMMScrollViewOldOffsetYKey = @"kMMScrollViewOldOffsetYKey";
static NSString * const kMMScrollViewEndKey =  @"kMMScrollViewEndKey";
static CGFloat const scrollSpace = 25;

@interface UIViewController()

@property (assign, nonatomic) CGFloat oldOffsetY;
/** 是否结束操作,viewController返回时结束对导航栏的操作 */
@property (assign, nonatomic) BOOL isEndNavigation;

@end

@implementation UIViewController (NavigationBarScroll)

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == @"mmScrollView") {
        //滚动结束、上拉刷新、下拉加载时不进行操作
        if (self.isEndNavigation ||
            self.mm_ScrollView.contentOffset.y - self.mm_ScrollView.contentInset.top < 0 ||
            self.mm_ScrollView.contentOffset.y > (self.mm_ScrollView.contentSize.height - self.mm_ScrollView.frame.size.height + 64))
        {
            return ;
        }
        //隐藏navigation和stateBar
        if (self.mm_ScrollView.contentOffset.y - scrollSpace > self.oldOffsetY) {
//            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
            [self setNeedsStatusBarAppearanceUpdate];
            [UIView animateWithDuration:0.5 animations:^{
                //隐藏导航栏
                CGRect frame = self.navigationController.navigationBar.frame;
                frame.origin.y = -44;
                self.navigationController.navigationBar.frame = frame;
            } ];
            //调整inset
            UIEdgeInsets insets = self.mm_ScrollView.contentInset;
            insets.top = 0;
            self.mm_ScrollView.contentInset = insets;
            self.oldOffsetY = self.mm_ScrollView.contentOffset.y;
        }
        //显示navigation和stateBar
        else if(self.mm_ScrollView.contentOffset.y + scrollSpace < self.oldOffsetY) {
//            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
            [self setNeedsStatusBarAppearanceUpdate];
            [UIView animateWithDuration:0.5 animations:^{
                //显示导航栏
                CGRect frame = self.navigationController.navigationBar.frame;
                frame.origin.y = 20;
                self.navigationController.navigationBar.frame = frame;
            }];
            //调整inset
            UIEdgeInsets insets = self.mm_ScrollView.contentInset;
            insets.top = 64;
            self.mm_ScrollView.contentInset = insets;
            self.oldOffsetY = self.mm_ScrollView.contentOffset.y;
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)startNavigationScroll
{
    self.isEndNavigation = NO;
}

-(void)endNavigationScroll
{
    self.isEndNavigation = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBarHidden = NO;
    self.oldOffsetY = self.mm_ScrollView.contentOffset.y;
}

-(void)removeScrollViewObserver
{
    [self.mm_ScrollView removeObserver:self forKeyPath:@"contentOffset"];
}
#pragma mark - 属性方法
-(UIScrollView *)mm_ScrollView
{
    return objc_getAssociatedObject(self, &kMMScrollViewKey);
}

-(void)setMm_ScrollView:(UIScrollView *)mm_ScrollView
{
    objc_setAssociatedObject(self, &kMMScrollViewKey, mm_ScrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [mm_ScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"mmScrollView"];
    self.isEndNavigation = NO;
    //代码调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIEdgeInsets insets = self.mm_ScrollView.contentInset;
    insets.top = 64;
    self.mm_ScrollView.contentInset = insets;
}

-(CGFloat)oldOffsetY
{
    NSNumber *offsetY = objc_getAssociatedObject(self, &kMMScrollViewOldOffsetYKey);
    return  [offsetY floatValue];
}

-(void)setOldOffsetY:(CGFloat)oldOffsetY
{
    NSNumber *offsetY = [NSNumber numberWithFloat:oldOffsetY];
    objc_setAssociatedObject(self, &kMMScrollViewOldOffsetYKey, offsetY, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)isEndNavigation
{
    NSNumber *isEnd = objc_getAssociatedObject(self, &kMMScrollViewEndKey);
    return isEnd.boolValue;
}

-(void)setIsEndNavigation:(BOOL)isEndNavigation
{
    NSNumber *isEnd = [NSNumber numberWithBool:isEndNavigation];
    objc_setAssociatedObject(self, &kMMScrollViewEndKey, isEnd, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)prefersStatusBarHidden
{
    if (self.mm_ScrollView.contentOffset.y - scrollSpace > self.oldOffsetY) {
        return YES;
    }
    else if(self.mm_ScrollView.contentOffset.y + scrollSpace < self.oldOffsetY) {
        NO;
    }
    return NO;
}

@end
