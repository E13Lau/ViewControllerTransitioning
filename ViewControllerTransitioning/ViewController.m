//
//  ViewController.m
//  ViewControllerTransitioning
//
//  Created by command.Zi on 16/1/25.
//  Copyright © 2016年 command.Zi. All rights reserved.
//  Private 作用在于封装该 ViewController 时，能提供一个默认的id类

#import "ViewController.h"
#import <Masonry.h>
#import "AViewController.h"
#import "buttonsOfBottom.h"
#import "Animator.h"
#import "LeftRightAnimator.h"

#pragma mark - Private Transitioning Classes
//传递给动画控制器的上下文
//animator 应该只关心它自己以及传递给它的上下文，因为这样，在理想情况下，animator 可以在不同的上下文中得到复用。
//把视图的出现和消失时的状态记录了下来，比如初始状态和最终状态的 frame。

@interface PrivateTransitionContext : NSObject <UIViewControllerContextTransitioning>

//指定init方法
- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController goingRight:(BOOL)goingRight; /// Designated initializer.
//在收到 completeTransition 之后执行设置的代码块。
@property (nonatomic, copy) void (^completionBlock)(BOOL didComplete); /// A block of code we can set to execute after having received the completeTransition: message.
//getter=isAnimated??????
//
@property (nonatomic, assign, getter=isAnimated) BOOL animated; /// Private setter for the animated property.
@property (nonatomic, assign, getter=isInteractive) BOOL interactive; /// Private setter for the interactive property.

@end

#pragma mark - ViewController

@interface ViewController () <buttonsOfBottomDelegate> {
    NSMutableArray * controllers;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    self.privateContainerView = [[UIView alloc]init];
    [self.view addSubview:self.privateContainerView];
    [self.privateContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //这里与 privateContainerView 分开添加到 rootView，childView 加到 privateContainerView 中，就不会挡住 buttons View
    buttonsOfBottom * bottomView = [[buttonsOfBottom alloc]init];
    bottomView.tag = 555;
    bottomView.delegate = self;
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo(56);
    }];
    
    controllers = [NSMutableArray new];
    
    AViewController * aController = [AViewController new];
    aController.view.backgroundColor = [UIColor yellowColor];
    AViewController * bController = [AViewController new];
    bController.view.backgroundColor = [UIColor blueColor];
    AViewController * cController = [AViewController new];
    cController.view.backgroundColor = [UIColor greenColor];
    
    [controllers addObject:aController];
    [controllers addObject:bController];
    [controllers addObject:cController];
    
    self.selectedViewController = (self.selectedViewController ? : controllers[0]);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController {
    //??????
    NSParameterAssert(selectedViewController);
    [self _transitionToChildViewController:selectedViewController];
    _selectedViewController = selectedViewController;
}

