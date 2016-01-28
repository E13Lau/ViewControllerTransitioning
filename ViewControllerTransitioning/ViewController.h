//
//  ViewController.h
//  ViewControllerTransitioning
//
//  Created by command.Zi on 16/1/25.
//  Copyright © 2016年 command.Zi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, assign) UIViewController *selectedViewController;

@property (nonatomic, strong) UIView *privateContainerView; /// The view hosting the child view controllers views.

@property (nonatomic, assign) UIEdgeInsets parentContentInset;

@end

