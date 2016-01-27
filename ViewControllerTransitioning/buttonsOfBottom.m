//
//  buttonsOfBottom.m
//  ViewControllerTransitioning
//
//  Created by command.Zi on 16/1/25.
//  Copyright © 2016年 command.Zi. All rights reserved.
//

#import "buttonsOfBottom.h"
#import <Masonry.h>

@implementation buttonsOfBottom

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupButtons];
    }
    return self;
}

- (void)setupButtons {
    UIButton * button0 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button0 setTitle:@"0" forState:UIControlStateNormal];
    [button0 setBackgroundColor:[UIColor lightGrayColor]];
    button0.tag = 0;
    [button0 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button0];
    [button0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.equalTo(self);
    }];
    
    for (int i = 1; i <= 2; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor lightGrayColor]];
        button.tag = i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        if (i == 2) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(self);
            }];
        }
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(button0.mas_trailing);
            make.top.bottom.equalTo(self);
            make.width.equalTo(button0);
        }];
        button0 = button;
    }

}

- (IBAction)buttonAction:(id)sender {
    UIButton * button = sender;
    if ([self.delegate respondsToSelector:@selector(selectButtonIndex:)]) {
        [self.delegate selectButtonIndex:button.tag];
    }
//    self.selectedViewController = controllers[button.tag];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