- (void)_transitionToChildViewController:(UIViewController *)toViewController {
    
    //如果有，就获取当前childViewController的第一个
    UIViewController *fromViewController = ([self.childViewControllers count] > 0 ? self.childViewControllers[0] : nil);
    //如果toViewController ＝＝ fromViewController 或者当前没加载好 return
    if (toViewController == fromViewController || ![self isViewLoaded]) {
        return;
    }
    
    
    //获取 去的View
    UIView *toView = toViewController.view;
    
//    //?????
//    [toView setTranslatesAutoresizingMaskIntoConstraints:YES];
//    //?????
//    toView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    toView.frame = self.privateContainerView.bounds;
    
    
    //通知 来的controller 将要move到Parent:nil
    [fromViewController willMoveToParentViewController:nil];
    /**
     先加controller，加View
     removeview 再remove Controller
     **/
    //当前加 去的Controller 到子controller
    [self addChildViewController:toViewController];
    //当前View 添加去的View
    [self.privateContainerView addSubview:toView];
    
    //注释掉上面三句，加下面一句，同样可用，异同为止
    [toView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.privateContainerView);
    }];
    
    /** 移动到动画完成后
    //来的Controller removeFromSuperview
    [fromViewController.view removeFromSuperview];
    //来的Controller removeFromParentViewController
    [fromViewController removeFromParentViewController];
    //通知去的Controller 完成了move到当前
    [toViewController didMoveToParentViewController:self];
     **/
    
    /**
     顺序
     [fromViewController willMoveToParentViewController:nil];
     [self addChildViewController:toViewController];
     [self.privateContainerView addSubview:toView];
     -布局-
     [fromViewController.view removeFromSuperview];
     [fromViewController removeFromParentViewController];
     [toViewController didMoveToParentViewController:self];
     **/
    
    // If this is the initial presentation, add the new child with no animation.
    //如果是初始的 Controller，没有动画
    if (!fromViewController) {
        [self.privateContainerView addSubview:toViewController.view];
        [toViewController didMoveToParentViewController:self];
        return;
    }
    
    // Animate the transition by calling the animator with our private transition context.
    //通过调用与我们私人过渡上下文动画动画过渡。
    
    id<UIViewControllerAnimatedTransitioning> animator = [[LeftRightAnimator alloc] init];
    
    //找出bottomView
    UIView * bottomView = [self.view viewWithTag:555];
    
    // Because of the nature of our view controller, with horizontally arranged buttons, we instantiate our private transition context with information about whether this is a left-to-right or right-to-left transition. The animator can use this information if it wants.
    //由于我们的视图控制器，使用水平排列的按钮，我们实例化我们私人过渡上下文信息是否这是左到右或从右到左的过渡。如果它想，动画师可以使用此信息。
    //被替换的Index
    NSUInteger fromIndex = [controllers indexOfObject:fromViewController];
    //替换的Index
    NSUInteger toIndex = [controllers indexOfObject:toViewController];
    /**
     init PrivateTransitionContext 给 动画控制器 animator 使用
     goingRight 根据 toIndex > fromIndex ? 判断，水平移动
     
     **/
    PrivateTransitionContext *transitionContext = [[PrivateTransitionContext alloc] initWithFromViewController:fromViewController toViewController:toViewController goingRight:toIndex > fromIndex];
    
    
    //animated 动画
    transitionContext.animated = YES;
    //interactive 交互
    transitionContext.interactive = NO;
    //从 animator 处获知动画完成，接着运行代码块
    transitionContext.completionBlock = ^(BOOL didComplete) {
        //被移动到这的
        [fromViewController.view removeFromSuperview];
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
        
        //如果 animator 实现了 animationEnded: 方法
        if ([animator respondsToSelector:@selector (animationEnded:)]) {
            [animator animationEnded:didComplete];
        }
        bottomView.userInteractionEnabled = YES;
    };
    
    bottomView.userInteractionEnabled = NO; // Prevent user tapping buttons mid-transition, messing up state
    //防止用户点击按钮中间过渡阶段，搞乱了状态
    [animator animateTransition:transitionContext];
}

