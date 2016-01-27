//
//  buttonsOfBottom.h
//  ViewControllerTransitioning
//
//  Created by command.Zi on 16/1/25.
//  Copyright © 2016年 command.Zi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class buttonsOfBottom;
@protocol buttonsOfBottomDelegate <NSObject>

- (void)selectButtonIndex:(NSUInteger)index;

@end

@interface buttonsOfBottom : UIView

@property (nonatomic, weak) id<buttonsOfBottomDelegate> delegate;

@end
