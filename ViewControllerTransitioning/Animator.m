//
//  Animator.m
//  ViewControllerTransitioning
//
//  Created by command.Zi on 16/1/25.
//  Copyright © 2016年 command.Zi. All rights reserved.
//
/**
 该类为一个遵从 UIViewControllerAnimatedTransitioning 协议的动画控制器
 **/

#import "Animator.h"

@implementation Animator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    //将替换的 Controller.View 加到 容器View
    [[transitionContext containerView] addSubview:toViewController.view];
    //替换的 Controller.View 初始 alpha 值为0
    toViewController.view.alpha = 0;
    
    //动画
    /**
     duration 使用当前协议方法返回的值
     animations 结束状态 block
     completion 完成状态 block
     ???????[transitionContext completeTransition:![transitionContext transitionWasCancelled]];
     **/
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromViewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
        toViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        fromViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];

    
}

@end