#pragma mark - delegate
- (void)selectButtonIndex:(NSUInteger)index {
    self.selectedViewController = controllers[index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


#pragma mark - PrivateTransitionContext

@interface PrivateTransitionContext()

//??????何时用strong、何时assign、何时weak

@property (nonatomic, strong) NSDictionary *privateViewControllers;
//包括被替代的 Controller 开始、结束状态的frame
//包括替代的 Controller 开始、结束状态的frame
@property (nonatomic, assign) CGRect privateDisappearingFromRect;
@property (nonatomic, assign) CGRect privateAppearingFromRect;
@property (nonatomic, assign) CGRect privateDisappearingToRect;
@property (nonatomic, assign) CGRect privateAppearingToRect;
//Controller 的 View 的 容器View
@property (nonatomic, weak) UIView *containerView;
//??????
@property (nonatomic, assign) UIModalPresentationStyle presentationStyle;

@end

@implementation PrivateTransitionContext

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController goingRight:(BOOL)goingRight {
    //NSAssert??????
    NSAssert ([fromViewController isViewLoaded] && fromViewController.view.superview, @"The fromViewController view must reside in the container view upon initializing the transition context.");
    
    if ((self = [super init])) {
        self.presentationStyle = UIModalPresentationCustom;
        //从将被替换的ViewController中获得容器View
        self.containerView = fromViewController.view.superview;
        //用键UITransitionContextFromViewControllerKey、UITransitionContextToViewControllerKey与传进来的Controller生成字典
        self.privateViewControllers = @{
                                        UITransitionContextFromViewControllerKey:fromViewController,
                                        UITransitionContextToViewControllerKey:toViewController,
                                        };
        
        // Set the view frame properties which make sense in our specialized ContainerViewController context. Views appear from and disappear to the sides, corresponding to where the icon buttons are positioned. So tapping a button to the right of the currently selected, makes the view disappear to the left and the new view appear from the right. The animator object can choose to use this to determine whether the transition should be going left to right, or right to left, for example.
        //根据传入的rightBOOL值计算 两个 Controller 移动的距离
        //toViewController 移动的距离
        //goingRight == YES  ---||之间为容器View
        //    |form| to
        //form| to |
        //因此 right 时 toView 的移动距离是 -self.containerView.bounds.size.width
        //goingRight == NO---同理
        // to |form|
        //    | to |form
        CGFloat travelDistance = (goingRight ? -self.containerView.bounds.size.width : self.containerView.bounds.size.width);
        //???怎么用自动布局，还是不能用？？
        //CGRectOffset 计算(x,y)偏移Rect
        //formView 从 || 之间消失
        //formView 开始状态的 bounds 与 toView 出现的 bounds 与 容器 View 的 Bounds 相同
        //toView 开始状态的 bounds = 容器View 的 Bounds 偏移 (x:travelDistance,y:0)
        //formView 结束状态的 bounds = 容器View 的 Bounds 偏移 (x:-travelDistance,y:0)
        
        //消失 可理解为开始状态
        //出现 可理解为结束状态
        
        self.privateDisappearingFromRect = self.privateAppearingToRect = self.containerView.bounds;
        self.privateDisappearingToRect = CGRectOffset (self.containerView.bounds, travelDistance, 0);
        self.privateAppearingFromRect = CGRectOffset (self.containerView.bounds, -travelDistance, 0);
    }
    
    return self;
}

//from、to ViewController 开始状态的Rect
- (CGRect)initialFrameForViewController:(UIViewController *)viewController {
    if (viewController == [self viewControllerForKey:UITransitionContextFromViewControllerKey]) {
        //如果是被替换的 Controller，返回替换 Controller 的开始状态的 Rect
        return self.privateDisappearingFromRect;
    } else {
        //如果是替换 Controller ，返回替换 Controller 的结束状态的 Rect
        return self.privateAppearingFromRect;
    }
}

//form、to ViewController 结束状态的Rect
- (CGRect)finalFrameForViewController:(UIViewController *)viewController {
    if (viewController == [self viewControllerForKey:UITransitionContextFromViewControllerKey]) {
        //如果是被替换的 Controller，返回替换 Controller 的开始状态的 Rect
        return self.privateDisappearingToRect;
    } else {
        //如果是替换 Controller ，返回替换 Controller 的结束状态的 Rect
        return self.privateAppearingToRect;
    }
}

//根据key返回相应 ViewController
- (UIViewController *)viewControllerForKey:(NSString *)key {
    return self.privateViewControllers[key];
}

//completeTransition 事件 block 回调
- (void)completeTransition:(BOOL)didComplete {
    if (self.completionBlock) {
        self.completionBlock (didComplete);
    }
}

//不能取消我们非交互式的过渡 (它可能被中断，尽管)
- (BOOL)transitionWasCancelled { return NO; } // Our non-interactive transition can't be cancelled (it could be interrupted, though)

// Supress warnings by implementing empty interaction methods for the remainder of the protocol:
// 没实现，但是消除警告
- (void)updateInteractiveTransition:(CGFloat)percentComplete {}
- (void)finishInteractiveTransition {}
- (void)cancelInteractiveTransition {}

@end


