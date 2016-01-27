//
//  LeftRightAnimator.m
//  ViewControllerTransitioning
//
//  Created by command.Zi on 16/1/25.
//  Copyright © 2016年 command.Zi. All rights reserved.
//


#import "LeftRightAnimator.h"

@implementation LeftRightAnimator

static CGFloat const kChildViewPadding = 16;
static CGFloat const kDamping = 0.75;
static CGFloat const kInitialSpringVelocity = 0.1;


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController * formController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //找出转右还是转左
    //所用信息从 transitionContext 中得到。
    //如果 替代的 Controller 开始的 origin.x < 完成的 origin.x
    //即
    //|    | to --- 开始
    //| to |    --- 完成
    //goingRight = YES;
    BOOL goingRight = ([transitionContext initialFrameForViewController:toController].origin.x < [transitionContext finalFrameForViewController:toController].origin.x);
    //移动距离＋padding
    CGFloat travelDistance = [transitionContext containerView].bounds.size.width + kChildViewPadding;
    //????
    CGAffineTransform travel = CGAffineTransformMakeTranslation (goingRight ? travelDistance : -travelDistance, 0);

    [[transitionContext containerView] addSubview:toController.view];
    toController.view.alpha = 0;
    toController.view.transform = CGAffineTransformInvert (travel);
    
    /**创建一个弹性动画
     delay 延迟
     Damping ?
     Velocity 速度
     options ?
     
     **/
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:kDamping initialSpringVelocity:kInitialSpringVelocity options:0x00 animations:^{
        //动画末尾各自状态
        formController.view.transform = travel;
        formController.view.alpha = 0;
        //CGAffineTransformIdentity????
        toController.view.transform = CGAffineTransformIdentity;
        toController.view.alpha = 1;
    } completion:^(BOOL finished) {
        //动画完成通知 transitionContext 我完成动画了
        formController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
